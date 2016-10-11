require "./spec_helper"

Tren.load("#{__DIR__}/fixtures/test.sql")
Tren.load("#{__DIR__}/fixtures/test2.sql")
Tren.load("#{__DIR__}/fixtures/test3.sql")
Tren.load("#{__DIR__}/fixtures/multiline.sql")
Tren.load("#{__DIR__}/fixtures/multiple_multiline.sql")
Tren.load("#{__DIR__}/fixtures/escape.sql")
Tren.load("#{__DIR__}/fixtures/injection.sql")
Tren.load("#{__DIR__}/fixtures/glob/**/*.sql")

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

  it "should handle double quotes in sql file" do
    escaped_users_without_parameters.should eq("select * from users where name = 'fatih \"fka\" akin' limit 1")
    escaped_users_without_parameters_2.should eq("select * from users where name = \"hello\" limit 1")
  end

  it "should handle multiline query" do
    multiline("kemal").should eq("select * from users\nwhere name = 'kemal'\nlimit 1")
  end

  it "should escape parameters" do
    injectable("'; drop table users; --").should eq("select * from users where ''; drop table users; --'")
    protection("'; drop table users; --").should eq("select * from users where '\\'; drop table users; --'")
  end

  it "should load glob files" do
    glob_1.should eq("select * from users")
    glob_2.should eq("select * from products")
    glob_3.should eq("select * from prices")
    glob_4.should eq("select * from companies")
  end

  it "should handle multiple multiline queries" do
    multiline_one("kemal").should eq("select * from users\nwhere name = 'kemal'")
    multiline_two("kemal").should eq("select * from users\nwhere name = 'kemal'")
  end
end
