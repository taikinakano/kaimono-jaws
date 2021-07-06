class UsersController < ApplicationController


  def show
    @shop = Shop.new
    @user = User.find(params[:id])
    @shops = @user.shops.page(params[:page]).reverse_order
    @currentUserEntry = Entry.where(user_id: current_user.id)#メッセージ機能の記述
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
    end
    if @isRoom
    else
      @room = Room.new
      @entry = Entry.new
    end
    end
  end

  def create
  end

  def index
    @users = User.page(params[:page]).reverse_order
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def destroy
    @shop = Shop.find(params[:id])
    @shop.destroy
    redirect_to user_path
  end

  def withdrow_confirm
    @user = User.find(params[:id])
  end

  def withdrow
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end

end
