class Person < ApplicationRecord
  self.table_name = 'people'
  has_one :detail, dependent: :destroy
  accepts_nested_attributes_for :detail

  validates :name, presence: true
end
