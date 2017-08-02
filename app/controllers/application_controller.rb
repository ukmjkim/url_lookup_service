# Application Level Controller
class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
end
