require "./spec_helper"

def remove_comments(sql)
  sql = sql.lines[1..-1].join "\n"
  sql.gsub(/^\s*--.*?\n/, "").strip
end

def get_metadata(sql)
  sql.lines[0].gsub(/^\s*-- name: ([a-z\_\?\!]+?\(.*?\)).*?\n/) do |token, match|
    match[1]
  end
end

def parse(sql, params : NamedTuple)
  meta = get_metadata(sql)
  sql = remove_comments(sql)
  sql.gsub(/\{\{(.*?)\}\}/) do |token, match|
    params[match[1]]
  end
end

describe Tren do

  sql = <<-SQL
    -- name: get_users(name, surname)
    select * from users where name = '{{name}}' and name = '{{surname}}'
  SQL

  it "should get metadata" do
    get_metadata(sql).should eq("get_users(name, surname)")
  end

  it "should parse" do
    parse(sql, {
      name: "kemal",
      surname: "tren"
    }).should eq("select * from users where name = 'kemal' and name = 'tren'")
  end
end
