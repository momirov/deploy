class GitDiffParser
  def initialize(diff)
    @diff = diff
  end

  def to_html
    @diff.patches
  end

  def get_file

  end
end