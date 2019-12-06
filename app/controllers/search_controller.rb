class SearchController < ApplicationController
  def search
    if params[:term].nil?
      @courses = []
    else
      @courses = Course.search params[:term]
    end
  end
end