class UsersController < Devise::RegistrationsController
  respond_to :json

  # POST /resource
  def create
    # resource es un user
    build_resource(sign_up_params)

    resource_saved = resource.save # true si el usuario se crea y false si no
    yield resource if block_given?
    if resource_saved
      expire_data_after_sign_in!
      resource.ensure_authentication_token!

      # 201 y envío un json con el usuario
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      # 422 porque el usuario tiene errores
      respond_with resource
    end
  end
end
