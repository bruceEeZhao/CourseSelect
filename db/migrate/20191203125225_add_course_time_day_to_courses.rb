class AddCourseTimeDayToCourses < ActiveRecord::Migration
  def change
    #第几节  例如 (1-2)节
    add_column :courses, :course_time_day, :string
  end
end
