class ImpersonationHistory < ApplicationRecord
  belongs_to :impersonator, class_name: 'User'
  belongs_to :target_user, class_name: 'User'
end
