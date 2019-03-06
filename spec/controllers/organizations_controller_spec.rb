require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
	describe "GET new_import" do
    it "routes /organization/:id/import to organizations#new_import" do
      expect(get: "/organizations/1/import").to route_to(
        controller: "organizations",
        action: "new_import",
        id: "1"
      )
    end
  end

  describe "POST create_import" do
    context "with valid attributes" do
      it "routes /organization/:id/import to organizations#create_import" do
        expect(post: "/organizations/1/import").to route_to(
          controller: "organizations",
          action: "create_import",
          id: "1"
        )
      end
    end
  end
end
