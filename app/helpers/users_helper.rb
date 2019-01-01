module UsersHelper
    def work_in_button(date)
      if date == Date.today
       @work_in_button = raw('<button type="button" class="btn btn-default">出社</button>')
      else
      end
    end
    
    # 以下　user/showから　呼び出される
    def match_in_hour(date)    #カレンダーの日付とtodyカラムが一致 かつ　in_timeが存在したらを表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date})  #dateと比較したかったので、ヘルパーにもってきた
      if @attendance.nil?   #アカウントを登録しただけの場合
        
      elsif @attendance.in_time.present? && date == @attendance.today
         @attendance.in_time.hour
      else
      end
    end
  
  def match_in_min(date)    #カレンダーの日付とtodyカラムが一致 かつ　in_timeが存在したらを表示
  @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil?
      
    elsif @attendance.in_time.present? && date == @attendance.today
      @attendance.in_time.min
    else
    end
  end
  
  def match_out_hour(date)    #カレンダーの日付とtodyカラムが一致 かつ　out_timeが存在したらを表示
  @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil?   #アカウントを登録しただけの場合
      
    elsif @attendance.out_time.present? && date == @attendance.today
      #debugger
      @attendance.out_time.hour
    else
    end
  end
  
  def match_out_min(date)    #カレンダーの日付とtodyカラムが一致 かつ　out_timeが存在したらを表示
  @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil?   #アカウントを登録しただけの場合
      
    elsif @attendance.out_time.present? && date == @attendance.today
      @attendance.out_time.min
    else
    end
  end
    
   
   
  def work_days     #出勤日数をかぞえる  idかつ退社カラムがnilでないもの（1か月のレンジで）
    Attendance.where(user_id: params[:id]).where.not(out_time: nil).where(today: @arrey[0]..@arrey[-1]).count
    #debugger
  end
   
   
  def hours_in_company(date)
    @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil?   #アカウントを登録しただけの場合
    
    elsif @attendance.out_time.present? && date == @attendance.today
      ((@attendance.out_time - @attendance.in_time) / 60 / 60).floor(2)      #秒単位から時間へ変換 切り捨て
      
    else
    end
  end
   
    
    
    
    
    
    
  
   # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
