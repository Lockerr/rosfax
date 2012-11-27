class Link < ActiveRecord::Base
  attr_accessible :report_id, :url, :site
  belongs_to :report

  validates_format_of :url, :with => URI::regexp(%w(http https))

end
