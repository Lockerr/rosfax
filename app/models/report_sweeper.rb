class ReportSweeper < ActionController::Caching::Sweeper
  observe Report, Point

  def after_update(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private

  def expire_cache_for(record)
    object = record.is_a?(Report) ? record : record.report

    expire_action edit_report_url(object)
    expire_action report_url(object)
    expire_action report_url(object, :format => :pdf)
    expire_action report_url(object, :format => :pdf, :access_key => object.access_key)
    expire_action report_url(object, :access_key => object.access_key)
  end
end