class Group < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_and_belongs_to_many :entities
  validates :name, presence: true
  has_one_attached :icon
  validates :icon, presence: true
end
