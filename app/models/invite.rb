class Invite < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  def organization_name
    Organization.find(organization_id).name
  end
end
