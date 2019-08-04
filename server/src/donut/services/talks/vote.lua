local recordkey = KEYS[1] .. ':' .. KEYS[2]
local allkey = KEYS[1] .. ':all'

if redis.call('EXISTS', recordkey) == 0 then
  error('invalid talk id: ' .. KEYS[2])
end

local score = tonumber(redis.call('ZSCORE', allkey, KEYS[2]))

if score + ARGV[1] < 0 then
  error('invalid vote. votes must not be negative')
end

local rawnewscore = redis.call('ZINCRBY', allkey, ARGV[1], KEYS[2])
local newscore = tonumber(rawnewscore)
local record = redis.call('GET', recordkey)

return { record, newscore }
