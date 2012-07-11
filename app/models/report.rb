class Report < ActiveRecord::Base
  has_many :assets, :as => :attachable
  serialize :visual_interior, Hash
  PLACEMENTS = %w( :front_left :front :front_right :right :rear_right :rear :rear_left :left :roof )
  CATEGORIES = %w(  )

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
