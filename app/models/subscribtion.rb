class Subscribtion < ActiveRecord::Base
  attr_accessible :by_email, :email_period, :filter, :user_id
  belongs_to :user
  
  # validates :year_to, :numericaly => {:greater_then => :year_from}
  
  serialize :filter, Hash

  before_save :process_filter

  def humanize_filter

  end

  def process_filter
    
    filter.delete_if{|k,v| v.empty?}

    if filter[:year_from].presence
      if filter[:year_to].presence
        filter[:year] = {:year => (filter[:year_from]..filter[:year_to])}
      else
        filter[:year] = "year > #{filter[:year_from]}"
      end
    elsif filter[:year_to].presence
      filter[:year] = (year < filter[:year_to])
    end

    filter.delete(:year_from)
    filter.delete(:year_to)

    if filter[:price_from].presence
      if filter[:price_to].presence
        filter[:price] = (filter[:price_from]..filter[:price_to])
      else
        filter[:price] = (filter[:price_from]..100000000)
      end
    elsif filter[:price_to].presence
      filter[:price] = (price < filter[:price_to])
    end
    filter[:brands] = {:name => filter[:brands]}
    filter.delete(:price_from)
    filter.delete(:price_to)
    filter.delete(:country)




  end

end
