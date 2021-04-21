class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action  :verify_authenticity_token

  eval(IO.read('doc/api_doc/users/index.html'), binding)
  def index
    users = User.all
    return render json: {status: 200, all_users: {users: users}, message: "all users list"}
  end

  eval(IO.read('doc/api_doc/users/show.html'), binding)
  def show
    return render json: {status: 200, user_detail: {user: @user}, :message =>"User Details"}
  end

  eval(IO.read('doc/api_doc/users/create.html'), binding)
  def create
    user = User.new(user_params)
    if user.save!
      return render json: {status: 200, data: {user: user}, :message =>"user was successfully created"} 
    else
      return render json: {status: 401, data: {user: nil, errors: user.errors}} 
    end
  end

  eval(IO.read('doc/api_doc/users/update.html'), binding)
  def update
    if @user.update(user_params)
      render json: {status: 200, data: {user: @user}, message: "Successfully Updated"}
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  eval(IO.read('doc/api_doc/users/destroy.html'), binding)
  def destroy
    if @user.present?
      @user.delete
      render json: {status: 200, message: "Successfully Deleted"}
    else
      render json: { error: 'Could not be found for this id.' }
    end
  end

  eval(IO.read('doc/api_doc/users/search.html'), binding)
  def search
    users = [User.where(firstName: /#{params[:input]}/) + User.where(lastName: /#{params[:input]}/) + User.where(email: /#{params[:input]}/)].first.uniq
    return render json: {status: 200, all_users: {users: users}, message: "all search users"}
  end

  private

    def set_user
      @user = User.find_by(id: params[:id]) rescue nil
      if !@user.present?
        return render json: {status: 400, message: "User not found with this id"}
      end 
    end

    def user_params
      params.require(:user).permit(:firstName, :lastName, :email)
    end
end
