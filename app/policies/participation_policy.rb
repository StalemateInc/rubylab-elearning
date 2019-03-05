class ParticipationPolicy < ApplicationPolicy
  def create?
    record.published? && !record.in?(user.successfully_completed_courses)
  end
end
