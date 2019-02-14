# describe SendInvintation do
#   subject(:context) do
#    SendInvintation.call(email: ["alfred@gmail.com casa@gmail.com", "arriva@mail.com, guru@mail.ru" "village@gmail.com", "garage@mail.org"],
#     file: ) }
#   end
#   describe ".call" do
#     context "when given valid credentials" do
#       let(:user) { double(:user, secret_token: "token") }

#       before do
#         allow(User).to receive(:authenticate).with("john@example.com", "secret").and_return(user)
#       end

#       it "succeeds" do
#         expect(context).to be_a_success
#       end

#       it "provides the user" do
#         expect(context.user).to eq(user)
#       end

#       it "provides the user's secret token" do
#         expect(context.token).to eq("token")
#       end
#     end

#     context "when given invalid credentials" do
#       before do
#         allow(User).to receive(:authenticate).with("john@example.com", "secret").and_return(nil)
#       end

#       it "fails" do
#         expect(context).to be_a_failure
#       end

#       it "provides a failure message" do
#         expect(context.message).to be_present
#       end
#     end
#   end
# end