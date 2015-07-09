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
            {body: {params_key => attributes}}.merge(update_params))
        success_code = 200
      else
        req = Typhoeus::Request.new(
            endpoint,
            {body: {params_key => attributes}}.merge(create_params))
        success_code = 201
      end

      req.on_complete do |res|
        case res.code
        when success_code
          from_json(res.body)
          self.persisted = true
          return true
        when 422
          add_errors(JSON.parse(res.body)["errors"])
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

    def destroy
      req = Typhoeus::Request.new("#{endpoint}/#{id}", method: :delete)
      req.on_complete do |res|
        case res.code
        when 204
          self.persisted = false
          self
        else
          false
        end
      end
      req.run
    end

    private

    def persisted=(v)
      @persisted = v
    end

    def params_key
      self.class.to_s.underscore
    end

    def update_params
      {
        method: :put,
        headers: {"Content-Type" => 'application/x-www-form-urlencoded'},
      }
    end

    def create_params
      {
        method: :post,
        headers: {"Content-Type" => 'application/x-www-form-urlencoded'}
      }
    end

    def add_errors(data)
      data.each do |attr, errs|
        errs.each do |err|
          errors.add(attr, err)
        end
      end
    end
  end
end

