# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_user_registration!, only: :show
  before_action :require_user_logged_in!, only: %i[edit update]

  # render current user profile
  def show
    @score = UserScoreboard.new(@current_user).score
    @pull_requests =  UserScoreboard.new(@current_user).pull_requests
  end

  # action to save registration
  def update
    if @current_user.update_registration_validations(params_for_registration)
      redirect_to session[:destination] || '/'
    else
      set_user_emails
      render 'users/edit'
    end
  end

  # action to render register form
  def edit
    @emails = UserEmailService.new(@current_user).emails
  end

  private

  def params_for_registration
    params.require(:user).permit(:email, :terms_acceptance, :marketing_emails)
  end
end
