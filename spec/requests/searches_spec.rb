# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Searches', type: :request do
  def valid_headers
    {
      'Authorization' => "Bearer #{user.encode_token}"
    }
  end

  describe 'GET /search' do
    let(:user) { FactoryBot.create(:user) }

    context 'when querying a multiple times' do
      it 'only creates one search on duplicate' do
        get query_path, headers: valid_headers, params: { search_term: 'Dune' }
        get query_path, headers: valid_headers, params: { search_term: 'Dune' }
        expect(Search.all.count).to be(1)
      end
      it 'creates multiple searches if no duplication' do
        get query_path, headers: valid_headers, params: { search_term: 'Dune' }
        get query_path, headers: valid_headers, params: { search_term: 'Children of Dune' }
        expect(Search.all.count).to be(2)
      end
      it "adds to user's search history whether it's a duplicate or not" do
        get query_path, headers: valid_headers, params: { search_term: 'Dune' }
        get query_path, headers: valid_headers, params: { search_term: 'Dune' }
        expect(user.searches.count).to be(2)
      end
    end

    context 'when the query is empty' do
      it 'creates an empty search' do
        get query_path, headers: valid_headers
        expect(Search.last.response_status).to be(400)
        expect(Search.last.response_body).to be_nil
      end
    end
  end
end
