require "./spec_helper"

Tren.load("#{__DIR__}/fixtures/test.sql")
Tren.load("#{__DIR__}/fixtures/test2.sql")

describe Tren do
  it "should create and use method" do
    get_users("fatih", "akin").should eq("select * from users where name = 'fatih' and name = 'akin'")
  end

  it "should overload method" do
    get_users("fatih", 2).should eq("select * from users where name = 'fatih' and age = 2")
  end
end
