# frozen_string_literal: true

class Course < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :students, through: :participations, source: :user
  has_many :certificates, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :completion_records, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :course_accesses, dependent: :destroy
  has_many :allowed_users, through: :course_accesses, source: :user

  enum difficulty: %i[unspecified novice intermediate advanced professional]
  enum visibility: %i[everyone organization individuals]
  enum status: %i[drafted published archived]

  validates :name, presence: true, length: { in: 4..20 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :difficulty, presence: true, inclusion: { in: difficulties.keys }
  validates :description, length: { maximum: 500 }
  validate :check_visibility_and_owner

  after_commit on: [:create] do
    __elasticsearch__.index_document if self.published?
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document if self.published?
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document if self.published?
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :id,           type: :integer
      indexes :name,         type: :text, analyzer: :english
      indexes :duration,     type: :integer
      indexes :difficulty,   type: :keyword
      indexes :description,  type: :text, analyzer: :english
      indexes :status,       type: :keyword
      indexes :created_at,   type: :date
      indexes :updated_at,   type: :date
      indexes :visibility,   type: :text, analyzer: :english
      indexes :owner_for_elastic, type: :keyword
      indexes :pages,        type: :object do 
        indexes :html,         type: :text
      end
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      methods: :owner_for_elastic,
      only: [ :id, :name, :duration, :difficulty, :description, :status, :visibility, 
        :created_at, :updated_at],
      include: {
        pages: {
          only: [:html]
        }
      }
    )
  end

  def self.search_custom(query,
    difficulty = %i[unspecified novice intermediate advanced professional],
    owner = Course.search('*').map(&:owner_for_elastic).uniq!,
    status = 'published',
    visibility = 'everyone')

    __elasticsearch__.search(
      { from: 0, size: 50,
        query: { 
          bool: {
            must: [
              { match: { status: status } },
              { match: { visibility: visibility } },
              { 
                multi_match: {
                  query: query,
                  fields: [:name, :description, 'pages.html'],
                  fuzziness: 'auto'
                }
              }
            ],
            filter: {
              terms: { 
                difficulty: difficulty
                
              }
            },
            filter: {
              terms: { 
                owner_for_elastic: owner
              }
            }
          }   
        },
        highlight: { 
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: [
            { name: {} },
            { description: {} },
            { 'pages.html': {} }
          ]
        },
        sort: { updated_at: { order: 'asc' }}
      }
    )
  end

  def owner_for_elastic
    if owner.instance_of?(User)
      return "user: #{owner.profile.nickname}"
    elsif owner.instance_of?(Organization)
      return "organization: #{owner.name}"
    end
  end

  def owner
    owner_record = ownership
    owner_record.nil? ? owner_record : owner_record.ownable
  end

  def check_visibility_and_owner
    if !owner.instance_of?(Organization) && organization?
      errors.add(:visibility, "Can't be created only for organizations if the user is not an organization admin.")
    end
  end

  def owner?(user)
    if owner.instance_of?(User)
      owner == user
    else
      user.in?(owner.org_admin_list)
    end
  end
end
