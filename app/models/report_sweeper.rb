class ReportSweeper < ActionController::Caching::Sweeper
  observe Report, Point, Asset

  def after_update(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private

  def expire_cache_for(record)
    object = record if record.is_a?(Report)
    object = record.report if record.is_a?(Point)
    if record.is_a?(Asset)
      if record.attachable .is_a?(Report)
        object = record.attachable
      end
    end

    return true unless object



    expire_action edit_report_url(object)
    expire_action report_url(object)
    expire_action report_url(object, :format => :pdf)
    expire_action report_url(object, :format => :pdf, :access_key => object.access_key)
    expire_action report_url(object, :access_key => object.access_key)
  end
end