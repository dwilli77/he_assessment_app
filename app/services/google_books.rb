# frozen_string_literal: true

class GoogleBooks
  attr_reader :search_term

  BASE_URL = 'https://www.googleapis.com/books/v1/volumes?q='

  def self.call(search_term:)
    new(search_term: search_term).call
  end

  def initialize(search_term:)
    @search_term = search_term || ''
  end

  def call
    resp = faraday.get(BASE_URL + search_term)
    {
      status: resp.status,
      body: parse_body(full_body: resp.body)
    }
  end

  private

  def parse_body(full_body:)
    return nil unless full_body && full_body['items']

    full_body['items'].map do |book|
      {
        id: book['id'],
        title: book['volumeInfo']['title'],
        author: book['volumeInfo']['authors'] ? book['volumeInfo']['authors'].join(' & ') : nil,
        description: book['volumeInfo']['description'],
        image_links: book['volumeInfo']['imageLinks']
      }
    end
  end

  def faraday
    @connection ||= Faraday.new do |f|
      f.response :json
    end
  end
end
