# encoding: utf-8
module V1
  class BaseController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::ImplicitRender

    before_action :set_locale

    def set_locale
      I18n.locale = (params[:locale] || 'robot') || I18n.default_locale
    end

  end
end
