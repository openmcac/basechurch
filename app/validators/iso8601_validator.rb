class Iso8601Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      DateTime.iso8601(value)
    rescue ArgumentError
      record.errors.add(attribute, 'must be in ISO8601 format')
    end
  end
end
