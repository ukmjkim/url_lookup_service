class ChangeTableNameOfUrl < ActiveRecord::Migration[5.1]
  def change
    rename_table :urls, :urlinfos
  end
end
