require_relative "usable_object"

class HandwrittenNote
  include UsableObject
  def initialize(content)
    @content = content
  end

  def use
    @content
  end
end
