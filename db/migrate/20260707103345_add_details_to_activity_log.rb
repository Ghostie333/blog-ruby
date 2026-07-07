class AddDetailsToActivityLog < ActiveRecord::Migration[8.1]
  def change
    add_column :activity_logs, :details, :string
  end
end
