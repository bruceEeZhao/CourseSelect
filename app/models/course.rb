class Course < ActiveRecord::Base
  searchkick language: "chinese"
 
  has_many :grades
  has_many :users, through: :grades

  belongs_to :teacher, class_name: "User"

  validates :course_code, :name, :course_type, :course_time,  :course_week,
            :class_room, :credit, :teaching_type, :exam_type, presence: true, length: {maximum: 50}


end
