#encoding: UTF-8
require 'spec_helper'
def valid_attributes
  {'name' => 'Челябинск'}
end

describe CitiesController do


  describe "GET index" do
    it "assigns all cities as @cities" do
      city = FactoryGirl.create(:city)
      get :index, {}
      assigns(:cities).should eq([city])
    end
  end

  describe "GET show" do
    it "assigns the requested city as @city" do
      city = FactoryGirl.create(:city)
      get :show, {:id => city.to_param}
      assigns(:city).should eq(city)
    end
  end

  describe "GET new" do
    it "assigns a new city as @city" do
      get :new, {}
      assigns(:city).should be_a_new(City)
    end
  end

  describe "GET edit" do
    it "assigns the requested city as @city" do
      city = FactoryGirl.create(:city)
      get :edit, {:id => city.to_param}
      assigns(:city).should eq(city)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new City" do
        expect {
          post :create, {:city => {name: 'Челябинск'}}
        }.to change(City, :count).by(1)
      end

      it "assigns a newly created city as @city" do
        post :create, {:city => {name: 'Челябинск'}}
        assigns(:city).should be_a(City)
        assigns(:city).should be_persisted
      end

      it "redirects to the created city" do
        post :create, {:city => {name: 'Челябинск'}}
        response.should redirect_to(City.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved city as @city" do
        City.any_instance.stub(:save).and_return(false)
        post :create, {:city => { "name" => "" }}
        assigns(:city).should be_a_new(City)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        post :create, {:city => { "name" => "" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested city" do
        city = FactoryGirl.create(:city)
        # Assuming there are no other cities in the database, this
        # specifies that the City created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        City.any_instance.should_receive(:update_attributes).with(valid_attributes)
        put :update, {:id => city.to_param, :city => valid_attributes}
      end

      it "assigns the requested city as @city" do
        city = FactoryGirl.create(:city)
        put :update, {:id => city.to_param, :city => valid_attributes}
        assigns(:city).should eq(city)
      end

      it "redirects to the city" do
        city = FactoryGirl.create(:city)
        put :update, {:id => city.to_param, :city => valid_attributes}
        response.should redirect_to(city)
      end
    end

    describe "with invalid params" do
      it "assigns the city as @city" do
        city = FactoryGirl.create(:city)
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        put :update, {:id => city.to_param, :city => { "name" => "" }}
        assigns(:city).should eq(city)
      end

      it "re-renders the 'edit' template" do
        city = FactoryGirl.create(:city)
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        put :update, {:id => city.to_param, :city => { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested city" do
      city = FactoryGirl.create(:city)
      expect {
        delete :destroy, {:id => city.to_param}
      }.to change(City, :count).by(-1)
    end

    it "redirects to the cities list" do
      city = FactoryGirl.create(:city)
      delete :destroy, {:id => city.to_param}
      response.should redirect_to(cities_url)
    end
  end

end
