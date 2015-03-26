module ApplicationHelper

  def current_user_owns?(obj)
    user_signed_in? && current_user.owns?(obj)
  end
end
