class MIO
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def empty?
    value.nil?
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
          if contents.nil?
            MIO.new_empty
          else
            MIO.new(contents)
          end
        end
      rescue Exception
        MIO.new_empty
      end
    }

    @@puts_str = lambda { |contents|
      puts contents
      MIO.new_empty
    }

    def bind(mio, function)
      if mio.empty?
        MIO.new_empty
      else
        function.call(mio.value)
      end
    end
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
