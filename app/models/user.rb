class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :password, :password_confirmation, :remember_me, :email
  # attr_accessible :title, :body

  before_save :get_ldap_email

  def get_ldap_email
    self.email = "#{self.login}@saturized.com"
  end
end
