class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|


      t.string :course_name
      t.string :user_name
      t.string :weekday
      t.string :course_section

      t.timestamps null: false
    end
  end
end
