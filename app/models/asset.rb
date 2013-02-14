class Asset < ActiveRecord::Base

  FTP = Rails.root.join('tmp')
  if Rails.env == 'production'
    Rails.logger.info '**************************** MATCH PRODUCTION'
    if Rails.root.to_s.match('/home/user/') or Rails.root.to_s.match('/home/anton/work/tradein')
      Rails.logger.info ' *************************** MATCH RAILS_ROOT'
      has_attached_file :data,
        :styles => {
          :thumb => {:geometry => '100x68>', :format => :jpg, :pre_convert_options => "-auto-orient"},
          :carousel => {:geometry => '900x600>', :format => :jpg, :pre_convert_options => "-auto-orient"},
          :magnify => {:geometry => '1800x1200', :format => :jpg, :pre_convert_options => "-auto-orient"}
          },
          :default_url => "/assets/loading.gif"
    else
      Rails.logger.info '########################## SET S3'
      has_attached_file :data,
        :styles => {
          :thumb => {:geometry => '100x68>', :format => :jpg, :pre_convert_options => "-auto-orient"},
          :carousel => {:geometry => '900x600>', :format => :jpg, :pre_convert_options => "-auto-orient"},
          :magnify => {:geometry => '1800x1200', :format => :jpg, :pre_convert_options => "-auto-orient"}
        },
        :default_url => "/assets/loading.gif",
        :storage => :s3,
        :s3_credentials => { :access_key_id => 'AKIAJVTSIEA4Y2WZG5TQ', :secret_access_key => '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' },
        :bucket => 'rosfax',
        :path => ":attachment/:id/:style.:extension",
        :s3_host_name =>  's3-eu-west-1.amazonaws.com'
      
    end

  else
    Rails.logger.info '########################## SET LOCAL'
    has_attached_file :data,
      :styles => {
        :thumb => {:geometry => '100x68>', :format => :jpg, :pre_convert_options => "-auto-orient"},
        :carousel => {:geometry => '900x600>', :format => :jpg, :pre_convert_options => "-auto-orient"},
        :magnify => {:geometry => '1800x1200', :format => :jpg, :pre_convert_options => "-auto-orient"}
        },
        :default_url => "/assets/loading.gif"
  end

  process_in_background :data




  belongs_to :attachable, :polymorphic => true, counter_cache: true

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