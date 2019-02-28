class ParticipationPolicy < ApplicationPolicy
  def create?
    record.published? && !record.in?(user.completed_courses)
  end
end
