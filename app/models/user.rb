class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable
  
  #->Prelang (user_login:devise/username_login_support)
  has_many :addresses, autosave: true
  has_many :sales, autosave: true
  accepts_nested_attributes_for :sales
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

  
  attr_accessor :stripe_token
  attr_accessor :login


  def expire
    UserMailer.expire_email(self).deliver
    destroy
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
    else
      where(conditions).first
    end
  end
  
  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end


  devise authentication_keys: [:login]


end
