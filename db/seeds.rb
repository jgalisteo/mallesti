user = FactoryGirl.create(:user)
customers = FactoryGirl.create_list(:customer, 2, user: user)

projects = FactoryGirl.create_list(:project, 2, customer: customers.first)
FactoryGirl.create(:project, customer: customers.last)

FactoryGirl.create_list(:task, 3, project: projects.first)
