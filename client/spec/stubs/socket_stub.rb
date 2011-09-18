class SocketStub < Struct.new(:static_data)
  def initialize(*args)
    super
    self.caret_position = 0
  end
  
  def getbyte
    getc.ord
  end

  def getc
    result = static_data[caret_position]
    move_caret!
    result
  end

  protected

  attr_accessor :caret_position

  def move_caret!
    self.caret_position += 1
  end
end
