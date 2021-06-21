# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email

  has_many :user_searches, dependent: :destroy
  has_many :searches, through: :user_searches

  has_many :books

  def encode_token
    JWT.encode({ user_id: id }, ENV['JWT_KEY'])
  end
end
