<%= include_partial 'talks/_common.lua' %>

local function query(namespace)
  local allkey = namespace .. ':all'
  local ids = redis.call('ZREVRANGEBYSCORE', allkey, '+inf', '-inf', 'WITHSCORES')
  local records = {}
  local i = 1

  while i < #ids do
    local id = ids[i]
    local score = ids[i + 1]
    records[id] = {}
    records[id]['score'] = score
    records[id]['data'] = find(namespace, id)
    i = i + 2
  end

  return records
end

return cmsgpack.pack(query(KEYS[1]))
