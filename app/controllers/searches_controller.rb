# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :authenticate_token!

  def search
    @search = Search.find_or_create_by(term: params[:search_term]) do |search|
      resp = GoogleBooks.call(search_term: params[:search_term])
      search.response_status = resp[:status]
      search.response_body = resp[:body]
    end

    logged_in_user.searches << @search # add to the user's search history even if it's a duplicate

    render json: @search
  end
end
