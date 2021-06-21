# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  def valid_params
    {
      username: 'my_username',
      password: 'password'
    }
  end

  describe 'POST /create' do
    context 'when creating a user' do
      it 'creates the user and supplies Authorization token' do
        post users_path, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['token']).to be_present
      end
    end
  end

  describe 'POST /grab_token' do
    let(:user) { FactoryBot.create(:user) }
    context 'when grabbing a user token' do
      it 'responds with token if username and password are correct' do
        post grab_token_users_path, params: { username: user.username, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['token']).to be_present
      end
      it 'responds with unauthorized if username and/or password are incorrect' do
        post grab_token_users_path, params: { username: user.username, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
