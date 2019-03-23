local http = require 'http'

local owm = {
  units = 'metric',
  url = 'https://api.openweathermap.org/data/2.5/weather',
}

function owm:by_city(location)
  local res, err = http.get(self.url, {
    headers = {Accept =  'application/json',},
    json = true,
    query = {
      APPID = self.key,
      units = self.units,
      q = location,
    }
  })
  if err then
    return nil, err
  end
  if res.status_code ~= '200' then
    return res.json, res.json.message or string.format("HTTP status %s", res.status_code)
  end
  return res.json
end

function owm:new (o)
  o = o or {}
  assert(o.key, "missing required key: key")
  setmetatable(o, self)
  self.__index = self
  return o
end

return owm
