module UsersHelper
  def user_sort_opt
    User.sort_enums.reduce([]){|a, e| a << [I18n.t((e[0]).to_s), e[0]]}
  end

  def check_user_status user
    user.status if user&.status
  end

  def check_user_role user
    user.role if user&.role
  end

  def load_role_select
    User.roles.map do |t|
      [(t[0]).to_s, t[1]]
    end
  end
end
