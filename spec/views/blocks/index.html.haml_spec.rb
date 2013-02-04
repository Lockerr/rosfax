require 'spec_helper'

describe "blocks/index.html.haml" do
  before(:each) do
    assign(:blocks, [
      stub_model(Block,
        :month => 1,
        :day => 1,
        :hour => 1,
        :company_id => 1
      ),
      stub_model(Block,
        :month => 1,
        :day => 1,
        :hour => 1,
        :company_id => 1
      )
    ])
  end

  it "renders a list of blocks" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
