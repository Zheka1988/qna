class AddAutorToComment < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :author, foreign_key: { to_table: :users }
  end
end
