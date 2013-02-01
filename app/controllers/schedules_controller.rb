#encoding: utf-8
class SchedulesController < ApplicationController
  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = Schedule.all


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schedules }
      format.js {render partial: 'calendar', layout: false}
    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    @schedule = Schedule.find(params[:id])
    @schedules = @schedule.company.schedules

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.json
  def new
    if params[:city] and params[:center]
      @center = Company.find(params[:center])
      @schedules = @center.schedules
    end
    @schedule = Schedule.new
    if params[:schedule]
      @schedule.inspection_start_time = (Date.today + params[:schedule][:date].to_i.days + 2.day) + params[:schedule][:time].to_i.hours
      @schedule.company_id = params[:schedule][:company]
    end



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @schedule }
      format.js
    end
  end

  # GET /schedules/1/edit
  def edit
    @schedule = Schedule.find(params[:id])
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(params[:schedule])

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: "Вы успешно записаны на осмотр Rosfax на #{Russian::strftime(@schedule.inspection_start_time, '%H:00  %d %B %Y')}." }
        format.json { render json: @schedule, status: :created, location: @schedule }
      else
        format.html { render action: "new" }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.json
  def update
    @schedule = Schedule.find(params[:id])
    params[:schedule][:inspection_start_time] = (Date.today + params[:schedule][:date].to_i.days + 2.day) + params[:schedule][:time].to_i.hours
    respond_to do |format|
      if @schedule.update_attributes(params[:schedule].except('time', 'date'))
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { render json: {time: params[:schedule][:time], date: params[:schedule][:date], status: :ok}}
        format.js {
          if params[:schedule][:time]
            render 'move'
          end
        }
      else
        format.html { render action: "edit" }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @schedule = Schedule.find(params[:schedule_id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to schedules_url }
      format.json { head :no_content }
    end
  end
end
