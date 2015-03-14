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

  context "special feature" do
    context "GET #index" do
      context "pagination" do
        before :all do
          FactoryGirl.create_list(:customer, 50, user: @user)
        end

        context "default" do
          before do
            get :index
          end

          it "returns 10 per page" do
            expect(response_body_json['customers'].size).to eql 10
          end

          it "returns the current page" do
            expect(response_body_json['meta']['currentPage']).to eql 1
          end

          it "returns the next page" do
            expect(response_body_json['meta']['nextPage']).to eql 2
          end

          it "returns the previous page" do
            expect(response_body_json['meta']['prevPage']).to be_nil
          end

          it "returns the number of pages" do
            expect(response_body_json['meta']['totalPages']).to eql @user.customers.page.total_pages
          end
        end

        context "with parameters" do
          before do
            @per_page = 20
            @page = 2
            get :index, page: @page, per: @per_page
          end

          it "returns the correct number of items" do
            expect(response_body_json['customers'].size).to eql @per_page
          end

          it "returns the current page" do
            expect(response_body_json['meta']['currentPage']).to eql @page
          end

          it "returns the next page" do
            expect(response_body_json['meta']['nextPage']).to eql @page + 1
          end

          it "returns the previous page" do
            expect(response_body_json['meta']['prevPage']).to eql @page - 1
          end

          it "returns the number of pages" do
            expect(response_body_json['meta']['totalPages'])
              .to eql @user.customers.page(@page).per(@per_page).total_pages
          end
        end
      end
    end
  end

  context "abilities" do
    let(:user){ FactoryGirl.create(:user) }
    let(:other_user){ FactoryGirl.create(:user) }
    let(:customer){ FactoryGirl.create(:customer, user: user) }

    before do
      sign_in other_user
    end

    context "when other user tries to access" do
      context "GET #show" do
        it "returns 403 HTTP status code" do
          get :show, id: customer.id.to_s
          expect(response).to have_http_status :forbidden
        end
      end

      context "PUT #update" do
        it "returns 403 HTTP status code" do
          put :update, id: customer.id.to_s, customer: @update_params
          expect(response).to have_http_status :forbidden
        end
      end

      context "DELETE #destroy" do
        it "returns 403 HTTP status code" do
          delete :destroy, id: customer.id.to_s
          expect(response).to have_http_status :forbidden
        end
      end
    end
  end
end
