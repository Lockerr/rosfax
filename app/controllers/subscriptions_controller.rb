class SubscriptionsController < ApplicationController
  # GET /subscribtions
  # GET /subscribtions.json
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscribtions/1
  # GET /subscribtions/1.json
  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscribtions/new
  # GET /subscribtions/new.json
  def new
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscribtions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscribtions
  # POST /subscribtions.json
  def create
    @subscription = Subscription.new(params[:subscription])

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, notice: 'Subscribtion was successfully created.' }
        format.json { render json: @subscription, status: :created, location: @subscription }
      else
        format.html { render action: "new" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscribtions/1
  # PUT /subscribtions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscribtion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscribtions/1
  # DELETE /subscribtions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscribtions_url }
      format.json { head :no_content }
    end
  end
end
