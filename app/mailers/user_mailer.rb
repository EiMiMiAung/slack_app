class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.invite_members.subject
  #
  def invite_members(user, space_name)
    @m_user=user
    @workspace_name = space_name
    mail to:user.email, subject: "slackapp invitation"
  end
end
