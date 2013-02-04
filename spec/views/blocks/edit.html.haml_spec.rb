require 'spec_helper'

describe "blocks/edit.html.haml" do
  before(:each) do
    @block = assign(:block, stub_model(Block,
      :new_record? => false,
      :month => 1,
      :day => 1,
      :hour => 1,
      :company_id => 1
    ))
  end

  it "renders the edit block form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => block_path(@block), :method => "post" do
      assert_select "input#block_month", :name => "block[month]"
      assert_select "input#block_day", :name => "block[day]"
      assert_select "input#block_hour", :name => "block[hour]"
      assert_select "input#block_company_id", :name => "block[company_id]"
    end
  end
end
