class Image < ActiveRecord::Base
  belongs_to :user
  attr_accessible :caption, :description, :asset
  has_attached_file :asset, styles: {
    large: "800x800>", medium: "300x200>", small: "260x180>", thumb: "80x80#"
  }
  # after_save :save_image_dimensions

  def to_s
    caption? ? caption : "Picture"
  end

#  def save_image_dimensions
#   unless @geometry_saved
#    geo = nil
#   begin
#	    	geo = Paperclip::Geometry.from_file(asset.path(:large))
#     rescue
#      geo = nil
#   end
#   self.image_width = geo.width
#   self.image_height = geo.height
#   @geometry_saved
#	  self.save		  
#	  end
#  end

#  def calcHeightForWidth300
#   geo = PaperClip::Geometry.from_file(asset.to_file(:original))
#    ratio = geo.width / geo.height
#    300 / ratio
#  end

end

