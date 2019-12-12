module CourseHelper

  def list
    #-------QiaoCode--------
    @courses = Course.where(:open=>true).paginate(page: params[:page], per_page: 4)
    @course = @courses-current_user.courses
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
  end

    def my_course_list
        course= current_user.courses
        get_course_table(course)
    end
    
    def week_data_to_num(week_data)
        param = {
            '周一' => 0,
            '周二' => 1,
            '周三' => 2,
            '周四' => 3,
            '周五' => 4,
            '周六' => 5,
            '周天' => 6,
        }
        param[week_data] + 1
    end

    def get_course_table(courses)
        course_time = Array.new(11) { Array.new(7, {'name' => '','credit'=>'', 'class_room'=>'','course_week'=>'','teacher_name'=>'','id' => ''}) }#new块，块会计算填充每个元素,二维数组，表示11节课，一周7天

        if courses
            courses.each do |cur|
                cur_time = String(cur.course_time)
                end_j = cur_time.index('(')#返回 cur_time中第一个等于 (的对象的 index
                j = week_data_to_num(cur_time[0...end_j])       #周几course_time: "周二(5-6)"
                t = cur_time[end_j + 1...cur_time.index(')')].split("-")#剔除-
                for i in (t[0].to_i..t[1].to_i).each
                    course_time[(i-1)*7/7][j-1] = {
                        'name' => cur.name,
                        'credit'=> cur.credit,
                        'class_room' =>cur.class_room,
                        'course_week'=>cur.course_week,
                        'teacher_name'=>cur.teacher.name,
                        'id' => cur.id
                    }
                end
            end
        end
        course_time
    end

  def is_over_number?(course)
    if course[:limit_num] == nil
      false
    elsif course[:student_num] >= course[:limit_num]
      true
    else
      false
    end
  end

  def is_exit_course?(id)
    if current_user.courses.find_by_id(id)
      true
    else
      false
    end
  end

  def is_time_conflict?(wanted_course)
    flag = false
    org_course_time = wanted_course.course_time
    org_course_week = wanted_course.course_week
    courses = current_user.courses
    day_week = org_course_time[0] + org_course_time[1]
    course_time = org_course_time.scan(/\d+/)
    course_week = org_course_week.scan(/\d+/)

    if !courses.where('course_time like :str', str: "%#{day_week}%")
      flag = false
    else
      courses.each do |course|
        temp_week = course.course_time[0] + course.course_time[1]
        if !interval_overlap(course_time, course.course_time.scan(/\d+/))
          flag = false
        elsif interval_overlap(course_week, course.course_week.scan(/\d+/)) and (temp_week == day_week)
          flag = true
          break
        else
          flag = false
        end
        temp_week = ""
      end
    end
    flag
  end

  def interval_overlap(interval1, interval2)
    if (interval1[0].to_i > interval2[1].to_i) or (interval2[0].to_i > interval1[1].to_i)
      false
    else
      true
    end
  end
end