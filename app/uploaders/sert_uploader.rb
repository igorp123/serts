class SertUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include UploadHelper

  after :remove, :remove_empty_container_directory

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "uploads/#{model.class.to_s.underscore}s/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  #Process files as they are uploaded:
  process resize_to_fit: [1240, 1754]
  process convert: 'jpg'

   # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [150, 150]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png bmp tif tiff)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{file.basename}.jpg" if original_filename
  end
end
