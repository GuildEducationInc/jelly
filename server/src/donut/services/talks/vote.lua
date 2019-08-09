local recordkey = KEYS[1] .. ':' .. KEYS[2]
local voterskey = KEYS[1] .. ':' .. KEYS[2] .. ':voter_ids'
local allkey = KEYS[1] .. ':all'

if redis.call('EXISTS', recordkey) == 0 then
  error('invalid talk id: ' .. KEYS[2])
end

local score = tonumber(redis.call('ZSCORE', allkey, KEYS[2]))

if score + ARGV[1] < 0 then
  error('invalid vote. votes must not be negative')
end

local rawnewscore = redis.call('ZINCRBY', allkey, ARGV[1], KEYS[2])

if ARGV[1] == '1' then
  redis.call('SADD', voterskey, KEYS[3])
else
  redis.call('SREM', voterskey, KEYS[3])
end

local newscore = tonumber(rawnewscore)
local record = redis.call('GET', recordkey)
local voterids = redis.call('SMEMBERS', voterskey)

return { record, newscore, voterids }
