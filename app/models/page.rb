class Page < ApplicationRecord
  has_many :questions, dependent: :destroy
  belongs_to :course
  belongs_to :previous_page, class_name: 'Page', optional: true
  belongs_to :next_page, class_name: 'Page', optional: true
  before_save :set_pages
  before_destroy :remove_pages

  class << self
    def starting_for(course)
      find_by(course: course, previous_page: nil)
    end

    def all_for(course)
      start_page = starting_for(course)
      start_page.blank? ? [] : start_page.full_sequence
    end
  end

  def before?(target, sequence)
    !sequence.index(target).nil?
  end

  def full_sequence
    [self].concat(Page.find_by_sql(recursive_tree_children_sql))
  end

  def all_questions_answered_by?(user)
    questions.eager_load(:user_answers).where('user_answers.user_id = ?', user.id).count == questions.size
  end

  private

  def set_pages
    page_prev = previous_page
    page_next = next_page

    transaction do
      page_prev.update(next_page: self) if page_prev && page_prev.next_page != self
      page_next.update(previous_page: self) if page_next && page_next.previous_page != self
    end
  end

  def remove_pages
    page_prev = previous_page
    page_next = next_page

    transaction do
      page_prev.update(next_page: page_next) if page_prev
      page_next.update(previous_page: page_prev) if page_next
    end
  end

  def recursive_tree_children_sql
    columns = self.class.column_names
    columns_joined = columns.join(',')
    sql =
    "
      WITH RECURSIVE page_tree (#{columns_joined}, level)
      AS (
        SELECT
          #{columns_joined}, 0
        FROM pages
        WHERE id=#{id}

        UNION ALL
        SELECT
          #{columns.map { |col| 'pag.' + col }.join(',') },
          pt.level + 1
        FROM pages pag, page_tree pt
        WHERE pag.previous_page_id = pt.id
      )
      SELECT * FROM page_tree
      WHERE level > 0
      ORDER BY level, next_page_id;
    "
    sql.chomp
  end

end