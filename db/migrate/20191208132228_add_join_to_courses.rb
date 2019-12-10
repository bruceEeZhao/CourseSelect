class AddJoinToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :join, :boolean
  end
end
