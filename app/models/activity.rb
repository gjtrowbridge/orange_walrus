class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :activity_links, :dependent => :destroy
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :name, presence: true
  accepts_nested_attributes_for :activity_links, :reject_if => proc { |attributes| attributes[:url].blank? }, :allow_destroy => true
end
