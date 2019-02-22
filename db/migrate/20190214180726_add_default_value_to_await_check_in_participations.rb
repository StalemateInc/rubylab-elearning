class AddDefaultValueToAwaitCheckInParticipations < ActiveRecord::Migration[5.2]
  def change
    change_column :participations, :await_check, :boolean, default: false
  end
end
