# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[update destroy]
  before_action :authenticate_token!

  def index
    @books = logged_in_user.books.date_ordered
    pagination_info = nil

    @books = @books.rating_ordered if params[:sort_by] == 'rating'
    @books = @books.rated if params[:filter] == 'rated'

    if params[:page].present?
      # defaults to 10 per page
      @books = @books.page(params[:page]).per(10)
      pagination_info = { total_pages: @books.total_pages }
    end

    render json: { books: @books, pagination_info: pagination_info }, status: :ok
  end

  def create
    @book = logged_in_user.books.build(book_params)
    if @book.save
      render json: { book: @book }, status: :created
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_update_params)
      render json: { book: @book }, status: :ok
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    head :no_content
  end

  private

  def set_book
    @book = Book.find(params[:id])
    unless @book.user_id == logged_in_user.id
      render json: { message: 'Not authorized to edit this book' }, status: :unauthorized
    end
  end

  def book_params
    params.permit(:google_id, :my_rating, :notes)
  end

  def book_update_params
    params.permit(:my_rating, :notes)
  end
end
