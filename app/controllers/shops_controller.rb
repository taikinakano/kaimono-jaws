class ShopsController < ApplicationController

  def index
    @shops = Shop.page(params[:page]).reverse_order
  end

  def show
    @shop = Shop.find(params[:id])
    @shop_comment = ShopComment.new
  end

  def create
    @shop = Shop.new(shop_params)
    @shop.user_id = current_user.id
    if @shop.shop_name.match(/[一-龠々]/)
      @shop.conversion_shop_name = @shop.shop_name.to_kanhira.to_roman
    elsif @shop.shop_name.is_hira? || @shop.shop_name.is_kana?
      @shop.conversion_shop_name = @shop.shop_name.to_roman
    else
      @shop.conversion_shop_name = @shop.shop_name
    end
    if @shop.save
     redirect_to shop_path(@shop.id), notice: '店舗が登録されました。'
    else
      @user = User.find(current_user.id)
      @shops = @user.shops.page(params[:page]).reverse_order
      flash.now[:alert] = '店舗の登録に失敗しました'
      render "users/show"
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    if @shop.update(shop_params)
      redirect_to shop_path(@shop.id), notice: '店舗の更新に成功しました'
    else
      flash.now[:alert] = '店舗の更新に失敗しました'
      render "shops/edit"
    end
  end

  def destroy
    @shop = Shop.find(params[:id])
    if @shop.user_id = current_user.id
      @shop.destroy
      @user = User.find(current_user.id)
      redirect_to user_path(@user)
    end
  end

   def search
      selection = params[:keyword]
      @shops = Shop.sort(selection)
   end

  private
  def shop_params
    params.require(:shop).permit(:shop_name, :image, :address, :comment, :user_id)
  end
end
