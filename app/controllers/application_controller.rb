class ApplicationController < ActionController::Base
  before_action :authenticate_user_from_token!, if: :json_request?
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  rescue_from Mongoid::Errors::DocumentNotFound, with: :render_404
  rescue_from ActionController::UnknownFormat, with: :render_406

  protected

  # Check if the incoming request is json
  def json_request?
    request.format.json?
  end

  def authenticate_user_from_token!
    user = User.find_by(email: user_email) if user_email

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating timing attacks
    if user and Devise.secure_compare(user.authentication_token, user_token)
      sign_in user, store: false
    end
  end

  def render_404(exception)
    render_exception :not_found
  end

  def render_406(exception)
    render_exception :not_acceptable
  end

  private

  def render_exception(status)
    respond_to do |format|
      format.all { render nothing: true, status: status }
    end
  end

  # Get the user email for authentication
  def user_email
    request.headers["HTTP_X_USER_EMAIL"] || params[:user_email]
  end

  # Get the user token for authentication
  def user_token
    request.headers["HTTP_X_USER_TOKEN"] || params[:user_token]
  end
end
