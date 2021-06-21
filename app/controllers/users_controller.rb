# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = @user.encode_token
      render json: { user: @user, token: token }, status: :created
    else
      render json: { error: 'Unable to create user' }, status: :unprocessable_entity
    end
  end

  def grab_token
    @user = User.find_by(email: user_params[:email])
    if @user.present? && @user.authenticate(user_params[:password])
      token = encode_token(user_id: @user.id)
      render json: { token: token }
    else
      render json: { error: 'Incorrect username and/or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :name, :password)
  end
end
