require_relative '../Client'

module CMX
module API

  module Location
    def self.get_count
      uri     = "/api/location/v2/clients/count"
      headers = def_headers
      CMX::Client.get_it!(uri, headers)
    end
    
    def self.get_clients
      uri     = "/api/location/v2/clients"
      headers = def_headers
      CMX::Client.get_it!(uri, headers)
    end

    def self.def_headers
      headers = {
        "Authorization": "Basic ",
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
    end

  end

end
end