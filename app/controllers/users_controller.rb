class UsersController < ApplicationController
  def show
    # have to set items 
    # display list of tasks ...
    @user = User.find_by(user_params)
    @items = @user.items.sorted
    @item = Item.new
  end

  private
    def user_params
      params.require(:id)
      params.permit(:id)
    end
end
