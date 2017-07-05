class BasechurchResourceSerializer < JSONAPI::ResourceSerializer
  private

  def formatted_module_path_from_klass(klass)
    formatted_module_path = super(klass)
    return "" if formatted_module_path.blank?
    "api/v1/"
  end
end
