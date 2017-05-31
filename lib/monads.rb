class MIO
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def empty?
    value.nil?
  end

  def bind(function)
    if self.empty?
      MIO.new_empty
    else
      function.call(self.value)
    end
  end

  class << self

    def get_line
      @@get_line
    end

    def get_contents
      @@get_contents
    end

    def puts_str
      @@puts_str
    end

    def new_empty
      self.new(nil)
    end

    @@get_line = lambda {
      user_input = FakeIO.gets
      MIO.new(user_input) }

    @@get_contents = lambda { |filename|
      begin
        file = File.open(filename) do |f1|
          contents = IO.read(filename)
          contents.nil? ? MIO.new_empty : MIO.new(contents)
        end
      rescue Exception
        MIO.new_empty
      end
    }

    @@puts_str = lambda { |contents|
      puts contents
      MIO.new_empty
    }
  end
end

class FakeIO
  @value = nil

  def self.gets
    @value
  end

  def self.set_value(value)
    @value = value
  end
end
