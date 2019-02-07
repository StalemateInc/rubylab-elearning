class ChangeParticipations < ActiveRecord::Migration[5.2]
  def change
  	add_column :participations, :await_check, :boolean
  	add_reference :participations, :page
  end
end
