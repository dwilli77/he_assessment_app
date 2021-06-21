# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'on creation' do
    it 'creates a token' do
      user = FactoryBot.create(:user)
      expect(user.encode_token).to eq(JWT.encode({ user_id: user.id }, ENV['JWT_KEY']))
    end
  end
end
