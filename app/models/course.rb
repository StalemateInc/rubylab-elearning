# frozen_string_literal: true

class Course < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

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

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name,         type: :text, analyzer: :english
      indexes :duration,     type: :integer
      indexes :difficulty,   type: :keyword
      indexes :description,  type: :text, analyzer: :english
      indexes :status,       type: :keyword
      indexes :created_at,   type: :date
      indexes :updated_at,   type: :date
      indexes :visibility,   type: :text, analyzer: :english
      indexes :owner_for_elastic, type: :text
      indexes :pages,        type: :object do 
        indexes :html,         type: :text
      end   
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      methods: :owner_for_elastic,
      only: [ :name, :duration, :difficulty, :description, :status, :visibility, 
        :status, :created_at, :updated_at],
      include: {
        pages: {
          only: [:html]
        }
      }
    )
  end

  def self.search_published(query)
    __elasticsearch__.search(
      { from: 0, size: 20,
        query: {
          bool: {
            must: [
              { match: { 'status': 'published' } },
              { match: { 'visibility': 'everyone' } },
              {
                multi_match: {
                query: query,
                fuzziness: 'auto'
                }
              }
            ]
          }
        }
      }
    )
  end

  def owner_for_elastic
    if owner.instance_of?(User)
      return "Owner nickname: #{owner.profile.nickname}, name: #{owner.profile.name}"
    elsif owner.instance_of?(Organization)
      return "Organization name: #{owner.name}, description: #{owner.description}"
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
