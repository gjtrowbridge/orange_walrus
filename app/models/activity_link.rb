class ActivityLink < ActiveRecord::Base
  belongs_to :activity
  validates :activity_id, presence: true
  validates :url, presence: true
end
