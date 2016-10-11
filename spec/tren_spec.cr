require "./spec_helper"

Tren.load("#{__DIR__}/fixtures/test.sql")
Tren.load("#{__DIR__}/fixtures/test2.sql")
Tren.load("#{__DIR__}/fixtures/test3.sql")
Tren.load("#{__DIR__}/fixtures/test4.sql")

describe Tren do
  it "should create and use method" do
    get_users("fatih", "akin").should eq("select * from users where name = 'fatih' and name = 'akin'")
  end

  it "should overload method" do
    get_users("fatih", 2).should eq("select * from users where name = 'fatih' and age = 2")
  end
  # parse multiple queries from a file
  it "should parse first of multiple queries from a file" do
    get_user_info("alper", "t").should eq("select * from users where name = 'alper' and name = 't'")
  end

  it "should parse second of multiple queries from a file" do
    get_users_info("alpert", 42, 52).should eq("select * from users where name = 'alpert' and age BETWEEN 42 and 52")
  end

  it "should handle double quotes" do
    get_user_info("Serdar \"sdogruyol\"", "Doğruyol").should eq("select * from users where name = 'Serdar \"sdogruyol\"' and name = 'Doğruyol'")
  end
  
  it "should parse multi line  queries from a file" do
    get_users_info("alpert", 42, 52).should eq("select * from users where name = 'alpert' and age BETWEEN 42 and 52")
  end
end
