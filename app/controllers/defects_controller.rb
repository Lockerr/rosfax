class DefectsController < ApplicationController
  # GET /defects
  # GET /defects.json




  def index
    @defects = Defect.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @defects }
    end
  end

  # GET /defects/1
  # GET /defects/1.json
  def show
    @defect = Defect.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @defect }
    end
  end

  # GET /defects/new
  # GET /defects/new.json
  def new
    @defect = Defect.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @defect }
    end
  end

  # GET /defects/1/edit
  def edit
    @defect = Defect.find(params[:id])
  end

  # POST /defects
  # POST /defects.json
  def create
    params[:report_id] ? @defect = Report.find(params[:report_id]).defects.new(params[:defect]) : @defect = Defect.new(params[:defect])

    respond_to do |format|
      if @defect.save
        format.html { redirect_to @defect, notice: 'Defect was successfully created.' }
        format.json { render json: @defect, status: :created, location: @defect }
      else
        format.html { render action: "new" }
        format.json { render json: @defect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /defects/1
  # PUT /defects/1.json
  def update
    @defect = Defect.find(params[:id])

    respond_to do |format|
      if @defect.update_attributes(params[:defect])
        format.html { redirect_to @defect, notice: 'Defect was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @defect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /defects/1
  # DELETE /defects/1.json
  def destroy
    @defect = Defect.find(params[:id])
    @defect.destroy

    respond_to do |format|
      format.html { redirect_to defects_url }
      format.json { head :ok }
    end
  end

  def place
    defect = Defect.find(params[:defect_id])
    defect.images.push params[:asset]
    if defect.save
      render :json => {:result => :ok}
    else
      render :json => {:status => :unporecessible_entity}
    end
  end

end
