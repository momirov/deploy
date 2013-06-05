module ApplicationHelper

  def make_label(status)
    if status == 'completed'
      cls = 'label label-success'
    end
    if status == 'error'
      cls = 'label label-important'
    end
    if status == 'running'
      cls = 'label label-inverse'
    end
    if status == 'canceled'
      cls = 'label'
    end
    content_tag :span, status, :class => cls
  end

  def base64_image(image)
    ActiveSupport::Base64.encode64(image)
  end

  def embed_gravatar(email)
    base64_image(Gravatar.new(email).image_data(:d => 'mm'))
  end
end
