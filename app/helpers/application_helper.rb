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
    Base64.encode64(image)
  end

  def embed_gravatar(email)
    base64_image(Gravatar.new(email).image_data(:d => 'mm'))
  end

  def format_message(message)
    html = simple_format(message)
    html.gsub(/\b(Change-Id:\s*)([A-Za-z0-9]*)\b/, '\1' + link_to('\2', 'http://gerrit.saturized.com/r/\2'))
  end
end
