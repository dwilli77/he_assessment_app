# frozen_string_literal: true

class Book < ApplicationRecord
  validates_uniqueness_of :google_id, scope: :user_id
  validates_inclusion_of :my_rating, in: 1..10, message: 'Select rating between 1 and 10', allow_blank: true

  before_save :add_google_data

  belongs_to :user

  scope :date_ordered, -> { order(created_at: :desc) }
  scope :rating_ordered, -> { order(my_rating: :desc, created_at: :desc) }
  scope :rated, -> { where.not(my_rating: nil) }
end
