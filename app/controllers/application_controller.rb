class ApplicationController < ActionController::API
  include Pundit
  include AbstractController::Translation

  before_action :authenticate_user_from_token!

  respond_to :json

  def self.inherited(subclass)
    authorize_name = subclass.controller_name.singularize
    define_method("authorize_#{authorize_name}") { authorize instance_variable_get("@#{authorize_name}") }
  end

  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authenticate_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    unless auth_token.include?(':')
      authenticate_error
      return
    end

    user_id = auth_token.split(':').first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in user, store: false
    else
      authenticate_error
    end
  end

  def authenticate_error
    render json: { error: t('unauthorized') }, status: 401
  end
end
