class CustomersController < ApplicationController
  load_and_authorize_resource only: [:show, :update, :destroy]
  before_action :determine_scope, only: [:index]
  before_action :paginate, only: [:index]

  respond_to :json

  def show
    respond_with @customer
  end

  def index
    @customers = @scope
    respond_with @customers, meta: {
      currentPage: @scope.current_page,
      totalPages: @scope.total_pages,
      nextPage: @scope.next_page,
      prevPage: @scope.prev_page
    }
  end

  def create
    @customer = current_user.customers.create(customer_params)
    respond_with @customer
  end

  def update
    @customer.update_attributes(customer_params)
    respond_with @customer
  end

  def destroy
    @customer.destroy
    respond_with @customer
  end

  private

  def determine_scope
    @scope = current_user.customers
  end

  def paginate
    @scope = @scope.page(params[:page]).per(params[:per])
  end

  def customer_params
    params.require(:customer).permit(
      :name, :address, :town, :city, :country, :zip_code, :phone, :cif, :email
    )
  end
end
