module HasAttachment
  extend ActiveSupport::Concern

  module ClassMethods
    def has_attachment(field, options)
      define_field_methods(field)
      set_field_class_methods(field, options)
    end

    private

    def define_field_methods(field)
      define_accessor(field)
      define_build(field)
      define_save(field)
    end

    def define_accessor(field)
      define_method(field) do
        Basechurch::Attachment.find_by(element_id: id,
                                       element_type: self.class.name,
                                       element_key: field)
      end
    end

    def define_build(field)
      define_method("build_#{field}") do
        Basechurch::Attachment.new(element_id: id,
                                   element_type: self.class.name,
                                   element_key: field)
      end
    end

    def define_save(field)
      define_method("save_#{field}") do
        url = send("#{field}_url")
        return unless url
        (send(field) || send("build_#{field}")).update_attribute(:url, url)
      end
    end

    def set_field_class_methods(field, options)
      attr_accessor "#{field}_url".to_sym
      validates "#{field}_url".to_sym, url: options
      after_save "save_#{field}".to_sym
    end
  end
end

ActiveRecord::Base.send(:include, HasAttachment)
