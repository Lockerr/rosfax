require 'spec_helper'

describe "reports/edit" do
  before(:each) do
    @report = assign(:report, stub_model(Report))
  end

  it "renders the edit report form" do
    view.lookup_context.prefixes = %w[reports application]
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reports_path(@report), :method => "post" do
    end
  end
end
