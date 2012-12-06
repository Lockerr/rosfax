class Point < ActiveRecord::Base
  attr_accessible :condition, :object, :place, :report_id, :section, :state, :images, :asset_id, :description

  belongs_to :report
  has_many :assets, :as => :attachable

  scope :elements, where(:object => :elements)
  scope :defects, where(:object => :defect)
  scope :checks, where(:object => :check)
  scope :filled, where('`condition` is not null or `state` is not null')
  
  validates_presence_of :object
  serialize :images, Array

  def alert_class
    if Report::NORMAL_CONDITION.include? condition
      'alert-success'
    elsif  Report::BAD_CONDITION.include? condition
      'alert-error'
    else
      'alert-normal'
    end      
  end

  def point_color
    if Report::NORMAL_CONDITION.include? condition
      'green'
    elsif  Report::BAD_CONDITION.include? condition
      'red'
    else
      'normal'
    end      
  end

  def self.normalize
    Point.where(:state => '').update_all :state => nil
    Point.where(:condition => '').update_all :condition => nil

  end

end
