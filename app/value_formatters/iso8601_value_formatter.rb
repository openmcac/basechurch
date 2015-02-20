class Iso8601ValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value, context)
      raw_value.iso8601
    end

    def unformat(value, context)
      DateTime.iso8601(value)
    end
  end
end
