class RandomFilename
  attr_reader :file_type

  def initialize(file_type)
    @file_type = file_type
  end

  def generate
    "#{SecureRandom.uuid}.#{file_extension(file_type)}"
  end

  private

  def file_extension(file_type)
    case file_type
    when "image/jpeg", "image/jpg"
      "jpg"
    end
  end
end
