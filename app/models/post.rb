class Post < ApplicationRecord
  after_save :save_photo
  validates_presence_of :title, :extension
  belongs_to :user

  def photo=(file_data)
    unless file_data.blank?
      @file_data = file_data
      self.extension = file_data.original_filename.split('.').last.downcase
    end
  end

  def photos
    File.join Rails.root, 'public', 'photo_store'
  end

  def photo_path
    "/photo_store/#{id}.#{extension}"
  end

  def photo_filename
    File.join photos, "#{id}.#{extension}"
  end

  def has_photo?
    File.exists? photo_filename
  end

  private
  def save_photo
    if @file_data
      FileUtils.mkdir_p photos
      File.open(photo_filename, 'wb') do |f|
        f.write(@file_data.read)
      end
      @file_data = nil
    end
  end

end
