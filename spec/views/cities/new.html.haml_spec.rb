require 'spec_helper'

describe "cities/new" do
  before(:each) do
    assign(:city, stub_model(City,
      :name => "MyString",
      :cities_count => "MyString",
      :integer => "MyString"
    ).as_new_record)
  end

  it "renders new city form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cities_path, :method => "post" do
      assert_select "input#city_name", :name => "city[name]"
      assert_select "input#city_cities_count", :name => "city[cities_count]"
      assert_select "input#city_integer", :name => "city[integer]"
    end
  end
end
