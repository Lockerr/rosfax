class Asset < ActiveRecord::Base
  has_attached_file :data, :styles => {
          :thumb => '100x68',
          :carousel => '900x600'
  }


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