class ReportsController < ApplicationController

  before_filter :authenticate_user!
  # GET /reports
  # GET /reports.json
  layout 'report'
  def models
    @reports = Report.where(:model_id => params[:ids].split(','))
    render :index
  end

  def index
    current_user.admin? ? @reports = Report.all : @reports = current_user.reports

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])
    @models = Model.includes(:brand).select(['models.name', 'brands.name']).map {|y| [y.brand.name, y.name].join(' ')}.sort

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
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
  end

  # POST /reports
  # POST /reports.json
  def create

    @report = current_user.reports.new(params[:report])

    @models = {}
    Model.includes(:brand).select(['models.name', 'brands.name', 'models.id']).map {|y| @models[[y.brand.name, y.name].join(' ')] = y.id}.sort

    @report.model = Model.find( @models[params[:report][:car_mark_model]] )

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report}
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
      if @report.update_attributes(params[:report].except!(:id))
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
      format.html { render :inline => 'ok' }
      format.json { head :ok }
    end
  end

  def images
    @report = Report.find(params[:report_id])
    ids = @report.send(params[:attribute]).values.flatten.map { |i| i.to_i }

    assets = Asset.where(:id => ids).map { |i| i.url(:carousel) }
    assets.push Asset.where(:id => @report.send( params[:attribute] )[ params[:place] ].first).first.url(:carousel) if  @report.send( params[:attribute] )[ params[:place] ]

    render :json => assets.reverse.uniq
  end

  def image
    @report = Report.find(params[:report_id])
    if id = @report.send(params[:attribute])[params[:place]]
      image = Asset.find(id.first).url(:thumb)
    else
      image = 'https://s3-eu-west-1.amazonaws.com/rosfax/box.png'
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