class AttendancesController < ApplicationController
  #before_action :logged_in_user, only: [:create, :edit, :update]
  #before_action :correct_user,   only: [:create, :destroy, :edit, :update]
  #before_action :admin_user,   only: :destroy

  #出勤ボタンが押されたら　DBに登録する
  def create
    
    #user.attendances.create
    #in_office = Time.new
    
    ss = params[:user_id]
    #bb = params[:id]
    @attendance=Attendance.new({user_id: params[:id], in_time: Time.new})
    
    #@user = User.find_by(params[:id])
    #@user.attendances[:in_time] = in_office
    
    #@user = users(params[:user_id])   
    #@attendance = @user.attendances.build(user_id: params[:user_id])
    #@user = User.find_by(id: params[:user_id])
   
    #@attendance[:user_id]=params[:user_id]
    #@attendance[:in_time] = in_office
     #debugger
    
    if @attendance.save
      flash[:success] = "出勤が登録されました。"
      redirect_to '/basic_info'
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def edit
  end
  
  

  def destroy
    @micropost.destroy
    flash[:success] = "投稿が削除されました。"
    redirect_to request.referrer || root_url
  end

  private
    #ストロングンパラメータ
    def attendance_params
      params.require(:attendance).permit(:in_time, :out_time)
    end
    
    def correct_user
      @attendance = current_user.attendances.find_by(id: params[:id])
      redirect_to root_url if @attendance.nil?
    end
  
end
