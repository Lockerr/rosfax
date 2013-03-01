#encoding: utf-8
class ReportsController < ApplicationController
  load_and_authorize_resource

  cache_sweeper :report_sweeper

  # before_filter :authenticate_user!, :except => [:index]

  caches_action :edit
  caches_action :show, :cache_path => proc {
    @report = Report.find(params[:id])
      if request.format == 'text/html'
        report_url(@report, :access_key => (params[:access_key] if params[:access_key] and params[:acces_key] == @report.access_key))
      elsif request.format == 'application/pdf'
        report_url(@report, :format => :pdf, :access_key => (params[:access_key] if params[:access_key] and params[:acces_key] == @report.access_key))
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
      @reports = Report.public.scoped
    end

    @reports = @reports.joins([:brand, :country]).where(Subscription.find(params[:subscribtion_id]).filter) if params[:subscribtion_id]
    @reports = @reports.page params[:page]
    @reports = @reports.order('id desc')

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
      format.xml {render xml: @report.build_xml}
      format.html { render :layout => 'report_show'}
      format.json { render json: @report }
      format.pdf {render :pdf => "report_#{@report_id}", :layout => 'report_show_pdf.html.haml'}
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


      @points = @report.points.includes(:assets)

      @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort


    respond_to do |format|
      
        format.html { render :layout => 'report'}
        format.json { render json: @report }
      
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
    @report = Report.find(params[:id])

    if params[:report][:links]
      params[:report][:links] = @report.links + [params[:report][:links]]
    end

    respond_to do |format|
        if @report.update_attributes(params[:report].except!(:id))
          format.json { head :ok }
        else
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_to :back
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

  def empty_form
    @report = Report.find(params[:report_id])
    @diff = @report.diff
    @filled_points = @report.points.filled
    @points = @report.points
    render :pdf => "report_#{@report_id}", :layout => 'pdf.html.haml'
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

  def access
  end

  private
end