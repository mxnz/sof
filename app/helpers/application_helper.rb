module ApplicationHelper

  def current_user_owns?(obj)
    user_signed_in? && current_user.owns?(obj)
  end

  def j_render(*args)
    # There is a parsing bug in "remotipart" gem.
    # The bug is remotipart don't remove a textarea wrapper around js code.
    # The code below fixes that bug.
    if remotipart_submitted?
      j "#{render(*args)}"
    else
      j render(*args)
    end
  end
end
