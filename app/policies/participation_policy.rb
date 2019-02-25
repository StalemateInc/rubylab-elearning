class ParticipationPolicy < ApplicationPolicy
  def create?
    record.published?
  end
end
