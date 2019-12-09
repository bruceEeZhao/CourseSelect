class SearchController < ApplicationController

  before_action :student_logged_in

  def search
    if params[:term].nil?
      @courses = []
    else
      term = params[:term]
      #To only match the exact order, use:
      @courses = Course.search term, highlight: true, match: :phrase
    end
  end

  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end
end