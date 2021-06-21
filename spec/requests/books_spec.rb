# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books', type: :request do
  def valid_headers(user)
    {
      'Authorization' => "Bearer #{user.encode_token}"
    }
  end

  describe 'GET /index' do
    let(:user) { FactoryBot.create(:user) }
    context 'when the user is unauthenticated' do
      it "fails with an 'unauthorized' status" do
        get books_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is authenticated' do
      it 'succeeds' do
        get books_path, headers: valid_headers(user)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when a user has more than 10 books' do
      let(:user) { FactoryBot.create(:user, :with_books) }
      let(:user_2) { FactoryBot.create(:user, :with_books) }
      it 'paginates when pagination param is passed' do
        get books_path, headers: valid_headers(user), params: { page: 1 }
        expect(JSON.parse(response.body)['books'].length).to be(10)
      end
      it 'does not paginate if pagination param is missing' do
        get books_path, headers: valid_headers(user_2)
        expect(JSON.parse(response.body)['books'].length).to be(15)
      end
    end

    context 'when a user has unrated books' do
      let(:book_1) { FactoryBot.create(:book, user: user, my_rating: nil) }
      it 'returns an empty array when rated filter is applied' do
        user.books << book_1
        get books_path, headers: valid_headers(user), params: { filter: 'rated' }
        expect(JSON.parse(response.body)['books'].length).to be(0)
      end
      it 'return the unrated book when rated filter is missing' do
        user.books << book_1
        get books_path, headers: valid_headers(user)
        expect(JSON.parse(response.body)['books'].length).to be(1)
      end
    end

    context 'when a user tries to edit another users books' do
      let(:user_2) { FactoryBot.create(:user) }
      let(:book) { FactoryBot.create(:book) }
      it 'responds with unauthorized' do
        user.books << book
        put book_path(book), headers: valid_headers(user_2), params: { my_rating: 9 }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when a user deletes a book' do
      let(:user_2) { FactoryBot.create(:user, :with_books) }
      it 'removes that book from their list' do
        expect do
          delete book_path(user_2.books.last), headers: valid_headers(user_2)
        end.to change(user_2.books, :count).from(15).to(14)
      end
    end
  end
end
