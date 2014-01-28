require 'yaml'

module Lightspeed
  class Client
    include HTTParty

    headers "Content-Type"=> 'application/xml'
    headers 'Accept-Encoding'  => "deflate, gzip"
    format :xml

    CONFIG_KEYS = [:user_agent, :app_id, :cookie, :endpoint, :username, :password, :ssl_verify]

    class << self
      attr_accessor :ssl_verify

      def config_from_yaml file, env = nil
        opts = YAML.load(File.open file)

        config = if opts.keys.include? env
          opts[env.to_s] || opts[env.to_sym]
        else
          opts
        end

        config_from_hash config
      end

      def config_from_hash opts
        CONFIG_KEYS.each do |key|
          value = opts[key] || opts[key.to_s]
          instance_variable_set(:"@#{key}", value) if !value.nil? and value != ''
        end

        base_uri "#{@endpoint}/api/"
        basic_auth @username, @password
        http_proxy 'localhost', 8888

        headers 'User-Agent'       => @user_agent
        headers 'X-PAPPID'         => @app_id
        headers 'Cookie'           => @cookie if @cookie

        opts
      end

      def ensure_credentials
        raise "Lightspeed credentials not set" unless @endpoint and @username and @password
      end

      def ensure_ssl_verify opts
        opts[:verify] = false if (@ssl_verify == false)
      end

      def perform_request verb, path, opts = {}, &block
        ensure_credentials
        ensure_ssl_verify opts

        super
      end

      def lock path, options = {}, &block
        perform_request Net::HTTP::Lock, path, options, &block      
      end

      def unlock path, options = {}, &block
        perform_request Net::HTTP::Unlock, path, options, &block      
      end 

      def logout
        post '/sessions/current/logout/'
      end
    end
  end
end
