class Point < ActiveRecord::Base
  attr_accessible :condition, :object, :place, :report_id, :section, :state, :images, :asset_id, :description

  belongs_to :report
  has_many :assets, :as => :attachable

  scope :elements, where(:object => :element)
  scope :defects, where(:object => :defect)
  scope :checks, where(:object => :check)

  validates_presence_of :object
  serialize :images, Array

  def asset_id=(id)
    (images.push id).uniq!
  end

  def image
    Asset.find(images.last.to_i) if images.any?
  end

  def remove!(image_id)
    images.delete(image_id.to_s)
    save
  end

end
