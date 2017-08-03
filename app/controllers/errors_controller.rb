class ErrorsController < ApplicationController
  def routing
    json_response({ message: "wrong request" }, :bad_request)
  end
end
