class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :omniauthable and :rememberable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  #field :confirmation_token,   type: String
  #field :confirmed_at,         type: Time
  #field :confirmation_sent_at, type: Time
  #field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  ## Token authenticatable
  field :authentication_token, type: String

  # Relations
  has_many :customers

  # Generate an auth token
  def ensure_authentication_token!
    if self.authentication_token.blank?
      self.update_attribute(:authentication_token, generate_authentication_token)
    end
  end

  # Remove auth token
  def destroy_authentication_token!
    self.update_attribute(:authentication_token, nil)
  end

  private

  # Generate a valid and unused token
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).any?
    end
  end
end
