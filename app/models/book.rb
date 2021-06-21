# frozen_string_literal: true

class Book < ApplicationRecord
  validates_uniqueness_of :google_id, scope: :user_id
  validates_inclusion_of :my_rating, in: 1..10, message: 'Select rating between 1 and 10', allow_blank: true

  before_save :add_google_data

  belongs_to :user

  scope :date_ordered, -> { order(created_at: :desc) }
  scope :rating_ordered, -> { order(my_rating: :desc, created_at: :desc) }
  scope :rated, -> { where.not(my_rating: nil) }

  def add_google_data
    google_book = GoogleBooks.call(search_term: google_id)
    throw :abort unless google_book[:body]

    selected_book = google_book[:body].first
    self.title = selected_book[:title]
    self.author = selected_book[:author]
    self.description = selected_book[:description]
    self.image_links = selected_book[:image_links]
  end
end
