class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  require "date"   #Dateクラスを使えるよう
  require "time"   # Timeクラスを使えるよ
  include UsersHelper   #ヘルパーを読めるようにする
  
  def index
     @users = User.paginate(page: params[:page])
    
  end
  
  #-------------これより勤怠表示画面↓-------------------
  def show  #ログイン画面から　paramsのidを取得する
    @user = User.find(params[:id])
    #@attendance=Attendance.find_by({user_id: params[:id], today: Date.today})    #出社退社のボタンの表示用　ヘルパーに移動
    #@attendance=Attendance.find_by({user_id: params[:id]})                        #出社時間と退社時間表示用
    #debugger
    
    
    
    #@microposts = @user.microposts.paginate(page: params[:page])
    
    if params[:button_name] == nil
      @current_day = time_to_date_J                         #現在の日時を取得     #Date.todayをJSTにするためにTime.nowをつかう
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
        elsif params[:button_name] == "cancel"       #編集ページのキャンセルが押された時 
          first, last, current = date_henkan    #正規表現で　"2018/01/03"→"2017-09-03"にする
        
          @first_day = Date.strptime(first.gsub(/\//, '-'))
          @last_day = Date.strptime(last.gsub(/\//, '-'))
          @current_day = Date.strptime(current.gsub(/\//, '-'))
          
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
  
  def basic_info  #特定のユーザーの指定基本時間を表示する
    @user = User.find(params[:id])
    #@user = User.find_by(params[:id])
    @fixed_time = @user.fixed_work_time       #timeフィールドにから値を取得
    @basic_time = @user.basic_work_time       #timeフィールドにから値を取得
  end
  
  
  
  
  
  
#--------------これまで勤怠表示画面↑------------------------  
  
  
  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #@user.send_activation_email        #勤怠Bでは二段階認証不要のためコメントアウト
      #flash[:info] = "メールを確認してアカウントを有効にしてください。"      #勤怠Bでは二段階認証不要のためコメントアウト
      session[:received_form] = @user   #サインアップ成功した際の　ヘッダ表示　条件分岐用
      #current_user=@user                #勤怠Bでは二段階認証不要のためコメントアウト
      log_in(@user)                     #サインアップから入ってきたユーザー用に追加
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit
  end
   #-------------これより勤怠 基本情報画面↓-------------------
   def basic_info_edit
     @user = User.find(params[:id])
     #debugger
     if user_params[:fixed_work_time].blank? || user_params[:basic_work_time].blank?
      message="指定時間・基本時間の両方を入力してください。"
      flash[:warning] =message
      redirect_to basic_info_url(@user)   #基本情報に戻らせて再入力させる
     
     else @user.update_attributes(user_params)       #users/:id/basic.htmlから送信
      flash[:success] = "基本情報が更新されました。"
      redirect_to @user
     end
   end
   
   
   
   
   
   
   
   
   
  def update
    if @user.update_attributes(user_params)        #edit.htmlから送信
      flash[:success] = "プロフィールが更新されました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  #--------------これまで勤怠表示画面↑------------------------  
  
  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーが削除されました。"
    redirect_to users_url
  end
  
  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
   private
    #ストロングパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,
                                   :department,
                                   :fixed_work_time,
                                   :basic_work_time)
    end
  
  # beforeフィルター
  
  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
