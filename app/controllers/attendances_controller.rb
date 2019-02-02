class AttendancesController < ApplicationController
  #require 'byebug'
  #before_action :logged_in_user, only: [:create, :edit, :update]
  #before_action :correct_user,   only: [:create, :destroy, :edit, :update]
  #before_action :admin_user,   only: :destroy
  
  require "date"   #Dateクラスを使えるよう
  require "time"   # Timeクラスを使えるよ
  include UsersHelper   #ヘルパーを読めるようにする
  include AttendancesHelper   #ヘルパーを読めるようにする

  #出勤ボタンが押されたら　DBに登録する
  def create
    #★しらべたらparams[:id]とparams[:format]の値が同じだった
    #★params[:id] = params[:format] #すでにURLに:idが含まれているので　:formatが使われてしまうのかも？
    
    if params[:button_name] == "in_office"    #ボタンが出社の場合
    
      #mk_time(Time.new)     #秒以下を00で表示させる
      # attendanceがnilの場合newで　他はfind_by
      if params[:attendance].nil?
        attendance=Attendance.new({user_id: params[:id], in_time: mk_time(Time.new), today: time_to_date_J}) #書き込みできた #Date.todayをJSTにするためにTime.nowをつかい　todyカラムはJSTとなる
      else
        attendance=Attendance.find_by({user_id: params[:id], today: time_to_date_J})
        attendance.update_attributes(in_time: mk_time(Time.new)) #出社時刻を登録
      end
      #debugger
    elsif params[:button_name] == "out_office"  #ボタンが退社の場合
      #attendance=Attendance.find_by({user_id: params[:id], today: Date.today})
      attendance=Attendance.find_by({user_id: params[:id], today: time_to_date_J})      #Date.todayをJSTにするためにTime.nowをつかい　todyカラムはJSTとなる
      attendance.update_attributes(out_time: mk_time(Time.new)) #退社時刻を登録
    else
    end
    
      
    
    
    
    if attendance.save
      #debugger
      flash[:success] = "登録されました。"
      #@attendance.in_time      #test 値は入っているが、redirect_toで渡せない
      #debugger
      #redirect_to controller: 'users', action: 'show', params.permit({id: :id, in: @attendance.in_time}).to_h    #test
      #redirect_to controller: 'users', action: 'show', id: params[:id]   #コントローラ　users アクションshow
      redirect_to controller: 'attendances', action: 'show', id: params[:id]   #コントローラ　attendances アクションshow
      
      
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  
  #-------------これより勤怠表示画面↓-------------------
  def show  #ログイン画面から　paramsのidを取得する
    @user = User.find(params[:id])
    #@attendance_button=Attendance.find_by({user_id: params[:id], today: Date.today})    #出社退社のボタンの表示用
    #@attendance=Attendance.find_by({user_id: params[:id]})                        #出社時間と退社時間表示用
    
   
    @at = @user.attendances.find_by(user_id: params[:id], today: Date.today)  #test
    #@microposts = @user.microposts.paginate(page: params[:page])
    
    if params[:button_name] == nil
      @current_day = time_to_date_J             #現在の日時を取得
      @first_day = time_to_date_J.beginning_of_month
      @last_day = time_to_date_J.end_of_month
      calendar #1か月分のカレンダー
    else
      
       if params[:button_name] == "last_month"          #前月矢印が押された時
          
          first, last, current = date_henkan    #正規表現で　"2018/01/03"→"2017-09-03"にする
          
          @first_day = Date.strptime(first.gsub(/\//, '-')).prev_month.beginning_of_month
          @last_day = Date.strptime(last.gsub(/\//, '-')).prev_month.end_of_month
          @current_day = Date.strptime(current.gsub(/\//, '-')).prev_month
    
          calendar #1か月分のカレンダー
          
        elsif params[:button_name] == "next_month"       #次月矢印が押された時 
          first, last, current = date_henkan    #正規表現で　"2018/01/03"→"2017-09-03"にする
        
          @first_day = Date.strptime(first.gsub(/\//, '-')).next_month.beginning_of_month
          @last_day = Date.strptime(last.gsub(/\//, '-')).next_month.end_of_month
          @current_day = Date.strptime(current.gsub(/\//, '-')).next_month
          
          calendar #1か月分のカレンダー
        else
       end
    end
  end
  
  def date_henkan    #正規表現で　"2018/01/03"→"2017-09-03"にする
    first = params[:first_day]       #初日
    first = first.gsub(/\//, '-')   
    
    last = params[:last_day]          #締日
    last = last.gsub(/\//, '-')       
          
    current = params[:current_day]    #当月   
    current = current.gsub(/\//, '-')           
  
    return first, last, current
  end
  
  
  
  
  def calendar #1か月分のカレンダー
    @arrey=Array.new
    
    (@first_day..@last_day).each do |date|
    @arrey.push(date)
    end
  end
  
  

  
  
  #勤怠編集ページの表示---------------------------------------
  def edit
    @user=User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    #debugger
     
   
    
    #first, last, current = date_henkan    #正規表現で　"2018/01/03"→"2017-09-03"にする
    first=params[:first_day]
    last=params[:last_day]
    current=params[:current_day]
    #debugger
    @first_day = Date.strptime(first.gsub(/\//, '-'))
    @last_day = Date.strptime(last.gsub(/\//, '-'))
    @current_day = Date.strptime(current.gsub(/\//, '-'))
    
    #@attendances=Array.new
    #@attendances=Attendance.where({user_id: params[:id], today: @first_day...@last_day}) #1か月間の出勤データを配列にする
    #カレンダーの日付が配列になかったら、today:に カレンダー日付を入れる
   
   
   
   
   
    (@first_day..@last_day).each do |date|  #出退勤データのない日を登録する
    attendance=Attendance.find_by({user_id: params[:id], today: date}) #find_byは一件のみ表示なのでバグがわかりずらい
      #if !Attendance.where({user_id: params[:id], today: date}).any?     #モデルが存在するかどうか？
      
      if attendance.nil?
      
          attendance=Attendance.new(user_id: @user.id, today: date)
          
          attendance.save
      else
        
      end      #if文締め

      #1か月間の出勤データを配列にする
      
      #debugger
      end  #each文締め
      @attendances=Attendance.where({user_id: params[:id], today: @first_day..@last_day}).order(today: :asc)
  #debugger
  end
 
    
    
    
    
  
  def update
  end
  
 #勤怠更新アクション---------------------------------------------------- 
  def attendance_update_all   #とりあえず、更新できるかどうか？？
  @user = User.find_by(id: params[:user_id]) #ユーザー情報を取得
  error_count = 0
  message=""
  
    first=params[:first_day]
    last=params[:last_day]
    current=params[:current_day]
    #@current_day=time_to_date_J 
    
    #debugger
    @first_day = Date.strptime(first.gsub(/\//, '-')) #正規表現で　"2018/01/03"→"2017-09-03"にする
    @last_day = Date.strptime(last.gsub(/\//, '-'))
    @current_day = Date.strptime(current.gsub(/\//, '-'))
    #debugger
    
    
    attendances_params.each do |id, item|  #paramsを使って、エラーチェックをする
      # =>attendance = Attendance.find(id)
      #debugger
      if item["in_time"].present? && item["out_time"].blank?  #出退勤2つのデータが存在するか？
      
        message="出勤・退勤の両方を入力してください。"
        error_count +=1
      elsif item["in_time"].blank? && item["out_time"].present?  #出退勤2つのデータが存在するか？
        message="出勤・退勤の両方を入力してください。"
        error_count +=1  
        
        
      #elsif (item["in_time"].present? || item["out_time"].present?) && attendance.today > time_to_date_J && !current_user.admin             #一般ユーザーは明日以降の編集は不可
      #debugger  #attendance.todayの値がおかしい　連続してエラーでたら？？
       # message = '明日以降の編集はできません。'
        #error_count +=1
        
      elsif item[:in_time].to_s > item[:out_time].to_s  
      #出勤より退勤が早くないか？ 
        message = '出勤時間より退勤時間が早いデータは更新できません。'
        error_count +=1
      end  #if文の締め  
    end #each文の締め
  
  
  if error_count > 0
    
    flash[:warning] =message
    redirect_to edit_attendance_url(@user, first_day: @first_day, last_day: @last_day,current_day: @current_day, button_name: 'cancel')
    #debugger
    
  else
    attendances_params.each do |id,item|
      attendance = Attendance.find(id)
      attendance.update_attributes(item)
    end  #each文締め
    flash[:success] = '勤怠時間を更新しました'
    redirect_to @user
  end    #if文締め
  
   
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  def destroy
    @micropost.destroy
    flash[:success] = "投稿が削除されました。"
    redirect_to request.referrer || root_url
  end

  private
    #ストロングンパラメータ
    def correct_user
      @attendance = current_user.attendances.find_by(id: params[:id])
      redirect_to root_url if @attendance.nil?
    end
    
    
    def attendance_params   #出社・退社の時のsave時用
      params.require(:attendance).permit(:in_time, :out_time, :remarks)
    end
    
    
    
    
    def attendances_params   #勤怠編集画面のfields_for用
      params.permit(attendances:[:id, :in_time, :out_time, :user_id, :remarks])[:attendances]
    end
end