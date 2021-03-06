class UsersController < ApplicationController
  include UsersHelper
  before_action :require_session, except: %i[new create]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @invited_events = User.find(params[:id]).attended_event
    @upcoming_events = @invited_events.upcoming_events
    @past_events = @invited_events.past_events
    @created_events = User.find(params[:id]).events
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      start_session(@user)
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def signin
    @user = User.find_by_username(params[:username])
    if @user
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Signed in successfully!'
    else
      flash.now[:alert] = 'Username is invalid'
    end
  end

  def invitation
    @users = User.all
  end
end
