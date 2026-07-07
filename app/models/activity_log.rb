class ActivityLog < ApplicationRecord
  belongs_to :user, optional: true
  validates :action, presence: true

  serialize :details, coder: JSON
end
