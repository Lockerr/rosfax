class ReportsController < ApplicationController

  before_filter :authenticate_user!
  # GET /reports
  # GET /reports.json
  layout 'report'

  def index
    @reports = Report.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.json { head :ok }
      else
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.jsonsdfsdf
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url }
      format.json { head :ok }
    end
  end

  def images
    @report = Report.find(params[:report_id])
    ids = @report.send(params[:attribute]).values.flatten.map { |i| i.to_i }

    assets = Asset.where(:id => ids).map { |i| i.url(:carousel) }
    assets.push Asset.where(:id => @report.send( params[:attribute] )[ params[:place] ].first).first.url(:carousel)

    render :json => assets.reverse.uniq
  end

  def image
    @report = Report.find(params[:report_id])
    if id = @report.send(params[:attribute])[params[:place]].first
      image = Asset.find(id).url(:thumb)
    else
      image = '/assets/box.png'
    end
    render :json => image
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
