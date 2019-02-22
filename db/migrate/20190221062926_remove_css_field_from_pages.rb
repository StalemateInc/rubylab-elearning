class RemoveCssFieldFromPages < ActiveRecord::Migration[5.2]
  def change
    remove_column :pages, :css
  end
end
