#######  Client.rb
require_relative '../APIBase'
require 'openssl'

module CMX
class Client < APIBase
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    def post!
      Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do | http |
        @request =  Net::HTTP::Post.new(@uri)
        add_headers
        @request.body = @body.to_json
        @response = http.request @request
        @results  = JSON.parse(@response.body)
      end
    end

    def get!
      Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do | http |
        @request = Net::HTTP::Get.new(@uri)
        add_headers
        @response = http.request @request 
        @results  = @response.body
      end 
    end

    def post_to_file!(file)
      Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do | http |
        @request =  Net::HTTP::Post.new(@uri)
        add_headers
        @request.body = @body.to_json
        @response = http.request @request
        File.open(file, 'wb') { |file| file.write(@response.body) }
        @results = {
          "status": @response.code
        }
      end
    end

    def self.post_it_to_file!(uri, headers, body, file_name)
        client = Client.new({
            uri: URI(host_address + uri),
            headers: headers,
            body: body
        })
        client.post_to_file!(file_name)
        if client.response.code.to_s != "200"
            raise "ERROR: #{client.response.code}"
        end
        client.results
    end
    
    def self.post_it!(uri, headers, body)
        client = Client.new({
            uri: URI(host_address + uri),
            headers: headers,
            body: body
        })
        client.post!
        if client.response.code.to_s != "200"
            raise "ERROR: #{client.response.code}"
        end
        client.results
    end

    def self.get_it!(uri, headers)
        client = Client.new({
            uri: URI(host_address+uri),
            headers: headers
        })
        client.get!
        if client.response.code.to_s != "200"
            puts client.response
            raise "ERROR: #{client.response.code}"
        end
        client.results
    end 
    
    def self.host_address
        "https://63.231.220.33"
    end 

end
end