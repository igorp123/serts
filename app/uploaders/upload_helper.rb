module UploadHelper
  def remove_empty_container_directory
    path = "#{Rails.root}/public/#{store_dir}"
    Dir.rmdir(path)
    rescue
      true
    end
  end
