require "./spec_helper"
require "../src/parser"

describe Parser do
  describe "#metadata?" do
    it "matches valid metadata lines" do
      parser = Parser.new([] of String)
      parser.metadata?("-- name: get_users(name : String)").should_not be_nil
      parser.metadata?(" -- name: get_users_2?(id : Int32)").should_not be_nil
    end

    it "does not match malformed metadata lines" do
      parser = Parser.new([] of String)
      parser.metadata?("-- name get_users(name : String)").should be_nil
      parser.metadata?("-- name: GetUsers(name : String)").should be_nil
      parser.metadata?("-- name: ").should be_nil
    end
  end

  describe "#sql?" do
    it "ignores comments and blank lines" do
      parser = Parser.new([] of String)
      parser.sql?("-- this is a comment").should be_nil
      parser.sql?("   ").should be_nil
      parser.sql?("\t").should be_nil
    end

    it "accepts sql lines" do
      parser = Parser.new([] of String)
      parser.sql?("SELECT * FROM users").should_not be_nil
    end
  end

  describe "#parse_sql" do
    it "escapes regular parameters and keeps raw parameters as is" do
      parser = Parser.new([] of String)
      sql = "SELECT * FROM users WHERE name = '{{ name }}' AND raw = {{! clause }}"

      parser.parse_sql(sql).should eq(
        "SELECT * FROM users WHERE name = '\#{Tren.escape( name )}' AND raw = \#{ clause }"
      )
    end
  end
end
