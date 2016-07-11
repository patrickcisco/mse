require_relative 'CMX/API/Location'
require 'json'

res      = CMX::API::Location.get_clients
aps      = {}
result   = JSON.parse(res)

result.each do |client|
  if not aps[client["apMacAddress"]] and client["apMacAddress"] != ""
    address = client["apMacAddress"]
    aps[address] = {
      "connectedDeviceCount": 1,
      "connectedDevices": [{
        "ip": client["ipAddress"],
        "ssId": client["ssId"],
        "mapCoordinate": client["MapCoordinate"]
      }]
    }
  end
  if aps[client["apMacAddress"]] and client["apMacAddress"] != ""
    address = client["apMacAddress"]
    aps[address][:connectedDeviceCount] += 1
    aps[address][:connectedDevices] << {
      "ip": client["ipAddress"],
      "ssId": client["ssId"],
      "mapCoordinate": client["mapCoordinate"]
    }
  end
end
sorted_hash = aps.sort_by { |k, v| 
  aps[k][:connectedDeviceCount]
}.reverse!
first_ten   = sorted_hash.first(10)
sorted_hash = {
  "results": first_ten
}
f = open("test.txt", "w")
f.write(JSON.pretty_generate(sorted_hash))
