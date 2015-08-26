module HasAttachment
  extend ActiveSupport::Concern

  module ClassMethods
    def has_attachment(field, options)
      define_field_methods(field)
      set_field_class_methods(field, options)
    end

    private

    def define_field_methods(field)
      define_url_accessor(field)
    end

    def define_url_accessor(field)
      define_method("#{field}_url") do
        send(field.to_sym).try(:url)
      end

      define_method("#{field}_url=") do |url|
        (send(field.to_sym) || send("build_#{field}", key: field)).url = url
      end
    end

    def set_field_class_methods(field, options)
      has_one field.to_sym,
              -> { where(key: field) },
              as: :attachable,
              class_name: "Basechurch::Attachment"
      validates_associated field.to_sym
    end
  end
end

ActiveRecord::Base.send(:include, HasAttachment)
