class StaticController < ApplicationController
  def google_validation
    render :text =>  'google-site-verification: google5bf74eb79251ba45.html'
  end
end
