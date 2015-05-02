module ErrorsJsonResponder
  
  def to_json
    errors_only = options.delete(:errors_only)
    if errors_only && !has_errors?
      render nothing: true
      return
    end
    if defined?(super)
      super
    else
      to_format
    end
  end

  def json_resource_errors
    resource.errors.full_messages
  end
end
