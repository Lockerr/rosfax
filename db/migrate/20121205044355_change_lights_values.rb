#encoding: UTF-8
class ChangeLightsValues < ActiveRecord::Migration
  def up
    Point.where(:object => :checklist, :section => :lights).where(:condition => %w(левая правая)).update_all :condition => 'ОДНА'
    Point.where(:object => :checklist, :section => :lights).where(:condition => %w(ок)).update_all :condition => 'ОК'
    Point.where(:object => :checklist, :section => :lights).where(:condition => %w(обе)).update_all :condition => 'ОБЕ'
  end

  
end
