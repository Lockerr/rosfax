class Defect < ActiveRecord::Base
  belongs_to :report

  has_many :assets, :as => :attachable

  serialize :images, Array

  def image(attrs={})

    if images.any?
        {images[-1] => Asset.find(images[-1].to_i).url(attrs[:size]|| :thumb)}
      end
  end

end
