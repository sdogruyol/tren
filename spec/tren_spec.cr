require "./spec_helper"

Tren.load("#{__DIR__}/fixtures/test.sql")
Tren.load("#{__DIR__}/fixtures/test2.sql")
Tren.load("#{__DIR__}/fixtures/test3.sql")

describe Tren do
  it "should create and use method" do
    get_users("fatih", "akin").should eq("select * from users where name = 'fatih' and name = 'akin'")
  end

  it "should overload method" do
    get_users("fatih", 2).should eq("select * from users where name = 'fatih' and age = 2")
  end

  it "should create and use method" do
    get_user_info("alper", "t").should eq("select * from users where name = 'alper' and name = 't'")
  end

  it "should overload method" do
    get_users_info("alpert", 42, 52).should eq("select * from users where name = 'alpert' and age BETWEEN 42 and 52")
  end

end
