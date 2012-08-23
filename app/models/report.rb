#encoding: utf-8
class Report < ActiveRecord::Base
  has_many :assets, :as => :attachable
  has_many :defects

  belongs_to :user
  belongs_to :model

  attr_accessor :car_mark_model, :counters

  validates_presence_of :model
  serialize :visual_interior, Hash
  serialize :windows, Hash

  serialize :exterior, Hash
  serialize :windows_lights, Hash
  serialize :exterior_parts, Hash
  serialize :powertrains, Hash
  serialize :electric_parts, Hash
  serialize :liquid_levels, Hash
  serialize :chasis, Hash
  serialize :completion, Hash
  serialize :testdrtive, Hash
  serialize :windows, Hash
  serialize :dumpers, Hash
  serialize :brakes, Hash
  serialize :wheels, Hash
  serialize :interior, Hash
  serialize :defects, Hash
  serialize :under_the_hood, Hash
  serialize :photo_others, Hash
  serialize :coating, Hash
  serialize :checklist, Hash
  serialize :testdrive, Hash
  serialize :car, Hash
  serialize :documents, Hash

  default_scope includes(:assets)

  EXTERIOR = %w( :front_left :front :front_right :left  :roof :right :rear_left :rear :rear_right)

  WHEEL = %w(:front_left_wheel :front_right_wheel :rear_right_wheel :rear_left_wheel :stepney)
  EXTERIOR_PARTS = %w(:hood :front_right_wing :right_front_door :rear_right_door :rear_right_wing :boot_lid :rear_left_wing :rear_left_door :front_left_door :front_left_wing_of_the :roof :front_bumper :skirt_front_bumper :rear_bumper :rear_apron :right_threshold :left_threshold)
  WINDOWS_LIGHTS = %w(front_left_headlight front_right_headlight rear_left_light rear_right_light head-on-window front_right_window rear_right_window rear_right_ventilator rear_window rear_left_ventilator rear_left_window front_left_window),
  INTERIOR_PARTS =%w(:front_left_seat :front_right_seat :back_sofa :third_row_seats :covering_left_front_door :covering_right_front_door :covering_left_rear_door :covering_rear_right_door :covering_trunk :ceiling :torpedo :central_console :armrest)
  POWERTRAINS = %w(knock flow tear wear),

  ELECTRONIC_PARTS = %w(low_lights distant_lights turning_lights foglights dimensions_lights brakes automatic_windows climate_control air_conditioning radio navigation control_lamps drive_down heated_seats ventilation_seat adjustment_heated_mirrors parktronic_rearview_camera sunroof seat_belts adjustable_steering_column janitors_rein_sensor ),
  LIQUID_LEVELS = %w( oil_in_engine oil_in_gearbox brake_fluid fluid_power_steering )
  CHASIS = %w(:full_drive_connection :air_suspension_all_levels :luft_knocking_in_steering_wheel :revolutions_of_twentieth :turns_gas_with_a_sharp)

  COMPLETION = %w(:spare_wheel :jack :tools :sealant)
  TESTDRIVE = %w(:disposed_steering :wheel_direct :luft_steering :heartbeat_vibration_when_accelerating :heartbeat_vibration_on_braking :knocks_squeak_on_uneven :switching_gears_all_up :switching_gears_all_down :acceleration_to_100_km_h_full_throttle :parking_brake :engine_noise :klaxon)

  COATING = %w(:hood :front_right_wing :right_front_door :rear_right_door :rear_right_wing :boot_lid :rear_left_wing :rear_left_door :front_left_door :front_left_wing_of_the :roof_coating)
  WINDOWS = %w( :head-on_window :front_right_window :rear_right_window :rear_right_ventilator :rear_window :rear_left_ventilator :the_rear_left_window :front_left_window )

  BRAKES = %w(:front_pads :front_brake_discs :rear_pads :rear_brake_discs)
  DUMPERS = %w(:right_front_bumper :left_front_bumper :right_rear_bumper :left_rear_bumper)

  INTERIOR = %w(:one :two :three :four :five :six :seven :eight :nine)


  DEFECTS_CATEGORIES ={
          :exterior => %w(hood front_right_wing right_front_door rear_right_door rear_right_wing boot_lid rear_left_wing rear_left_door front_left_door front_left_wing_of_the roof front_bumper skirt_front_bumper rear_bumper rear_apron right_threshold left_threshold),
          :interior => %w(front_left_seat front_right_seat back_sofa third_row_seats covering_left_front_door covering_right_front_door covering_left_rear_door covering_rear_right_door covering_trunk ceiling torpedo central_console armrest),
          :windows_and_lights => %w(front_left_headlight front_right_headlight rear_left_light rear_right_light head-on-window front_right_window rear_right_window rear_right_ventilator rear_window rear_left_ventilator rear_left_window front_left_window),
          :powertrains => %w(knock flow tear wear),
          :chasis => %w(full_drive_connection air_suspension_all_levels luft_knocking_in_steering_wheel revolutions_of_twentieth turns_gas_with_a_sharp),
          :wheels => %w(front_left_wheel front_right_wheel rear_right_wheel rear_left_wheel stepney),
          :electric => ELECTRONIC_PARTS,
          :liquids => LIQUID_LEVELS,
          :other => %w(teleporter hovering_drive plasma_gun gravizapa black_hole_generator tractor_beam higgs`s_boson arrow_in_the_knee),
          :video => %w()
  }

  ETHALON = {
    'checklist' => {"lights"=>{"headlights"=>"ок", "distant_lights"=>"ок", "fog_lights"=>"ок", "marker_lights"=>"ок", "turn_signal"=>"ок", "brake_lights"=>"0", "repeater"=>"1", "brake_lightsfog_lights"=>"ок"}, "electronic"=>{"glass_elevators"=>"ок", "central_locking"=>"ок", "seat_drive"=>"ок", "seat_heat"=>"ок", "mirrors"=>"ок", "hatch"=>"ок", "climat"=>"ок", "radio"=>"ок", "adjustable_wheel"=>"ок", "closer_rain_sensor"=>"ок", "parktronic"=>"ок", "seat_belt"=>"2"}, "liquids"=>{"engine"=>"OK", "transmission"=>"OK", "antifreeze"=>"OK", "power_steering"=>"OK", "brake"=>"OK"}, "completion"=>{"spare_wheel"=>"есть", "jack"=>"есть", "tools"=>"есть", "sealant"=>"есть", "compressor"=>"есть", "key_lock_gear"=>"есть", "theft_of_the_wheels"=>"есть", "keychain_alarm"=>"есть", "keychain_webasto"=>"есть", "key_to_the_locker"=>"есть"}, "documents"=>{"series"=>"1111333", "whom"=>"123", "issued"=>"17.08.2012", "document_validity"=>"0", "country"=>"Россия", "vin"=>"балабалабла", "owner_1_jur"=>"jur", "owner_2_jur"=>"fis", "owner_3_jur"=>"jur", "owner_4_jur"=>"fis", "owner_5_jur"=>"jur", "owner_6_jur"=>"fis", "start_owning_1"=>"01.08.2012", "end_owning_1"=>"02.08.2012", "start_owning_2"=>"03.08.2012", "end_owning_2"=>"04.08.2012", "start_owning_3"=>"05.08.2012", "end_owning_3"=>"06.08.2012", "start_owning_4"=>"07.08.2012", "end_owning_4"=>"08.08.2012", "start_owning_5"=>"09.08.2012", "end_owning_5"=>"10.08.2012", "start_owning_6"=>"11.08.2012", "end_owning_6"=>"12.08.2012"}, "coating"=>{"front_left_wing"=>"200", "front_left_door"=>"300", "rear_left_door"=>"200", "rear_left_wing"=>"300", "front"=>"400+", "roof"=>"400+", "rear"=>"400+", "front_right_wing"=>"100", "front_right_door"=>"200", "rear_right_door"=>"100", "rear_right_wing"=>"200"}},
    'testdrive' => {"suspension"=>{"divestment_steering"=>"ок", "steering_wheel_is_straight"=>"ок", "luft_knock_on_the_handlebars"=>"ок", "air_suspension"=>"ок", "heartbeat_vibration_on_acseletation"=>"ок", "creaks_knocks_on_the_irregularities"=>"ок", "heartbeat_vibration_on_braking"=>"ок"}, "engine"=>{"all_wheel_drive"=>"1", "routes"=>"1", "routes_during_heavy_gas"=>"1", "smoke_from_exhaust"=>"1", "engine_noise"=>"1", "shifting_down"=>"1", "shifting_up"=>"1", "parking_brake"=>"1", "sound_signal"=>"1"}}
  }

  def model_name
    "#{model.brand.name} #{model.name}"
  end

  def counters
    counters = {}

    tabs = {
      :car => {:car => 4},
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
    for key in DEFECTS_CATEGORIES.keys
      result[key] = []
      for value in DEFECTS_CATEGORIES[key]
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
      Asset.where(:id => send(attrs[:group]).values.flatten.map { |i| i.to_i }).map { |i| collection[i.id] = i.url(attrs[:size]) }
    else
      assets.map { |i| collection[i.id] = i.url(attrs[:size]) }
    end

    collection
  end

  def assigned
    result = []

    ["visual_interior", 'interior',"exterior", "windows_lights", "exterior_parts", "powertrains", "electric_parts", "liquid_levels", "chasis", "completion", "testdrtive", "windows", "dumpers", "brakes"].each do |i|
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

    # ["visual_interior", "interior", "exterior", "windows_lights", "exterior_parts", "powertrains", "electric_parts", "liquid_levels", "chasis", "completion", "testdrtive", "windows", "dumpers", "brakes"].each do |i|
    #   send(i).each { |k, v| v.delete_if { |i| i == asset.to_s } }
    # end
    save
    images
  end

  def car_mark_model=(markmodel)
    car['mark_model'] = markmodel
  end


end
