class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  require "date"   #Dateクラスを使えるよう
  require "time"   # Timeクラスを使えるよ
  
  def index
     @users = User.paginate(page: params[:page])
    
  end
  
  #-------------これより勤怠表示画面↓-------------------
  def show  #ログイン画面から　paramsのidを取得する
    #@user = User.find_by(params[:id])
    @user = User.find(params[:id])
    #@microposts = @user.microposts.paginate(page: params[:page])
    
    if params[:button_name] == nil
      @current_day = Date.today                         #現在の日時を取得
      @first_day = Date.today.beginning_of_month
      @last_day = Date.today.end_of_month
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
  
  def basic_info  #特定のユーザーの指定基本時間を表示する
    #@user = current_user
    #debugger
    
    
    @user = User.find(params[:id] = params[:format]) 
    #@user = User.find(params[:format])        #:formatを使うとうまくいく
    #@user = User.find_by(params[:id])
    @fixed_time = @user.fixed_work_time       #timeフィールドにから値を取得
    @basic_time = @user.basic_work_time       #timeフィールドにから値を取得
  end
  
  #def work_in_button(date)
       #@work_in_button = '<button type="button" class="btn btn-default">出社</button>'
  #end
  
  
  
  
#--------------これまで勤怠表示画面↑------------------------  
  
  
  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #@user.send_activation_email        #勤怠Bでは二段階認証不要のためコメントアウト
      #flash[:info] = "メールを確認してアカウントを有効にしてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
   #-------------これより勤怠 基本情報画面↓-------------------
   def basic_info_edit
     @user = User.find(params[:id])
     if @user.update_attributes(user_params)       #users/:id/basic.htmlから送信
      flash[:success] = "基本情報が更新されました。"
      redirect_to @user
     else
      #redirect_to "/users/:id/basic"    #基本情報に戻らせて再入力させる
      redirect_to "/basic_info"    #基本情報に戻らせて再入力させる
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
