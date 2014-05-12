class ActivityLink < ActiveRecord::Base
  belongs_to :activity
  validates :activity_id, presence: true
  VALID_URL_REGEX = /.*\.com\z/i
  validates :url, presence: true, format: { with:VALID_URL_REGEX }
end
