class AddCourseTimeDayToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_time_day, :string
  end
end
