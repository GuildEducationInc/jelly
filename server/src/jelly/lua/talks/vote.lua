<%= include_partial 'talks/_common.lua' %>

local function vote(namespace, id, incr, voter)
  local allkey = namespace .. ':all'
  local recordkey = namespace .. ':' .. id
  local voterskey = recordkey .. ':voter_ids'

  if redis.call('EXISTS', recordkey) == 0 then
    error(namespace .. ' not found: ' .. id)
  end

  local score = tonumber(redis.call('ZSCORE', allkey, id))

  if score + incr < 0 then
    error('invalid vote. votes must not be negative')
  end

  local newscore = redis.call('ZINCRBY', allkey, incr, id)

  if incr == '1' then
    redis.call('SADD', voterskey, voter)
  else
    redis.call('SREM', voterskey, voter)
  end

  return newscore
end

vote(KEYS[1], KEYS[2], ARGV[1], KEYS[3])

return find(KEYS[1], KEYS[2])
