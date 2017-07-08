module HasAttachment
  extend ActiveSupport::Concern

  module ClassMethods
    def has_attachment(field)
      define_url_accessor(field)
      define_orphan_destroyer(field)
      set_field_class_methods(field)
    end

    private

    def define_url_accessor(field)
      define_url_reader(field)
      define_url_writer(field)
    end

    def define_url_reader(field)
      define_method("#{field}_url") do
        send(field.to_sym).try(:url)
      end
    end

    def define_url_writer(field)
      define_method("#{field}_url=") do |url|
        (send(field.to_sym) || send("build_#{field}", key: field)).url = url
      end
    end

    def define_orphan_destroyer(field)
      define_method("destroy_orphaned_#{field}") do
        attachable = send(field.to_sym)
        attachable.mark_for_destruction if attachable && attachable.url.blank?
      end
    end

    def set_field_class_methods(field)
      has_one field.to_sym,
              -> { where(key: field) },
              as: :attachable,
              class_name: "Attachment",
              autosave: true

      validates_associated field.to_sym

      before_save "destroy_orphaned_#{field}".to_sym
    end
  end
end

ActiveRecord::Base.send(:include, HasAttachment)
