class AdminAbility
    include CanCan::Ability
  
    def initialize(admin_user)
      return unless admin_user
  
      # Admin can manage everything
      can :manage, :all
  
      # Specific permissions
      can :manage, Product
      can :manage, Category
      can :manage, Order
      can :manage, User
      can :manage, Review
      can :manage, Cart
      can :manage, CartItem
      can :manage, OrderItem
    end
  end