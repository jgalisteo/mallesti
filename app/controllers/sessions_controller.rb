class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  # POST /session
  def create
    user = User.find_for_database_authentication(email: params[:email])

    if user and user.valid_password?(params[:password])
      if user.confirmed?
        user.ensure_authentication_token!  # make sure the user has a token generate
        render json: user, status: :created
      else
        return unconfirmed
      end
    else
      return invalid_login_attempt
    end
  end

  private

  def invalid_login_attempt
    warden.custom_failure!
    render json: { errors: ['invalid'] }, status: :unauthorized
  end

  def unconfirmed
    warden.custom_failure!
    render json: { errors: ['unconfirmed'] }, status: :unauthorized
  end
end
