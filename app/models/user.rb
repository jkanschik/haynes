require 'digest/sha1'

class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :orig_password

  attr_accessible :name, :logname, :mail, :orig_password, :orig_password_confirmation, :role

  validates_length_of       :orig_password, :minimum => 4, :message => "The password must have at least 4 characters."
  validates_confirmation_of :orig_password, :message => "Please confirm the password."
  validates_length_of       :logname,       :minimum => 4, :message => "Your login name must have at least 4 characters."
  validates_presence_of     :name,          :message => "Please enter your real name."
  validates_uniqueness_of   :logname,       :message => "The login name is already in use, please choose a different one."
  validates_format_of       :mail,          :with => /^([a-zA-Z0-9_'+*$%\^&!\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9:]{2,4})+$/,
                                            :message => "Please enter a valid email adress.",
                                            :if => Proc.new { |user| !user.mail.nil? && user.mail != ''}

  before_save :encrypt_password

  def self.authenticate(log, password)
    user = find_by_deprecated_password(log, password)
    user ||= find(:first, :conditions => ["logname = ? and password = ?", log, encrypt(password)])
    user
  end

  def self.find_by_deprecated_password(log, password)
    find(:first, :conditions => ["logname = ? and password = OLD_PASSWORD(?)", log, password])
  rescue ActiveRecord::StatementInvalid
    nil # OLD_PASSWORD is a mysql specific function, for sqlite3 or other dbs, this exception is raised
  end

  def self.encrypt(password)
    Digest::SHA1.hexdigest(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = User.encrypt("#{name}--#{remember_token_expires_at}")
    save!(validate: false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save!(validate: false)
  end

  protected
    # before filter 
    def encrypt_password
      return if orig_password.blank?
      self.password = self.class.encrypt(orig_password)
    end

end
