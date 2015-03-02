class Iso8601ValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value, context)
      raw_value.to_time.localtime('+00:00').iso8601 if raw_value
    end

    def unformat(value, context)
      begin
        DateTime.iso8601(value) if value
      rescue ArgumentError
        value
      end
    end
  end
end