class Asset < ActiveRecord::Base

  FTP = Rails.root.join('tmp')

  has_attached_file :data,
          :styles => {
            :thumb => {:geometry => '100x68>', :format => :jpg, :pre_convert_options => "-auto-orient"},
            :carousel => {:geometry => '900x600>', :format => :jpg, :pre_convert_options => "-auto-orient"}
          },
          :default_url => "/assets/loading.gif",
          :storage => :s3,
          :s3_credentials => { :access_key_id => 'AKIAJVTSIEA4Y2WZG5TQ', :secret_access_key => '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' },
          :bucket => 'rosfax',
          :path => ":attachment/:id/:style.:extension",
          :s3_host_name =>  's3-eu-west-1.amazonaws.com'



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

  def self.process_ftp

  end

end