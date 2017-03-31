class UserPolicy < ApplicationPolicy
  def index?
    puts record
  end
end
