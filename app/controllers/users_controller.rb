class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    
    @books = @user.books
    # 投稿数
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    
    
    @book = Book.new
    
    #ユーザー情報を取得
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu| #チャットルームの特定
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomid = cu.room_id
          end
        end
      end
      unless @isRoom #チャットルームの新規作成
          @room = Room.new
          @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end
  
  def search
    user_books = User.find(params[:user_id]).books #user_idで取得したユーザの本の一覧を取得
    created_time = params[:created_at] #created_atをcreated_timeに代入
    if created_time == "" 
      @search_book = "日付が選択されていません" #値が
    else
      @search_book = user_books.where(created_at: created_time.to_date.all_day).count 
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
