# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'for duplicate searches' do
    it 'does not create a duplicate on Search table' do
      search = FactoryBot.create(:search, term: 'Pumpkin')
      search_2 = FactoryBot.build(:search, term: 'Pumpkin')
      expect { search_2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
