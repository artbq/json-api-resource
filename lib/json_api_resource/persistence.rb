require "active_support/all"
require "typhoeus"

module JsonApiResource
  module Persistence

    module ClassMethods

      private

      def newp(data={})
        model = new(data)
        model.send("persisted=", true)
        model
      end
    end

    def self.included(m)
      m.extend(ClassMethods)
    end


    def persisted?
      @persisted
    end

    def save
      return false unless valid?

      if persisted?
        req = Typhoeus::Request.new(
            "#{endpoint}/#{id}",
            method: :put,
            headers: {"Content-Type" => "application/x-www-form-urlencoded"},
            body: {params_key => attributes})
        success_code = 200
      else
        req = Typhoeus::Request.new(
            endpoint,
            method: :post,
            headers: {"Content-Type" => "application/x-www-form-urlencoded"},
            body: {params_key => attributes})
        success_code = 201
      end

      req.on_complete do |res|
        case res.code
        when success_code
          from_json(res.body)
          self.persisted = true
          return true
        when 422
          return false
        else
          return false
        end
      end

      req.run
    end

    def save!
      # TODO: Raise exception
      save
    end

    private

    def persisted=(v)
      @persisted = v
    end

    def params_key
      self.class.to_s.underscore
    end
  end
end

