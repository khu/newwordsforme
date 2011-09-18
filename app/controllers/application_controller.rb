class ApplicationController < ActionController::Base
  include  SessionsHelper
  Tabs.send('include', Rails.application.routes.url_helpers)

  protect_from_forgery
end
