class ApplicationController < ActionController::API
  include GlobalErrorHandler
  include Authentication
end
