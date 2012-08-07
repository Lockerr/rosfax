class Asset < ActiveRecord::Base
  has_attached_file :data,
          :styles => {:thumb => '100x68', :carousel => '900x600'},
          :default_url => "asset_path('loading.gif')",
          :storage => :s3,
          :s3_credentials => { :access_key_id => 'AKIAJVTSIEA4Y2WZG5TQ', :secret_access_key => '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' },
          :bucket => 'rosfax',
          :path => ":attachment/:id/:style.:extension",
          :s3_host_name =>  's3-eu-west-1.amazonaws.com',
          :default_url => "/images/normal/missing.png"


  process_in_background :data

  belongs_to :attachable, :polymorphic => true
  scope :processed, where(:data_processing => false)

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