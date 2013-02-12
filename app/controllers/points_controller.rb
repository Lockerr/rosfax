class PointsController < ApplicationController
  load_and_authorize_resource

  cache_sweeper :report_sweeper

  def index
    @points = Point.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @points }
    end
  end

  def show
    @point = Point.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @point }
    end
  end

  def new
    @point = Point.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @point }
    end
  end

  def edit
    @point = Point.find(params[:id])
  end

  def create
    @point = Point.new(params[:point])


    respond_to do |format|
      if @point.save
        format.html { redirect_to @point, notice: 'Point was successfully created.' }
        format.json { render json: @point, status: :created, location: @point }
      else
        format.html { render action: "new" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def remove_image
    raise params.inspect
  end

  def update
    @point = Point.find(params[:id])
    params[:point][:condition] = nil if params[:point][:condition] == ''
    params[:point][:state] = nil if params[:point][:state] == ''

    respond_to do |format|
      if @point.update_attributes(params[:point].except(:id))
        format.html { redirect_to @point, notice: 'Point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @point = Point.find(params[:id])
    @point.destroy

    respond_to do |format|
      format.html { redirect_to points_url }
      format.json { head :no_content }
    end
  end



end
