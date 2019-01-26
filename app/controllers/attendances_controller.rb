class AttendancesController < ApplicationController
  require 'byebug'
  #before_action :logged_in_user, only: [:create, :edit, :update]
  #before_action :correct_user,   only: [:create, :destroy, :edit, :update]
  #before_action :admin_user,   only: :destroy
  
  require "date"   #Dateクラスを使えるよう
  require "time"   # Timeクラスを使えるよ
  include UsersHelper   #ヘルパーを読めるようにする
  include AttendancesHelper   #ヘルパーを読めるようにする

  #出勤ボタンが押されたら　DBに登録する
  def create
    params[:id] = params[:format] #すでにURLに:idが含まれているので　:formatが使われてしまうのかも？
    #@user = User.find_by(id: params[:id])                                 #test
    #@attendance=Attendance.new(in_time: Time.new)                         #test user_idはいらなかった
    
    if params[:button_name] == "in_office"    #ボタンが出社の場合
      #mk_time(Time.new)     #秒以下を00で表示させる
      attendance=Attendance.new({user_id: params[:id], in_time: mk_time(Time.new), today: time_to_date_J}) #書き込みできた #Date.todayをJSTにするためにTime.nowをつかい　todyカラムはJSTとなる
      #attendance.in_time
      #debugger
    elsif params[:button_name] == "out_office"  #ボタンが退社の場合
      #attendance=Attendance.find_by({user_id: params[:id], today: Date.today})
      attendance=Attendance.find_by({user_id: params[:id], today: time_to_date_J})      #Date.todayをJSTにするためにTime.nowをつかい　todyカラムはJSTとなる
      attendance.update_attributes(out_time: mk_time(Time.new)) #退社時刻を登録
    else
    end
    
      
    
    
    
    if attendance.save
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
  
  
#--------------これまで勤怠表示画面↑------------------------  
  
  
  #勤怠編集ページの表示---------------------------------------
  def edit
    @user=User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    #debugger
     
   
    
    #first, last, current = date_henkan    #正規表現で　"2018/01/03"→"2017-09-03"にする
    first=params[:first_day]
    last=params[:last_day]
    @first_day = Date.strptime(first.gsub(/\//, '-'))
    @last_day = Date.strptime(last.gsub(/\//, '-'))
    #current_day = Date.strptime(current.gsub(/\//, '-'))
    
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
  
  
  attendances_params.each do |id,item|
    attendance = Attendance.find(id)
    
    attendance.update_attributes(item)
    #byebug
    
  end
  flash[:success] = '勤怠時間を更新しました'
  
   redirect_to @user
  
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
      params.require(:attendance).permit(:in_time, :out_time)
    end
    
    
    
    
    def attendances_params   #勤怠編集画面のfields_for用
      params.permit(attendances:[:id, :in_time, :out_time, :user_id])[:attendances]
    end
end