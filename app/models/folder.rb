class Folder < Item
  attr_accessor :contents

  def initialize(name)
    super(name)
    @contents = []
  end
end
