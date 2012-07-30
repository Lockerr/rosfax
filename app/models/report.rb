class Report < ActiveRecord::Base
  has_many :assets, :as => :attachable
  has_many :defects

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
        result[key].push :k => value, :v => I18n.t(value)
      end
    end
    result
  end

  def place(attrs= {})
    send(attrs[:attribute])[attrs[:position]] ||= []
    send(attrs[:attribute])[attrs[:position]].push attrs[:asset]

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
          images[place] = [asset_path('box.png'), 0]
      end
    end

    # ["visual_interior", "interior", "exterior", "windows_lights", "exterior_parts", "powertrains", "electric_parts", "liquid_levels", "chasis", "completion", "testdrtive", "windows", "dumpers", "brakes"].each do |i|
    #   send(i).each { |k, v| v.delete_if { |i| i == asset.to_s } }
    # end
    save
    images
  end


end
