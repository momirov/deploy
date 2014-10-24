module ApplicationHelper

  def make_label(status)
    if status == 'completed'
      cls = 'label label-success'
    end
    if status == 'error'
      cls = 'label label-danger'
    end
    if status == 'running'
      cls = 'label label-inverse'
    end
    if status == 'canceled'
      cls = 'label label-warning'
    end
    content_tag :span, status, :class => cls
  end

  def format_message(message)
    html = simple_format(message)
    html.gsub(/\b(Change-Id:\s*)([A-Za-z0-9]*)\b/, '\1' + link_to('\2', 'http://gerrit.saturized.com/r/\2'))
  end
end
