#encoding: utf-8
class SchedulesController < ApplicationController
  load_and_authorize_resource


  # GET /schedules
  # GET /schedules.json
  def index
    @center = Center.find(params[:center]) if params[:center]

    if @center 
      @schedules = @center.schedules
    elsif current_user
      @schedules = current_user.center.schedules
    else
      @schedules = []
    end
    respond_to do |format|
      format.html
      format.json { render json: @schedules }
      format.js {render partial: 'calendar', layout: false}
    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show

    @schedule = Schedule.find(params[:id])
    @schedules = @schedule.center.schedules
    @center = @schedule.center

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.json
  def new
    if params[:city] and params[:center]
      @center = Center.find(params[:center])
      @schedules = @center.schedules
      @schedule = Schedule.new
    elsif params[:center_id]
      @center = Center.find(params[:center_id]) if params[:center_id]
      @schedule = @center.schedules.new
      @schedules = @center.schedules
    else
      @schedule = Schedule.new
    end



    if params[:schedule]
      for key in params[:schedule].keys
        @schedule[key] = params[:schedule][key]
      end
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
        @schedule.notify_about_creation
        flash[:js] = "Вы успешно забронировали осмотр Rosfax в #{@schedule.center.name} на #{@schedule.hour} часов #{Russian::strftime(@schedule.date, '%d %B %Y')}.<br/> В ближайшее время Вам перезвонит менеджер автосалона \"#{@schedule.center.name}\" для подтверждения бронирования и уточнения возможных вопросов.<br/> Спасибо, что воспользовались нашим сервисом!"
        format.html { redirect_to (current_user ? @schedule : root_path), notice: "Вы успешно записаны на осмотр Rosfax в #{@schedule.center.name} на #{@schedule.hour} часов #{Russian::strftime(@schedule.date, '%d %B %Y')}." }
        format.json { render json: @schedule, status: :created, location: @schedule }
        format.js 
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

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        @schedule.notify_about_moving if (params[:schedule].keys & ['date', 'hour']).any?
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

  def block
    @schedule = Schedule.find(params[:schedule_id])
    params[:schedule][:inspection_start_time] = (Date.today + params[:schedule][:date].to_i.days + 2.day) + params[:schedule][:time].to_i.hours
    @schedule = Schedule.new
    @schedule.create(params[:schedule].except('time', 'date'))


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
