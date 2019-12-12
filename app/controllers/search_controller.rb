class SearchController < ApplicationController
  include SearchHelper
  before_action :student_logged_in

end