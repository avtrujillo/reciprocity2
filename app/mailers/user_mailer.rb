class UserMailer < ApplicationMailer
  default from: 'meddler@reciprocity.io'

  def match_email
    @user = params[:user]
    @user2 = params[:user2]
    @activity = params[:activity]

    mail(to: email_with_name, subject: 'You have a match on Reciprocity.io!')
  end

  def reset_password_email(user)
    @user = user
    base_url = ENV['ROOT_URL'] || ENV['DOMAIN']
    @url = "#{base_url}/password_resets/#{@user.reset_password_token}/edit"
    mail(to: email_with_name, subject: 'Reciprocity password reset')
  end

  private

  def email_with_name
    %("#{@user.name}" <#{@user.email}>)
  end
end
