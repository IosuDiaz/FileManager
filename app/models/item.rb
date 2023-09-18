class Item
  attr_accessor :name, :created_at, :updated_at

  def initialize(name)
    @name = name
    @created_at = DateTime.now
    @updated_at = DateTime.now
  end

  def display
    "#{self.class}: #{@name}"
  end
end
