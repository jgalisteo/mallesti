class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Customer
    can :manage, Project
    can :manage, Task

    cannot [:show, :update, :destroy], Customer do |customer|
      customer.user != user
    end
  end
end
