class ApplicationController < ActionController::API
  include AuthJwtGo
  include ExceptionHandler

  before_action :authorized_user
end
