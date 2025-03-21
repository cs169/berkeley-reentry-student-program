class AddCanvasTokensToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :canvas_token, :string
    add_column :users, :canvas_refresh_token, :string
  end
end
