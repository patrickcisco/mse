#######  APIBase.rb

require 'net/http'
require 'json'

class APIBase
    attr_reader :uri, :body, :results, :response
    def initialize(args={})
        @uri     = args[:uri]     || args["uri"]
        @body    = args[:body]    || args["body"]
        @headers = args[:headers] || args["headers"]
        @results
        @request
        @response 
    end

    def post!
        raise NotImplementedError
    end
    
    def get!
        raise NotImplementedError
    end

    private
    def add_headers
        unless @headers.nil?
            @headers.each do |k, v|
                @request.add_field(k, v)
            end
        end
    end
end