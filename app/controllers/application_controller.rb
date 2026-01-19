class ApplicationController < ActionController::API
  include GlobalErrorHandler
  include Authentication
  wrap_parameters false
end
