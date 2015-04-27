require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected
    def forbid_if_current_user_doesnt_own(obj)
      render(status: :forbidden, text: 'Forbidden action!') unless current_user.owns?(obj)
    end

end
