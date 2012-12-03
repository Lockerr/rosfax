class Point < ActiveRecord::Base
  attr_accessible :condition, :object, :place, :report_id, :section, :state, :images, :asset_id, :description

  belongs_to :report
  has_many :assets, :as => :attachable

  scope :elements, where(:object => :elements)
  scope :defects, where(:object => :defect)
  scope :checks, where(:object => :check)
  scope :filled, where('`condition` is not null or `state` is not null or `description` is not null')
  
  validates_presence_of :object
  serialize :images, Array

 

end
