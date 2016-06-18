require 'rails_helper'

RSpec.describe "authors/new", type: :view do
  before(:each) do
    assign(:author, Author.new(
      :user => nil,
      :name => "MyString",
      :email => "MyString"
    ))
  end

  it "renders new author form" do
    render

    assert_select "form[action=?][method=?]", authors_path, "post" do

      assert_select "input#author_user_id[name=?]", "author[user_id]"

      assert_select "input#author_name[name=?]", "author[name]"

      assert_select "input#author_email[name=?]", "author[email]"
    end
  end
end
