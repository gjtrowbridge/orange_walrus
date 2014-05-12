class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :activity_links
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :name, presence: true
end
