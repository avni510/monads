require 'monads'
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
      expect(STDIN).to receive(:gets) { nil }

      expect(MIO.get_line.call.empty?).to eq(true)
    end

    it "is contains value when user input is received" do
      expect(STDIN).to receive(:gets) { "hi" }

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
      expect(STDOUT).to receive(:puts).with(contents)
      expect(MIO.puts_str.call(contents).empty?).to eq(true)
    end

    it "is empty for contents that have a value" do
      contents = "hi"
      expect(STDOUT).to receive(:puts).with(contents)
      expect(MIO.puts_str.call(contents).empty?).to eq(true)
    end
  end

  describe ".bind" do
    it "is empty for an empty MIO" do
      monad_io = MIO.new_empty

      expect(monad_io.bind(MIO.get_contents).empty?).to eq(true)
    end

    it "returns an MIO with value if it a value is passed in" do
      file = Tempfile.new("foo")
      file_path = file.path
      file.write("bar")
      file.close

      monad_io = MIO.new(file_path)

      expect(monad_io.bind(MIO.get_contents).empty?).to eq(false)
      expect(monad_io.bind(MIO.get_contents).value).to eq("bar")
      file.unlink
    end

    it "can be chained together" do
      expect(STDIN).to receive(:gets) { "foo" }
      file = Tempfile.new("foo")
      file_path = file.path
      file.write("hello world")
      file.close

      expect(MIO.get_line.call()
              .bind(MIO.get_contents)
              .bind(MIO.puts_str).empty?).to eq(true)
      file.unlink
    end
  end
end
