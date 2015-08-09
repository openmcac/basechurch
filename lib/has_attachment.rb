module HasAttachment
  extend ActiveSupport::Concern

  module ClassMethods
    def has_attachment(field, options)
      field = field.to_sym

      define_method(field) do
        Basechurch::Attachment.find_by(element_id: id,
                                       element_type: self.class.name,
                                       element_key: field)
      end

      define_method("build_#{field}") do
        Basechurch::Attachment.new(element_id: id,
                                   element_type: self.class.name,
                                   element_key: field)
      end

      define_method("save_#{field}") do
        url = send("#{field}_url")
        return unless url
        (send(field) || send("build_#{field}")).update_attribute(:url, url)
      end

      attr_accessor "#{field}_url"
      validates "#{field}_url".to_sym, url: options
      after_save "save_#{field}"
    end
  end
end

ActiveRecord::Base.send(:include, HasAttachment)
