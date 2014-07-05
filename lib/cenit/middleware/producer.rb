require 'json'
require 'openssl'
require 'bunny'

module Cenit
  module Middleware
    class Producer

      def self.process(object, path, conn_id)
        puts "*************** object #{object.inspect}"
        webhook = Setup::Webhook.where(path: path).first
        if webhook
          endpoints = webhook.connections.select{|c| c.id != conn_id}
          endpoints.each do |endpoint|
            message = {
              :object => object,
              :url => "#{endpoint.url}/#{webhook.path}",
              :store => endpoint.store,
              :token => endpoint.token
            }.to_json
            send_to_rabbitmq(message)
          end
        end
      end

      def self.send_to_rabbitmq(message)
        conn = Bunny.new(:automatically_recover => false)
        conn.start

        ch = conn.create_channel
        q = ch.queue('send.to.website')

        ch.default_exchange.publish(message, :routing_key => q.name)
        conn.close
      end

    end
  end
end
