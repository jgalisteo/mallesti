class UsersController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      expire_data_after_sign_in!
      resource.ensure_authentication_token!

      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end
end
