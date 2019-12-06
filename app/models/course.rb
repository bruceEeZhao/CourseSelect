require 'elasticsearch/model'

class Course < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
 
  index_name    "courses"
  document_type "post"


  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['name', 'course_week']
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            name: {},
            course_week: {}
          }
        }
      }
    )
  end
  


  has_many :grades
  has_many :users, through: :grades

  belongs_to :teacher, class_name: "User"

  validates :name, :course_type, :course_time, :course_time_day, :course_code,:course_week,
            :class_room, :credit, :teaching_type, :exam_type, presence: true, length: {maximum: 50}


end
