class AddNextPageReferenceToPages < ActiveRecord::Migration[5.2]
  def change
    add_reference :pages, :next_page, index: true
  end
end
