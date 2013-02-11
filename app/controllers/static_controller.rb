class StaticController < ApplicationController
  newrelic_ignore

  def google_validation
    render :text =>  'google-site-verification: google5bf74eb79251ba45.html'
  end

  def yandex_validation
    render :text => "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'></head><body>Verification: 4ed32e0d73358fa4</body></html>".html_safe
  end
end
