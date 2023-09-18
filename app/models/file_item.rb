require_relative '../../app/models/item'

class FileItem < Item
  attr_accessor :content, :created_by

  def initialize(name, content = '', created_by = nil)
    super(name)
    @content = content
    @created_by = created_by
  end

  def display
    "#{self.class}: #{@name} (Created by: #{@created_by})"
  end
end
