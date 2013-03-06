class CentersController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :update]
  before_filter :is_admin?, :only => :destroy

  load_and_authorize_resource

  # GET /companies
  # GET /companies.json
  def index
      @centers = Center.all
      if params[:city_id]
        @city = City.find(params[:city_id]) if params[:city_id]
        @centers = @city.centers.map{|i|
          [
              id: i.id,
              name: i.name,
              address: i.address || '',
              phone: i.phone ? "+7 (#{i.phone.to_s[0..2]}) #{i.phone.to_s[3..5]}  #{i.phone.to_s[6..7]}  #{i.phone.to_s[8..-1]}" : '',
              asset_url: i.asset_url || '',
              timing_from: i.timing_from || '',
              timing_to: i.timing_to || ''
          ]} if @city
      elsif params[:city_name]
        @city = City.find_by_name(params[:city_name]) if params[:city_name]
        @centers = @city.centers.select(%w(id name)) if @city
      end




    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @centers }
      format.js
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @center = Center.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @center }
    end
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    @center = Center.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @center }
    end
  end

  # GET /companies/1/edit
  def edit
    @center = Center.find(params[:id])
  end

  # POST /companies
  # POST /companies.json
  def create
    @center = Center.new(params[:center])

    respond_to do |format|
      if @center.save
        format.html { redirect_to @center, notice: 'Company was successfully created.' }
        format.json { render json: @center, status: :created, location: @center }
      else
        format.html { render action: "new" }
        format.json { render json: @center.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @center = Center.find(params[:id])

    respond_to do |format|
      if @center.update_attributes(params[:center])
        format.html { redirect_to edit_center_path(@center), notice: 'Company was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @center = Center.find(params[:id])
    @center.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  def upload_logotype
    @center = Center.find(params[:center_id])
    asset = @center.build_asset(data: params[:center][:logo])
    asset.save
    redirect_to :back
  end

end
