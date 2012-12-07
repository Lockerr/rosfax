#encoding: utf-8
class LightsValues < ActiveRecord::Migration
  def up
    Point.where(:condition => 'ОДНА').update_all :condition => 1
    Point.where(:condition => 'ОБЕ').update_all :condition => 2
  end  
end
