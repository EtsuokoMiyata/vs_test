module AttendancesHelper
  
 
  
  
  
  def att_match_in_hour(date)    #カレンダーの日付とtodyカラムが一致 かつ　in_timeが存在したらを表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date})  #dateと比較したかったので、ヘルパーにもってきた
    if  @attendance.nil?
      
    elsif @attendance.in_time.present? && date == @attendance.in_time.to_date
      @attendance.in_time.hour
    else
    end
  end
  
  def att_match_in_min(date)    #カレンダーの日付とtodyカラムが一致 かつ　in_timeが存在したらを表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date})  #dateと比較したかったので、ヘルパーにもってきた
    if @attendance.nil?         #アカウントを登録しただけの場合
     
    elsif  date == @attendance.today && @attendance.in_time.present?
      @attendance.in_time.min
    else
    end
  end
  
  def att_match_out_hour(date)    #カレンダーの日付とtodyカラムが一致 かつ　out_timeが存在したらを表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date})  #dateと比較したかったので、ヘルパーにもってきた
    if  @attendance.nil? 
    elsif  date == @attendance.today && @attendance.out_time.present?
      @attendance.out_time.hour
    else
    end
  end
  
  def att_match_out_min(date)    #カレンダーの日付とtodyカラムが一致 かつ　out_timeが存在したらを表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date})  #dateと比較したかったので、ヘルパーにもってきた
    if  @attendance.nil?
      
    elsif  date == @attendance.today && @attendance.out_time.present?
      @attendance.out_time.min
    else
    end
  end
  
  
end
