require "spec_helper"

describe ReportsController do
  describe "routing" do

    before(:each) do
      @report = mock_model(Report, id: 1, slug: 'some')
      Report.stub!(find_by_slug: @report, :all => [@report])
      Tradein::Application.reload_routes!
    end

    it "routes to #index" do
      get("/reports").should route_to("reports#index")
    end

    it "routes to #new" do
      get("/reports/new").should route_to("reports#new")
    end

    it "routes to #show" do
      get("/reports/1").should route_to("reports#show", :id => "1")
    end

    it "routes to #edit" do
      get("/reports/1/edit").should route_to("reports#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reports").should route_to("reports#create")
    end

    it "routes to #update" do
      put("/reports/1").should route_to("reports#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reports/1").should route_to("reports#destroy", :id => "1")
    end

    it 'route to short' do
      get('/1').should route_to('reports#show', id: 1)
    end

  end
end
