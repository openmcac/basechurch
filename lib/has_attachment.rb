module HasAttachment
  extend ActiveSupport::Concern

  module ClassMethods
    def has_attachment(field)
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
    end
  end
end

ActiveRecord::Base.send(:include, HasAttachment)
