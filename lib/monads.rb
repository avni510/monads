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
      lambda do
        user_input = STDIN.gets
        MIO.new(user_input)
      end
    end

    def get_contents
      lambda do |filename|
        begin
          file = File.open(filename) do |f1|
            contents = IO.read(filename)
            contents.nil? ? MIO.new_empty : MIO.new(contents)
          end
        rescue Exception
          MIO.new_empty
        end
      end
    end

    def puts_str
      lambda do |contents|
        STDOUT.puts contents
        MIO.new_empty
      end
    end

    def new_empty
      self.new(nil)
    end

  end
end
