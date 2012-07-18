class Report < ActiveRecord::Base
  has_many :assets, :as => :attachable
  serialize :visual_interior, Hash
  serialize :windows, Hash

  PLACEMENTS = %w( :front_left :front :front_right :right :rear_right :rear :rear_left :left :roof )
  WHEEL = %w(:front_left_wheel :front_right_wheel :rear_right_wheel :rear_left_wheel :stepney)
  EXTERIOR_PARTS = %w(:hood :front_right_wing :right_front_door :rear_right_door :rear_right_wing :boot_lid :rear_left_wing :rear_left_door :front_left_door :front_left_wing_of_the :roof :front_bumper :skirt_front_bumper :rear_bumper :rear_apron :right_threshold :left_threshold)
  WINDOWS_LIGHTS = %w(:front_left_headlight :front_right_headlight :rear_left_light :rear_right_light :head-on-window :front_right_window :rear_right_window :rear_right_ventilator :rear_window :rear_left_ventilator :rear_left_window :front_left_window)
  INTERIOR_PARTS =%w(:front_left_seat :front_right_seat :back_sofa :third_row_seats :covering_left_front_door :covering_right_front_door :covering_left_rear_door :covering_rear_right_door :covering_trunk :ceiling :torpedo :central_console :armrest)
  POWERTRAINS = %w(:knock :flow :tear :wear)

  ELECTRONIC_PARTS = %w( :low_lights :distant_lights :turning_lights :foglights :dimensions_lights :brakes :automatic_windows :climate_control :air_conditioning :radio :navigation :control_lamps :drive_down :heated_seats :ventilation_seat :adjustment_heated_mirrors :parktronic_rearview_camera :sunroof :seat_belts :adjustable_steering_column :janitors_rein_sensor )
  LIQUID_LEVELS = %w( :oil_in_engine :oil_in_gearbox :brake_fluid :fluid_power_steering )
  CHASIS = %w(:full_drive_connection :air_suspension_all_levels :luft_knocking_in_steering_wheel :revolutions_of_twentieth :turns_gas_with_a_sharp)

  COMPLETION = %w(:spare_wheel :jack :tools :sealant)
  TESTDRIVE = %w(:disposed_steering :wheel_direct :luft_steering :heartbeat_vibration_when_accelerating :heartbeat_vibration_on_braking :knocks_squeak_on_uneven :switching_gears_all_up :switching_gears_all_down :acceleration_to_100_km_h_full_throttle :parking_brake :engine_noise :klaxon)

  COATING = %w(:hood :front_right_wing :right_front_door :rear_right_door :rear_right_wing :boot_lid :rear_left_wing :rear_left_door :front_left_door :front_left_wing_of_the :roof_coating)
  WINDOWS = %w( :head-on_window :front_right_window :rear_right_window :rear_right_ventilator :rear_window :rear_left_ventilator :the_rear_left_window :front_left_window )

  BRAKES = %w(:front_pads :front_brake_discs :rear_pads :rear_brake_discs)
  DUMPERS = %w(:right_front_bumper :left_front_bumper :right_rear_bumper :right_rear_bumper)



  def inventory
    result = {}
    PLACEMENTS.each do |p|
      result[p] = visual_interior[p]

    end
    result
  end

  def image(place, index)
    if visual_interior[place]
      if visual_interior[place][index]
        Asset.find(visual_interior[place][index]).url(:thumb)
      end
    end
  end


  def place(position, asset, index)
    visual_interior[position] ||= []
    visual_interior[position][index.to_i] = asset

    save


  end

end
