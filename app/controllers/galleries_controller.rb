class GalleriesController < ApplicationController
  def rest
    render :json => (0...50).map{ (('a' .. 'z').to_a + (0..9).to_a)[rand(36)] }.join
  end

  def test
    render :json => (0...50).map{ (('a' .. 'z').to_a + (0..9).to_a)[rand(36)] }.join
  end

end




