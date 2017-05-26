require './monads'
require 'tempfile'

describe "Monads" do
  describe "#empty" do
    it "is true when it contains no value" do
      monad_io = MIO.new_empty
      expect(monad_io.empty?).to eq(true)
    end
  end

  describe "#value" do
    it "returns the value" do
      monad_io = MIO.new(5)
      expect(monad_io.value).to eq(5)
    end
  end

  describe ".get_line" do
    it "is empty when no user input received" do
      FakeIO.set_value(nil)

      expect(MIO.get_line.call.empty?).to eq(true)
    end

    it "is contains value when user input is received" do
      FakeIO.set_value("hi")

      expect(MIO.get_line.call.value).to eq("hi")
    end
  end

  describe ".get_contents" do
    it "is empty when the filename does not exist" do
      file_path = "foo.rb"

      expect(MIO.get_contents.call(file_path).empty?).to eq(true)
    end

    it "returns the file contents when it does exist" do
      file = Tempfile.new("foo")
      file_path = file.path
      file.write("hello world")
      file.close

      contents = MIO.get_contents.call(file_path)
      expect(contents.empty?).to eq(false)
      expect(contents.value).to eq("hello world")
      file.unlink
    end
  end

  describe ".puts_str" do
    it "is empty for a nil value" do
      contents = nil
      expect(MIO.puts_str.call(contents).empty?).to eq(true)
    end

    it "is empty for contents that have a value" do
      contents = "hi"
      expect(MIO.puts_str.call(contents).empty?).to eq(true)
    end
  end

  describe ".bind" do
    it "is empty for an empty MIO" do
      monad_io = MIO.new_empty

      expect(MIO.bind(monad_io, MIO.get_contents).empty?).to eq(true)
    end

    it "returns an MIO with value if it a value is passed in" do
      file = Tempfile.new("foo")
      file_path = file.path
      file.write("bar")
      file.close

      monad_io = MIO.new(file_path)

      expect(MIO.bind(monad_io, MIO.get_contents).empty?).to eq(false)
      expect(MIO.bind(monad_io, MIO.get_contents).value).to eq("bar")
      file.unlink
    end
  end
end
