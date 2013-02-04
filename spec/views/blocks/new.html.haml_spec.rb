require 'spec_helper'

describe "blocks/new.html.haml" do
  before(:each) do
    assign(:block, stub_model(Block,
      :month => 1,
      :day => 1,
      :hour => 1,
      :company_id => 1
    ).as_new_record)
  end

  it "renders new block form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => blocks_path, :method => "post" do
      assert_select "input#block_month", :name => "block[month]"
      assert_select "input#block_day", :name => "block[day]"
      assert_select "input#block_hour", :name => "block[hour]"
      assert_select "input#block_company_id", :name => "block[company_id]"
    end
  end
end
