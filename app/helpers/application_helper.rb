module ApplicationHelper

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

  # unescape html (need for js templates)
  def jst(str)
    CGI::unescape_html CGI::unescape(str)
  end
end
