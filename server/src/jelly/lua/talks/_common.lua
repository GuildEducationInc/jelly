local function find(namespace, id)
  local allkey = namespace .. ':all'
  local recordkey = namespace .. ':' .. id

  if redis.call('EXISTS', recordkey) == 0 then
    error(namespace .. ' not found: ' .. id)
  end

  local linkskey = recordkey .. ':links'
  local sfkey = recordkey .. ':scheduled_for'
  local voterskey = recordkey .. ':voter_ids'
  local record = redis.call('GET', recordkey)
  local voterids = redis.call('SMEMBERS', voterskey)
  local scheduledfor = redis.call('GET', sfkey)
  local links = redis.call('SMEMBERS', linkskey)
  local score = tonumber(redis.call('ZSCORE', allkey, id))

  return { record, score, voterids, scheduledfor, links }
end
