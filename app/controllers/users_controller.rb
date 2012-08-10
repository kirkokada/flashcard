class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]
  before_filter :created_user,   only: [:new, :create]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		redirect_back_or_to @user
  		flash[:success] = "Welcome to Flashcard"
  	else
  		render 'new'
  	end
  end

  def edit
    
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user 
      redirect_to @user
      flash[:success] = "Profile updated."
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page],
                           per_page: 30,
                           order: 'name ASC')
  end

  def destroy
    @user = User.find(params[:id])
    unless current_user?(@user)
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      flash.now[:error] = "Admin cannot self-delete."
      redirect_to users_path
    end
  end

  private

    def created_user
      redirect_to user_path(current_user) if signed_in?
    end


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
