class PlayerPolicy < ApplicationPolicy
  def index?
    puts record
    current_user.admin?
  end
end
