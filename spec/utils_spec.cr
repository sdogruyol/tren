require "./spec_helper"

describe Tren do
  describe ".escape" do
    it "escapes single quotes and backslashes in strings" do
      Tren.escape("O'Brien\\admin").should eq("O\\'Brien\\\\admin")
    end

    it "preserves unicode while escaping quotes" do
      Tren.escape("Doğruyol's café").should eq("Doğruyol\\'s café")
    end

    it "returns non-string values unchanged" do
      Tren.escape(42).should eq(42)
      Tren.escape(true).should eq(true)
      Tren.escape(nil).should be_nil
    end

    it "supports custom escape character" do
      Tren.escape_character = "\\'"
      Tren.escape("a'b\\c").should eq("a\\''b\\'\\c")
      Tren.escape_character = "\\"
    end
  end
end
