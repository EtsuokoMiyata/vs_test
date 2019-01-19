module UsersHelper
   
  
  def time_to_date_J        #Date.todayの挙動がUTC時間のようなので、Time.now→Date関数に日本時間に変換 
    Date.parse((Time.now + 32400).to_s)
  end
  
  
  
    #これたぶんつかってない
    #def work_in_button(date)
      #if date == Date.today
       #@work_in_button = raw('<button type="button" class="btn btn-default">出社</button>')
      #else
      #end
    #end
    
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
    
   
  
  def work_days     #出勤日数をかぞえる  idかつ退社カラムがnilでないもの（1か月のレンジで）これだと、today：月初め～月末が一日ずれる可能性がある
    Attendance.where(user_id: params[:id]).where.not(out_time: nil).where(today: @arrey[0]..@arrey[-1]).count   #out_timeに9時間足したものの日付の部分だけ使いたい？
    #debugger
  end
   
   
   
   #在社時間の計算
  def hours_in_company(date)
    @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil?   #アカウントを登録しただけの場合
    
    elsif @attendance.out_time.present? && date == @attendance.today
      ((@attendance.out_time - @attendance.in_time) / 60 / 60).floor(2)      #秒単位から時間へ変換 切り捨て
     
    else
    end
  end
   
  #@total_hours_in_company = 0      #クラスインスタンス変数
  #在社時間の合計
  def total_hours_in_company(hours)
    hours
  end
    
  def edit_in_time(date)    #勤怠編集ページの出社時間の表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil? 
      
    elsif @attendance.in_time.present? && date == @attendance.today
      @attendance.in_time
    else
    end
  end  
   
  def edit_out_time(date)    #勤怠編集ページの退社時間の表示
    @attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    if @attendance.nil? 
      
    elsif @attendance.out_time.present? && date == @attendance.today
      @attendance.out_time
    else
    end
  end   
    
   #def edit_form_for(date)    #勤怠編集ページのform_forにわたす
    #@attendance=Attendance.find_by({user_id: params[:id], today: date}) 
    #@time.time      #@attendanceがnilの場合の初期値0設定
    #debugger
   #end    
    
    
    
    
    
    
  
   # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
