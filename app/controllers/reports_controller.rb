#encoding: utf-8
class ReportsController < ApplicationController

  before_filter :authenticate_user!


  layout 'clean'

  def models
    @reports = Report.public.where(:model_id => params[:ids].split(','))
    render :index
  end

  def index
    current_user.admin? ? @reports = Report.scoped : @reports = current_user.reports.scoped

    respond_to do |format|
      format.html {
        @reports = @reports.includes(:points)
        @reports = @reports.includes(:assets)
      }
      format.json { render json: @reports }
    end
  end

  def show
    @report = Report.find(params[:id])
    
    if @report.user == current_user or current_user.admin?
      @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort
    end

    respond_to do |format|
      if @report.user == current_user or current_user.admin?
        format.html { render :layout => 'report_show'}
        format.json { render json: @report }
      else
        format.html { render :inline => 'Нет доступа'}
        format.json { render json: 'Нет доступа'.to_json, status: :unauthorized}
      end
    end
  end

  def counters
    @report = Report.find(params[:report_id])
    render :json => {:counters => @report.counters}
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new
    @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
    
    if @report.user == current_user or current_user.admin?
      @points = @report.points
      @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort
    end
    
    respond_to do |format|
      if @report.user == current_user or current_user.admin?
        format.html { render :layout => 'report'}
        format.json { render json: @report }
      else
        format.html { render :inline => 'Нет доступа'}
        format.json { render json: 'Нет доступа'.to_json, status: :unauthorized}
      end
    end
  end

  def create

    @report = current_user.reports.new(params[:report])

    @models = {}
    Model.includes(:brand).select(['models.name', 'brands.name', 'models.id']).map {|y| @models[[y.brand.name, y.name].join(' ')] = y.id}.sort

    @report.model = Model.find( @models[params[:report][:car_mark_model]] )

    respond_to do |format|
      if @report.save
        format.html { redirect_to edit_report_path(@report)}
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @report = Report.find(params[:id])
    
    respond_to do |format|
      if @report.user == current_user or current_user.admin?
        if @report.update_attributes(params[:report].except!(:id))
          expire_fragment ['show', @report]
          format.json { head :ok }
        else
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :inline => 'Нет доступа'}
        format.json { render json: 'Нет доступа'.to_json, status: :unauthorized}
      end
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { render :inline => 'ok' }
      format.json { head :ok }
    end
  end

  def all_images
    @report = Report.find(params[:report_id])
    asset = Asset.find(params[:asset_id])
    assets = @report.assets
    assets.delete asset
    assets.insert 0,asset

    if assets
      render :json => assets.map {|i| i.url(:carousel)}
    else
      render :json => nil
    end

  end

  def place
    report = Report.find(params[:report_id])
    report.place(:position => params[:position], :asset => params[:asset], :attribute => params[:attribute])
    render :json => {:result => :ok}
  end

  def remove_asset
    images = Report.find(params[:report_id]).remove_asset(params)

    render :json => {:status => :ok, :images => images, :places => images.keys}
  end

end