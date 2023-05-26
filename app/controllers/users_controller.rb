# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.gender = 0 if @user.gender.blank?
      if @user.save
        auto_login(@user)
        redirect_to events_path, success: 'ユーザー登録が完了しました'
      else
        flash.now[:danger] = 'ユーザー登録に失敗しました'
        render :new
      end
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :name, :gender, :password, :password_confirmation)
  end
end
