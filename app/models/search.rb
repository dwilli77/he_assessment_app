# frozen_string_literal: true

class Search < ApplicationRecord
  has_many :user_searches, dependent: :destroy
  has_many :users, through: :user_searches

  validates_uniqueness_of :term
end
