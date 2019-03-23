local http = require 'http'

local luis = {
  url_template = "https://%s.api.cognitive.microsoft.com/luis/v2.0/apps/%s",
}

local required_keys = {
  app_id = true,
  region = true,
  key = true,
}

function luis:format_url()
  return string.format(self.url_template, self.region, self.app_id)
end

function luis:predict(utterance)
  local res, err = http.get(self.url, {
    headers = {Accept =  'application/json',},
    json = true,
    query = {
      ['subscription-key'] = self.key,
      q = utterance,
    }
  })
  if err then
    return nil, err
  end
  if res.status_code ~= 200 then
    return res.json, res.json.message or string.format("HTTP status %s", res.status_code)
  end
  return res.json
end

function luis:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  if not o.url then
    if not o.format_url then
      for k in pairs(required_keys) do
        assert(o[k], string.format("missing required key: %s", k))
      end
    end
    o.url = o:format_url()
  end
  return o
end

return luis
