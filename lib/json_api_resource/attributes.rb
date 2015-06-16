require "active_support/all"

module JsonApiResource
  module Attributes

    module ClassMethods

      def def_attributes(*attrs)
        @attributes = attrs
        attrs.each do |attr|
          attr_accessor(attr)
        end
      end

      def attributes
        @attributes
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

