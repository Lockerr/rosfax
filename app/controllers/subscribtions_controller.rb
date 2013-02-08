class SubscribtionsController < ApplicationController
  # GET /subscribtions
  # GET /subscribtions.json
  def index
    @subscribtions = Subscribtion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscribtions }
    end
  end

  # GET /subscribtions/1
  # GET /subscribtions/1.json
  def show
    @subscribtion = Subscribtion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscribtion }
    end
  end

  # GET /subscribtions/new
  # GET /subscribtions/new.json
  def new
    @subscribtion = Subscribtion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscribtion }
    end
  end

  # GET /subscribtions/1/edit
  def edit
    @subscribtion = Subscribtion.find(params[:id])
  end

  # POST /subscribtions
  # POST /subscribtions.json
  def create
    @subscribtion = Subscribtion.new(params[:subscribtion])

    respond_to do |format|
      if @subscribtion.save
        format.html { redirect_to @subscribtion, notice: 'Subscribtion was successfully created.' }
        format.json { render json: @subscribtion, status: :created, location: @subscribtion }
      else
        format.html { render action: "new" }
        format.json { render json: @subscribtion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscribtions/1
  # PUT /subscribtions/1.json
  def update
    @subscribtion = Subscribtion.find(params[:id])

    respond_to do |format|
      if @subscribtion.update_attributes(params[:subscribtion])
        format.html { redirect_to @subscribtion, notice: 'Subscribtion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscribtion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscribtions/1
  # DELETE /subscribtions/1.json
  def destroy
    @subscribtion = Subscribtion.find(params[:id])
    @subscribtion.destroy

    respond_to do |format|
      format.html { redirect_to subscribtions_url }
      format.json { head :no_content }
    end
  end
end
