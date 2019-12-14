class CoursesController < ApplicationController
  include CourseHelper
  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attribute(:open, true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attribute(:open, false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------

  #添加已选课程功能的
  def join
    @course = Course.find_by_id(params[:id])

    if is_over_number?(@course)
      flash = {:warning => "选课失败!课程: #{@course.name} 人数已满!"}
    elsif is_exit_course?(params[:id])
      flash = {:warning => "您的课表中已存在:#{@course.name}，请选择其他课程！"}
    else
      @course.update_attribute(:join, true)
      current_user.courses<< @course
      @course.update_attribute(:student_num, @course.student_num + 1)
      flash = {:info => "成功选择课程: #{@course.name}"}
    end
    redirect_to :back, flash: flash
  end

  def replace
    @course = Course.find_by_id(params[:id])
    if is_over_number?(@course)
      flash = {:warning => "选课失败!课程: #{@course.name} 人数已满!"}
    elsif is_exit_course?(params[:id])
      flash = {:warning => "您的课表中已存在:#{@course.name}，请选择其他课程！"}
    else
      flag,re_course = is_time_conflict?(@course)
      if re_course != nil
        @course.update_attribute(:join, true)
        re_course.update_attribute(:join, false)
        
        current_user.courses.delete(re_course)
        current_user.courses<< @course
        @course.update_attribute(:student_num, @course.student_num + 1)
        flash = {:info => "成功将课程:#{re_course.name} 替换为 #{@course.name}"}
      end
    end
    redirect_to :back, flash: flash
  end

  
  #退选功能
  def no_join
    @course=Course.find_by_id(params[:id])
    @course.update_attribute(:join, false)
    @course.update_attribute(:student_num, @course.student_num - 1)
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to :back, flash: flash
  end

  # def list
  #   #-------QiaoCode--------
  #   @courses = Course.where(:open=>true).paginate(page: params[:page])
  #   @course = @courses-current_user.courses
  #   tmp=[]
  #   @course.each do |course|
  #     if course.open==true
  #       tmp<<course
  #     end
  #   end
  #   @course=tmp
  # end

  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses.paginate(page: params[:page]) if teacher_logged_in?
    @course=current_user.courses.paginate(page: params[:page]) if student_logged_in?
  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_time_day, :course_week)
  end


end
