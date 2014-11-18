require 'uri'

module Freee
  def client
    Base.new.client
  end
  module_function :client

  def encode_params(kwargs)
    if kwargs.length != 0
      '&' + URI.encode_www_form(kwargs)
    else
      ''
    end
  end
  module_function :encode_params

  def includes(file_path, search_path)
    Dir.glob(File.realpath(File.dirname(file_path)) + '/' + search_path).map do |f|
      require f if FileTest.file?(f)
    end
  end
  module_function :includes

  class Base

    @@client_id = nil
    @@secret_key = nil
    @@token = nil

    attr_reader :client

    def self.set_env
      @@client_id = ENV["FREEE_CLIENT_ID"]
      @@secret_key = ENV["FREEE_SECRET_KEY"]
      @@token = ENV["FREEE_APPLICATION_TOKEN"]
    end

    def self.config(client_id, secret_key, token)
      @@client_id = client_id.to_s
      @@secret_key = secret_key.to_s
      @@token = token.to_s
    end

    def initialize; end

    def client
      @client = OAuth2::AccessToken.new(create_client, @@token)
      self
    end

    def token
      @@token
    end

    def token=(token)
      @@token = token
    end

    def get(path, type=nil)
      response = @client.get(path).response.env[:body]
      return Freee::Response::Type.convert(response, type)
    end

    def post(path, type=nil, **kwargs)
      response = @client.post(path, { body: kwargs }).response.env[:body]
      return Freee::Response::Type.convert(response, type)
    end

    private
    def create_client
      OAuth2::Client.new(@@client_id, @@secret_key, OPTIONS) do |con|
        con.request :url_encoded
        con.request :json
        con.response :json, content_type: /\bjson$/
        con.adapter Faraday.default_adapter
      end
    end
  end
end
