class Ability
  include CanCan::Ability

  def initialize user
    can :read, [Product, Table]
    return unless user

    can [:show, :update], User, id: user.id
    case user.role
    when "admin"
      can :manage, :all
    when "staff"
      can :manage, [Admin, OrderDetail, OrderTable, Order]
    when "guest"
      can :create, Order
    end
  end
end
