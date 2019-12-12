class SearchController < ApplicationController

  before_action :student_logged_in

  def search
    if params[:term].nil?
      @courses = []
    else
      #去除首尾空格
      term = params[:term].lstrip.rstrip
      term = string_process(term)
      
      @courses = []
      tmp = []
      #To only match the exact order, use:
      flag = false
      term.each do |s| 
        if ["and", "or"].include? s
          flag = true if s == "and"
          next
        else
          for res in Course.search s, highlight: true, match: :phrase
            if @courses.empty?
              @courses << res
            else
              tmp << res
            end
          end
        end

        unless tmp.empty?
          if flag
            @courses &= tmp
          else
            @courses |= tmp
          end
          flag = false
          tmp = []
        end
        
      end

      #只有开放的选课才能看到
      tmp = []
      @courses.each do |course|
        if course.open == true
          tmp << course
        end
      end
      @courses = tmp
    end
  end

  private

  def string_process(term)
    re = []
    flag = false
    tmp = ""
    term.each_char do |s|
      if s == "\"" 
        flag = !flag
        #进入新的 "" 区域，将之前的内容存入re
        if flag == true
            re << tmp unless tmp.empty?
            tmp = ""
        else
          re << tmp unless tmp.empty?
          tmp = ""
        end
        next
      end

      #不在引号之间的空格认为是分隔符
      if s == " " and flag==false
        re << tmp unless tmp.empty?
        tmp = ""
        next
      end        
      tmp += s 
    end
    re << tmp unless tmp.empty?
    re
  end

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

end