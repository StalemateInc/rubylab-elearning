# frozen_string_literal: true

class HomeController < ApplicationController

  # GET /
  def index
    @most_popular_courses = Course.joins('LEFT JOIN completion_records ON completion_records.course_id = courses.id')
                                .select('courses.*, COUNT(completion_records.id) as completed_count')
                                .group('courses.id')
                                .order('completed_count DESC')
                                .limit(4)
    @organizations = Organization.limit(10)

    # not yet implemented
    # @top_rated_courses = Course.order('rating DESC').limit(20)
  end

end
