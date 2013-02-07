class StaticController < ApplicationController
  def google_validation
    render :text =>  'google-site-verification: google5bf74eb79251ba45.html'
  end

  def yandex_validation
    render :text => 'Verification: 4ed32e0d73358fa4'
  end
end
