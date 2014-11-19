# encoding: utf-8
module V1
  class BaseController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::ImplicitRender
  end
end
