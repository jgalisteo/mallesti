require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  set_content_type 'application/json'

  options = [:show, :index, :create, :update, :destroy]
  json_attributes = FactoryGirl.attributes_for(:task).keys

  before :all do
    @model = Task
    project = FactoryGirl.create(:project)
    @resource = FactoryGirl.create(:task, project: project)
    # Opciones necesarias para crear la lista de tasks en el test de index
    @list_options = {project: project}
    # Parámetros que se envía al get :index
    @index_params = {project_id: project.id.to_s}
    @first_page_resources = project.tasks
    @parameters = FactoryGirl.attributes_for(:task, project_id: project.id.to_s)
    @update_params = FactoryGirl.attributes_for(:task_update)
  end

  it_behaves_like "a REST controller", options, json_attributes

  context "special feature" do
    let(:project1){ FactoryGirl.create(:project) }
    let(:project2){ FactoryGirl.create(:project) }

    context "PUT #update" do
      it "should not update #project_id" do
        task = FactoryGirl.create(:task, project: project1)

        put :update, id: task.id, task: { project_id: project2.id.to_s }
        task.reload

        expect(task.project_id).to eql project1.id
      end
    end

    context "GET #index" do
      it "returns the correct tasks" do
        tasks1 = FactoryGirl.create_list(:task, 2, project: project1)
        FactoryGirl.create_list(:task, 2, project: project2)

        get :index, project_id: project1.id.to_s
        expect(assigns(:tasks).to_a).to match_array tasks1
      end
    end
  end
end