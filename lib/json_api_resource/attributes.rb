require "active_support/all"

module JsonApiResource
  module Attributes

    module ClassMethods
      cattr_accessor :attributes

      def def_attributes(*attrs)
        self.attributes = attrs
        attrs.each do |attr|
          attr_accessor(attr)
        end
      end
    end

    def self.included(m)
      m.extend ClassMethods
    end


    def attributes
      ks = self.class.attributes || []
      ks.inject(ActiveSupport::HashWithIndifferentAccess.new) do |r, k|
        r[k] = send(k)
        r
      end
    end

    def attributes=(data={})
      data.each do |k, v|
        try("#{k}=", v)
      end
    end
  end
end

