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

      it ''
    end
  end
end
#  new_import_organization GET    /organizations/:id/import(.:format)       organizations#new_import
# create_import_organization POST   /organizations/:id/import(.:format)     organizations#create_import
# get :show, {:id => subcategory.id.to_s, :params => {:sort => 'title'}}
# Should be

# get :show, :id => subcategory.id.to_s, :sort => 'title'
# Unless you mean to pass params[:params][:sort].

# Also

# helper.params[:sort].should_not be_nil
# Should be

# controller.params[:sort].should_not be_nil
# controller.params[:sort].should eql 'title'
# (If you mean to test a helper, you should write a helper spec.)
# describe "POST create" do
#   context "with valid attributes" do
#     it "creates a new contact" do
#       expect{
#         post :create, contact: Factory.attributes_for(:contact)
#       }.to change(Contact,:count).by(1)
#     end

#     it "redirects to the new contact" do
#       post :create, contact: Factory.attributes_for(:contact)
#       response.should redirect_to Contact.last
#     end
#   end

#   context "with invalid attributes" do
#     it "does not save the new contact" do
#       expect{
#         post :create, contact: Factory.attributes_for(:invalid_contact)
#       }.to_not change(Contact,:count)
#     end

#     it "re-renders the new method" do
#       post :create, contact: Factory.attributes_for(:invalid_contact)
#       response.should render_template :new
#     end
#   end 
# end