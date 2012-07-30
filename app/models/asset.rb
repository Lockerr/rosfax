class Asset < ActiveRecord::Base
  has_attached_file :data, :styles => {
          :thumb => '100x68',
          :carousel => '900x600',
          },
           :storage => :s3,
           :s3_credentials => "#{Rails.root}/config/s3.yml",
           :path => ":attachment/:id/:style.:extension",
          :bucker => 'rosfax',
          :s3_domain_url =>  'http://rosfax.s3-website-eu-west-1.amazonaws.com/'




  process_in_background :data

  belongs_to :attachable, :polymorphic => true

  def url(*args)
    data.url(*args)
  end

  def name
    data_file_name
  end

  def content_type
    data_content_type
  end

  def file_size
    data_file_size
  end


end