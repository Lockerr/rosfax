#encoding: utf-8
class Report < ActiveRecord::Base

  paginates_per 20
  max_paginates_per 50

  has_many :points, :dependent => :destroy
  has_many :assets, :as => :attachable, :dependent => :destroy
  has_many :links, :dependent => :destroy
  # has_many :defects

  has_many :elements, :class_name => 'Point', :conditions => ['object = ?', :element]
  has_many :defects, :class_name => 'Point', :conditions => ['object = ?', :defect]
  has_many :checks, :class_name => 'Point', :conditions => ['object =?', :check]

  belongs_to :user
  belongs_to :model
  belongs_to :brand
  belongs_to :company
  belongs_to :country

  attr_accessor :car_mark_model, :counters

  validates_presence_of :model
  validates_presence_of :access_key

  serialize :exterior, Hash
  serialize :wheels, Hash
  serialize :interior, Hash
  serialize :under_the_hood, Hash
  serialize :photo_others, Hash
  serialize :car, Hash
  serialize :documents, Hash
  
  after_create :generate_points

  after_update :expire_pages
  after_create :expire_pages
  before_validation :generate_key
  before_destroy :expire_pages


  scope :public, where(:publish => true)
  

  NORMAL_CONDITION = ['ок', 'ok','OK', 'ОК', 'есть', 150, '150', 100, '100']
  BAD_CONDITION = [1, '1', 2,'2', 'НЕУД', 'НЕТ']


  WHEEL = %w(:front_left_wheel :front_right_wheel :rear_right_wheel :rear_left_wheel :stepney)
  
  EXTERIOR_PARTS = %w(:hood :front_right_wing :right_front_door :rear_right_door :rear_right_wing :boot_lid :rear_left_wing :rear_left_door :front_left_door :front_left_wing_of_the :roof :front_bumper :skirt_front_bumper :rear_bumper :rear_apron :right_threshold :left_threshold)
  
  INTERIOR_PARTS =%w(:front_left_seat :front_right_seat :back_sofa :third_row_seats :covering_left_front_door :covering_right_front_door :covering_left_rear_door :covering_rear_right_door :covering_trunk :ceiling :torpedo :central_console :armrest)
  POWERTRAINS = %w(knock flow tear wear)

  ELECTRONIC_PARTS = %w(low_lights distant_lights turning_lights foglights dimensions_lights brakes automatic_windows climate_control air_conditioning radio navigation control_lamps drive_down heated_seats ventilation_seat adjustment_heated_mirrors parktronic_rearview_camera sunroof seat_belts adjustable_steering_column janitors_rein_sensor )
  LIQUID_LEVELS = %w( oil_in_engine oil_in_gearbox brake_fluid fluid_power_steering )
  CHASIS = %w(:full_drive_connection :air_suspension_all_levels :luft_knocking_in_steering_wheel :revolutions_of_twentieth :turns_gas_with_a_sharp)

  WINDOWS = %w( :head-on_window :front_right_window :rear_right_window :rear_right_ventilator :rear_window :rear_left_ventilator :the_rear_left_window :front_left_window )
  DUMPERS = %w(:right_front_bumper :left_front_bumper :right_rear_bumper :left_rear_bumper)
  PHOTO_INTERIOR = %w(:one :two :three :four :five :six :seven :eight :nine)
 
  DEFECTS_CATEGORIES ={
          :exterior => %w(hood front_right_wing right_front_door rear_right_door rear_right_wing boot_lid rear_left_wing rear_left_door front_left_door front_left_wing_of_the roof front_bumper skirt_front_bumper rear_bumper rear_apron right_threshold left_threshold),
          :interior => %w(front_left_seat front_right_seat back_sofa third_row_seats covering_left_front_door covering_right_front_door covering_left_rear_door covering_rear_right_door covering_trunk ceiling torpedo central_console armrest),
          :windows_and_lights => %w(front_left_headlight front_right_headlight rear_left_light rear_right_light head-on-window front_right_window rear_right_window rear_right_ventilator rear_window rear_left_ventilator rear_left_window front_left_window) 
  }


  ETHALON = {
    'checklist' => {"lights"=>{"headlights"=>"ок", "distant_lights"=>"ок", "fog_lights"=>"ок", "marker_lights"=>"ок", "turn_signal"=>"ок", "brake_lights"=>"0", "repeater"=>"1", "brake_lightsfog_lights"=>"ок"}, "electronic"=>{"glass_elevators"=>"ок", "central_locking"=>"ок", "seat_drive"=>"ок", "seat_heat"=>"ок", "mirrors"=>"ок", "hatch"=>"ок", "climat"=>"ок", "radio"=>"ок", "adjustable_wheel"=>"ок", "closer_rain_sensor"=>"ок", "parktronic"=>"ок", "seat_belt"=>"2"}, "liquids"=>{"engine"=>"OK", "transmission"=>"OK", "antifreeze"=>"OK", "power_steering"=>"OK", "brake"=>"OK"}, "completion"=>{"spare_wheel"=>"есть", "jack"=>"есть", "tools"=>"есть", "sealant"=>"есть", "compressor"=>"есть", "key_lock_gear"=>"есть", "theft_of_the_wheels"=>"есть", "keychain_alarm"=>"есть", "keychain_webasto"=>"есть", "key_to_the_locker"=>"есть"}, "documents"=>{"series"=>"1111333", "whom"=>"123", "issued"=>"17.08.2012", "document_validity"=>"0", "country"=>"Россия", "vin"=>"балабалабла", "owner_1_jur"=>"jur", "owner_2_jur"=>"fis", "owner_3_jur"=>"jur", "owner_4_jur"=>"fis", "owner_5_jur"=>"jur", "owner_6_jur"=>"fis", "start_owning_1"=>"01.08.2012", "end_owning_1"=>"02.08.2012", "start_owning_2"=>"03.08.2012", "end_owning_2"=>"04.08.2012", "start_owning_3"=>"05.08.2012", "end_owning_3"=>"06.08.2012", "start_owning_4"=>"07.08.2012", "end_owning_4"=>"08.08.2012", "start_owning_5"=>"09.08.2012", "end_owning_5"=>"10.08.2012", "start_owning_6"=>"11.08.2012", "end_owning_6"=>"12.08.2012"}, "coating"=>{"front_left_wing"=>"200", "front_left_door"=>"300", "rear_left_door"=>"200", "rear_left_wing"=>"300", "front"=>"400+", "roof"=>"400+", "rear"=>"400+", "front_right_wing"=>"100", "front_right_door"=>"200", "rear_right_door"=>"100", "rear_right_wing"=>"200"}},
    'testdrive' => {"suspension"=>{"divestment_steering"=>"ок", "steering_wheel_is_straight"=>"ок", "luft_knock_on_the_handlebars"=>"ок", "air_suspension"=>"ок", "heartbeat_vibration_on_acseletation"=>"ок", "creaks_knocks_on_the_irregularities"=>"ок", "heartbeat_vibration_on_braking"=>"ок"}, "engine"=>{"all_wheel_drive"=>"1", "routes"=>"1", "routes_during_heavy_gas"=>"1", "smoke_from_exhaust"=>"1", "engine_noise"=>"1", "shifting_down"=>"1", "shifting_up"=>"1", "parking_brake"=>"1", "sound_signal"=>"1"}}
  }

  
  #%w(coating lights electronic liquids completion stickers devices)
    # coating: {
    #     names: [
    #       ["front_left_wing", "front_left_door", "rear_left_door", "rear_left_wing", "front_right_wing", "front_right_door"],
    #       ["rear_right_door", "rear_right_wing", "front", "rear", "roof"]
    #       ],
    #   values: [%w(150 300 500 1000)]*2,
    #   legends: ['Краска 1', 'Краска 2']
    # },
  CHECKLIST = {
    
    lights: {
      names: [
        %w( headlights distant_lights fog_lights marker_lights turn_signal headlights_corrector),
        %w(brake_lights  rear_marker_lights rear_turn_signal rear_fog_lights reverse)
      ],
      values: [%w(ОК 1 2)]*2,
      legends: ['Лампы передние','Лампы задние']
    },
    
    
    electronic: {
      names: [
        %w( glass_elevators central_locking seat_drive seat_heat mirrors hatch),
        %w( climat radio adjustable_wheel closer_rain_sensor parktronic seat_belt sound_signal battery_status),
      ],
      values: [%w( ОК УД НЕУД)]*2,
      legends: ['Электроника 1', 'Электроника 2']
    
    },
    
    liquids: {
      names: [
        %w(engine transmission antifreeze power_steering brake),
        %w(engine transmission antifreeze power_steering brake)
      ],
      legends: ['Жидкости - уровень', 'Жидкости - состояние'],
      values: [%w(ОК УД НЕУД), %w(ОК УД НЕУД)]
    },

    completion: {
      names: [
      %w(spare_wheel jack tools sealant compressor key_lock_gear theft_of_the_wheels keychain_alarm keychain_webasto key_to_the_locker)
      ],
      values: [%w(ОК н/п НЕТ)]
    },

    stickers: {
      names: [
      %w(tire_pressure_in_the_doorway information_in_the_doorway under_the_hood on_tank_hatches)
      ],
      values: [%w(ОК н/п НЕТ)]
    },

    devices: {
      names: [
        %w(lamp_srs check_engine speedometer tachometer indication_of_the_lever_automatic_transmission backlight)
      ],
      values: [%w( ОК УД НЕУД)]
    },
  
    suspension: {
      names: [%w(divestment_steering steering_wheel_is_straight luft_knock_on_the_handlebars air_suspension heartbeat_vibration_on_acseletation creaks_knocks_on_the_irregularities heartbeat_vibration_on_braking circular_motion_gur circular_motion_shru)],
      values: [%w(ОК УД НЕУД)]
    },

    engine: {
      names: [%w(engine_start routes routes_during_heavy_gas smoke_from_exhaust engine_noise shifting_down shifting_up parking_brake all_wheel_drive)],
      values: [%w(ОК УД НЕУД)]

    }
  }

  ELEMENTS = {
    exterior: {
      names: [
        %w(hood front_right_wing right_front_door rear_right_door rear_right_wing boot_lid), 
        %w(rear_left_wing rear_left_door front_left_door front_left_wing_of_the roof front_bumper skirt_front_bumper rear_bumper rear_apron right_threshold left_threshold)
        ],
      legends: %w(Краска Краска),
      values: [%w(ОК НОРМ УД НЕУД),%w(ОК НОРМ УД НЕУД)],
      type: :check,
      check: 'ПЕРЕКРАС'
    },
    interior: {
      names: [
        %w(front_left_seat front_right_seat back_sofa third_row_seats covering_left_front_door covering_right_front_door),
        %w(covering_left_rear_door covering_rear_right_door covering_trunk ceiling torpedo central_console armrest)
      ],
      
      values: [%w(ОК НОРМ УД НЕУД),%w(ОК НОРМ УД НЕУД)],
      type: :check,
      check: 'ЗАМЕНА'
    },
    windows_and_lights: {
      names: [
        %w(front_left_headlight front_right_headlight rear_left_light rear_right_light head-on-window front_right_window rear_right_window),
        %w(rear_right_ventilator rear_window rear_left_ventilator rear_left_window front_left_window)
      ],

      values: [%w(ОК НОРМ УД НЕУД), %w(ОК НОРМ УД НЕУД)],
      type: :check,
      check: 'ЗАМЕНА'
    },

    hull: {
      names: [%w(left_front_spar right_front_spar TV left-pillar right-pillar left_rear_spar right_rear_spar boot_floor)],
      values: [%w(ОК УД НЕУД)],
      type: :check,
      check: 'РЕМОНТ'
    },
    under_the_hood: {
      names: [%w(radiators fans belts nozzles power_management fluid_leaks)],
      values: [%w(ОК УД НЕУД)],
      type: :check,
      check: 'ЗАМЕНА'
    }
  }

  TESTDRIVE = %w(suspension engine)
    SUSPENSION = [
      %w(divestment_steering steering_wheel_is_straight luft_knock_on_the_handlebars air_suspension heartbeat_vibration_on_acseletation creaks_knocks_on_the_irregularities heartbeat_vibration_on_braking circular_motion_gur circular_motion_shru),
      %w(ок слабо сильно)
    ]
    ENGINE = [
      %w(engine_start all_wheel_drive routes routes_during_heavy_gas smoke_from_exhaust engine_noise shifting_down shifting_up parking_brake), 
      %w(ОК УД НЕУД)
    ]

  SERVICE_HISTORY = %w(service_history meets_car are_all_the_pages marks_of_all_maintenance instructions)

  def generate_points
    
    CHECKLIST.keys.each do |section|
      CHECKLIST[section][:names].flatten.each do |place|
        points.find_or_create_by_object_and_place_and_section(:checklist,place,section)      
      end
    end

    ELEMENTS.keys.each do |section|
      ELEMENTS[section][:names].flatten.each do |place|
        points.find_or_create_by_object_and_place_and_section(:elements,place,section)      
      end
    end
  end

  def diff
    result = {'checklist' => {}, 'elements' => {}}
    empty = points.where(object: [:checklist, :testdrive]).where('`condition` is NULL').where('`description` is NULL')

    empty.each do |point|
      
      result[point.object][point.section] ||= []
      result[point.object][point.section].push point.place
    end

    empty = points.where(object: :elements).where('`condition` is NULL').where('`description` is NULL').where('`state` is NULL')

    empty.each do |point|
      result[point.object][point.section] ||= []
      result[point.object][point.section].push point.place
    end

    result.any? ? result : false
  end
  
  def model_name
    "#{model.brand.name} #{model.name}"
  end

  def counters
    counters = {}

    tabs = {
      :car => {:car => 8},
      :photo => {
        :exterior => 9,
        :interior => 9,
        :under_the_hood => 9,
        :photo_others => 9,
        :wheels => 36
      },
      :checklist => {
        :documents => 6 + 18,
        :coating => 11,
        :lights => 10,
        :electronic => 12,
        :liquids => 6,
        :completion => 10
      },

       :testdrive => {
         :suspension => 7,
         :engine => 9,
       }
    }

    for key in tabs.keys
      counters[key] ||= {}
      counters[key][:summ] = []
      counters[key][:summ][0] = 0
      for node in tabs[key].keys

        if attributes.keys.include? node.to_s
          counters[key][node] = [send(node).size, tabs[key][node], "#{send(node).size}/#{tabs[key][node]}"]
          counters[key][:summ][0] += send(node).size
        else
          if send(key)[node.to_s]
            counters[key][node] = [send(key)[node.to_s].size, tabs[key][node], "#{send(key)[node.to_s].size}/#{tabs[key][node]}"]
            counters[key][:summ][0] += send(key)[node.to_s].size
          else
            counters[key][node] = [0, tabs[key][node], "0/#{tabs[key][node]}"]
          end
        end
      end
        counters[key][:summ][1] = tabs[key].values.sum
        counters[key][:summ][2] = "#{counters[key][:summ][0]}/#{counters[key][:summ][1]}"
    end

    counters


  end

  def image(attrs)
    if send(attrs[:attribute])[attrs[:place]]
      image = Asset.find(send(attrs[:attribute])[attrs[:place]])
      if image.any?
        {image[-1].id => image[-1].url(attrs[:size]|| :thumb)}
      end
    end
  end

  def self.defects_categories
    result = {}
    for key in sorted_defects_categories.keys
      result[key] = []
      for value in sorted_defects_categories[key]
        result[key].push :k => value, :v => I18n.t("defects.#{key}.#{value}")
      end
    end
    result
  end

  def place(attrs= {})
    send(attrs[:attribute])[attrs[:position]] ||= []
    send(attrs[:attribute])[attrs[:position]].unshift attrs[:asset]

    save
  end

  def images(attrs={})
    collection = {}

    if attrs[:group]
      if attrs[:group] == 'wheels'
        ids = []

        %w(:one :two :three :four).each do |i|
          ids.push send(attrs[:group])[i] if send(attrs[:group])[i]
        end

        ids.flatten!
        # raise ids.flatten.inspect

      else
        ids = send(attrs[:group]).values.flatten
      end

      if ids.any?
        Asset.where(:id => ids.map(&:to_i)).map { |i| collection[i.id] = i.url(attrs[:size]) }
      end

    else
      assets.map { |i| collection[i.id] = i.url(attrs[:size]) }
    end

    collection
  end

  def assigned(attrs={})
    result = []

    ['interior',"exterior"].each do |i|
      result.push send(i).values
    end

    result.flatten.uniq

  end

  def unassigned
    if assigned.any?
      assets.where('id not in (?)', assigned.map {|i| i.to_i})
    else
      assets
    end
  end

  def remove_asset (attrs)
    places = []
    send(attrs[:attribute]).each do |k, v|
      v.delete_if { |i| i == attrs[:asset].to_s }
      places.push k
    end

    images = {}
    places.each do |place|
      collection = send(attrs[:attribute])[place]
        if collection.any?
          images[place] = [Asset.find(collection.first).url(:thumb), collection.size]
        else
          images[place] = ['https://s3-eu-west-1.amazonaws.com/rosfax/box.png', 0]
      end
    end

    save
    images
  end

  def car_mark_model=(markmodel)
    car['mark_model'] = markmodel
  end

  def expire_pages
    # ActionController::Base.expire_page(Rails.application.routes.url_helpers.edit_report_path(self))  
    # ActionController::Base.expire_page(Rails.application.routes.url_helpers.report_path(self))  
    # ActionController::Base.expire_page(Rails.application.routes.url_helpers.report_path(self, :format => 'pdf'))  
  end

  def can_manage?(current_user)
    return false unless current_user
    current_user.admin? or
    company == current_user.company or
    user == current_user
  end

  def generate_key
    self.access_key ||= rand(100000..1000000-1)
  end
end
