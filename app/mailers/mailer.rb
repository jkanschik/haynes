class Mailer < ActionMailer::Base
  default from: "mail@haynes-catalog.net",
          recipients: [ "jens_kanschik@freenet.de", "Peter Wuttke <wuttke.essen@gmx.de>" ]
  
  def comment_added(addition)
    @subject = "Comment added to #{addition.work.title} by user #{addition.user.logname}"
    @body["addition"] = addition
    @sent_on = Time.now
    @headers = {}
  end
  
  def user_registered(user)
    @subject = "New user #{user.logname} registered"
    @user = user
    @sent_on = Time.now
    @headers = {}
  end

end