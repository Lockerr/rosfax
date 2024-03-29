#encoding: utf-8
class HomeController < ApplicationController
  def partners
  	
    redirect_to reports_path if Rails.root.to_s.split('/')[2] == 'user'
    @models = {}
    Model.includes(:brand).select(['models.name', 'brands.name', 'models.id']).map {|y| @models[[y.brand.name, y.name].join(' ')] = y.id}.sort

  end

  def index
    redirect_to reports_path if Rails.root.to_s.split('/')[2] == 'user'
    @reports = Report.where('assets_count > 0').last(3)
    render :layout => false
  end

  def how_it_works
    render layout: false
  end

  def for_buyers
    render layout: false
  end

  def for_sellers
    render layout: false
  end

  def demo
  	@report = Report.find_by_id(19)
    @report ||= Report.find(46)
 	render :layout => 'report_show'
  end


end
