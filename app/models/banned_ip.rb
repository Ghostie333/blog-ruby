class BannedIp < ApplicationRecord
  validates :ip_address, uniqueness: true, presence: true
end
