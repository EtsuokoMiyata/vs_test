module AttendancesHelper
  
 
  
  
  
  def match_hour(date)    #カレンダーの日付とtodyカラムが一致 かつ　in_timeが存在したらを表示
    if date == @attendance.today && @attendance.in_time.present?
      @attendance.in_time.hour
    else
    end
  end
  
  def match_min(date)    #カレンダーの日付とtodyカラムが一致 かつ　in_timeが存在したらを表示
    if date == @attendance.today && @attendance.in_time.present?
      @attendance.in_time.min
    else
    end
  end
  
  
  
  
end
