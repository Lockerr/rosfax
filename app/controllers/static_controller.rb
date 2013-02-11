class StaticController < ApplicationController
  newrelic_ignore
  def google_validation
    render :text =>  'google-site-verification: google5bf74eb79251ba45.html'
  end

  def yandex_validation
    render :layout => false
  end
end
