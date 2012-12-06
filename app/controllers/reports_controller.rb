#encoding: utf-8
class ReportsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index]



  caches_action :edit
  caches_action :show, :cache_path => proc {
    @report = Report.find(params[:id])
    if request.format == 'text/html'
      report_url(@report)
    elsif request.format == 'application/pdf'
      report_url(@report, :format => :pdf)
    end
  }
      

  layout 'clean'

  def models
    @reports = Report.public.where(:model_id => params[:ids].split(','))
    render :index
  end

  def index
    if current_user
      if current_user.admin?
        @reports = Report.scoped
      elsif current_user.company
        @reports = current_user.company.reports.scoped
      else current_user
        @reports = current_user.reports.scoped      
      end
    else
      @reports = Report.public
    end

    

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
    @diff = @report.diff
    @filled_points = @report.points.filled
    
    # if current_user.reports.include? @report or current_user.company.reports.include? @report or current_user.admin?    
      # @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort
    # end

    respond_to do |format|
      if can_manage?
        format.html { render :layout => 'report_show'}
        format.json { render json: @report }
        format.pdf {render :pdf => "report_#{@report_id}", :layout => 'report_show_pdf.html.haml'}
        
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

  def new
    @report = Report.new
    @models = []
    for model in Model.includes(:brand).select(['models.name', 'brands.name'])
      @models.push [[model.brand.name, model.name].join(' '), [model.id, [model.brand.name, model.name].join(' ')]]
      @models.push [[I18n.t(model.brand.name), model.name].join(' '), [model.id,[model.brand.name, model.name].join(' ')]]
    end

    @models = Hash[@models]
    # @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
    
    if can_manage?
      @points = @report.points
      @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort
    end
    
    respond_to do |format|
      if can_manage?
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
        current_user.company ? current_user.company.reports << @report : nil
        format.html { redirect_to edit_report_path(@report)}
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    expire_action edit_report_path(self)
    expire_action report_path(self)
    expire_action report_path(self, :format => :pdf)

    @report = Report.find(params[:id])
    if params[:report][:links]
      params[:report][:links] = @report.links + [params[:report][:links]]
    end

    respond_to do |format|
      if can_manage?
        if @report.update_attributes(params[:report].except!(:id))

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

  private

  def can_manage?
    current_user.admin? or
    @report.company == current_user.company or
    @report.user == current_user


    # current_user.reports.include? @report or current_user.company.reports.include? @report or current_user.admin? 
  end

  


end