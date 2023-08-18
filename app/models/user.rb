class User < ActiveRecord::Base
  attr_accessor :password
  ROLES = %w[admin shop]

  validates :username, :presence => true, :uniqueness => true, :length => {:in => 3..20}
  validates :password, :confirmation => true
  validates_length_of :password, :in => 4..20, :on => :create

  before_save :encrypt_password
  after_save :clear_password

  def self.authenticate(username, password)
    user = User.where(username: username).last
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash= BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def clear_password
    self.password = nil
  end

end
