require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  set_content_type 'application/json'

  options = [:show, :index, :create, :update, :destroy]
  json_attributes = FactoryGirl.attributes_for(:customer).keys

  before :all do
    @user = FactoryGirl.create(:user)

    # Para todos los tests
    @model = Customer

    # Para el test de show
    @resource = FactoryGirl.create(:customer, user: @user)

    # Para el test de index
    @list_options = {user: @user}
    @first_page_resources = @user.customers

    # Para el test de create y destroy
    @parameters = FactoryGirl.attributes_for(:customer, user_id: @user.id.to_s)

    # Para el test de update
    @update_params = FactoryGirl.attributes_for(:customer_update)
  end

  before do
    sign_in @user
  end

  it_behaves_like "a REST controller", options, json_attributes
end
