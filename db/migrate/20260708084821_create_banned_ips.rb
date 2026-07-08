class CreateBannedIps < ActiveRecord::Migration[8.1]
  def change
    create_table :banned_ips do |t|
      t.string :ip_address
      t.string :reason

      t.timestamps
    end
  end
end
