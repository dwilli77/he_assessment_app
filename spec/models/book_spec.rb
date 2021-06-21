# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'on creation' do
    it 'fills in google data for valid books' do
      book = FactoryBot.create(:book)
      expect(book.title).to be_present
    end
    it 'fails if my_rating is not within 1-10 range' do
      expect(FactoryBot.build(:book, my_rating: 12)).to_not be_valid
    end
    it 'fails if the google_id is not present' do
      book = FactoryBot.build(:book, google_id: nil)
      expect { book.save! }.to raise_error(ActiveRecord::RecordNotSaved)
    end
    it 'fails if the google_id doesnt return anything' do
      book = FactoryBot.build(:book, google_id: 'f3g3iba79g8yao978g')
      expect { book.save! }.to raise_error(ActiveRecord::RecordNotSaved)
    end
  end
end
