class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :login
      t.string :password
      t.string :status

      t.timestamps null: false
    end
  end
end
