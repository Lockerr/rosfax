class HomeController < ApplicationController
  def partners
    redirect_to reports_path if Rails.root.to_s.split('/')[2] == 'user'
    @models = {}
    Model.includes(:brand).select(['models.name', 'brands.name', 'models.id']).map {|y| @models[[y.brand.name, y.name].join(' ')] = y.id}.sort

  end
  def index  	
  end

end
