require "json"

class Location
  JSON.mapping({
    longitude: Int32,
    latitude:  Int32,
  })
end
