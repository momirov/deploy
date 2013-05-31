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

  def avatar_url(email)
    default_url = URI.join(root_url, path_to_image('gravatar.png')).to_s
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=mm"
  end
end
