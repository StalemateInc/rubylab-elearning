class Course < ApplicationRecord
belongs_to :ownable, :polymorphic => true

end
