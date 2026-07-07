class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: true, foreign_key: true
      t.string :action
      t.string :ip_address

      t.timestamps
    end
  end
end
