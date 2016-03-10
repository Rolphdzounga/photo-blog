class Image < ActiveRecord::Base
  belongs_to :user
  #monte la class PicUp sur le champ :picture
  #liaison PicUp - :picture
  mount_uploader :picture, PictureUploader
  validate :picture_size

  private
  	def picture_size
  		if picture.size > 5.megabytes
  			error.add(:picture,
  				"Doit avoir une taille inferieur à 5M")
  		end
  	end
end
