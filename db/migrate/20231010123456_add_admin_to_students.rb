class AddAdminToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :admin, :boolean, default: false
  end
end
