class Subscription < ActiveRecord::Base

  attr_accessible :by_email, :email_period, :filter, :user_id
  belongs_to :user
   
  serialize :filter, Hash

  before_save :process_filter

  def process_filter
    
    filter.delete_if{|k,v| v.empty?}

    if filter[:year_from].presence
      if filter[:year_to].presence
        filter[:year] = [(filter[:year_from].to_i..filter[:year_to].to_i), nil]
      else
        filter[:year] = [(filter[:year_from].to_i..Date.today.year.to_i), nil]
      end
    elsif filter[:year_to].presence
      filter[:year] = [(20.years.ago.year .. filter[:year_to]), nil]
    end

    filter.delete(:year_from)
    filter.delete(:year_to)

    if filter[:price_from].presence
      if filter[:price_to].presence
        filter[:price] = [(filter[:price_from].to_i..filter[:price_to].to_i), nil]
      else
        filter[:price] = [(filter[:price_from].to_i..100000000), nil]
      end
    elsif filter[:price_to].presence
      filter[:price] = (price < filter[:price_to])
    end
    filter[:brands] = {:name => filter[:brands]} if filter[:brands].presence
    filter[:countries] = {:name => filter[:country]} if filter[:country].presence

    filter.delete(:price_from)
    filter.delete(:price_to)
    filter.delete(:country)




  end

end
