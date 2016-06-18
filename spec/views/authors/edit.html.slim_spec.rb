require 'rails_helper'

RSpec.describe "authors/edit", type: :view do
  before(:each) do
    @author = assign(:author, Author.create!(
      :user => nil,
      :name => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit author form" do
    render

    assert_select "form[action=?][method=?]", author_path(@author), "post" do

      assert_select "input#author_user_id[name=?]", "author[user_id]"

      assert_select "input#author_name[name=?]", "author[name]"

      assert_select "input#author_email[name=?]", "author[email]"
    end
  end
end
