local markov = {}
markov.__index = markov
markov.random = math.random

local final = {}


local function increment_item_count(t, item)
  local val = t[item]
  t[item] = val and val + 1 or 1
end


local function update_item(map, item, next)
  local t = map[item]
  if not t then
    t = {}
    map[item] = t
  end
  increment_item_count(t, next)
end


local function choose(t)
  local n = 0
  for k, v in pairs(t) do
    n = n + v
  end
  n = markov.random(n) - 1
  for k, v in pairs(t) do
    n = n - v
    if n < 0 then
      return k
    end
  end
end


function markov.new()
  local self = setmetatable({}, markov)
  self.map = {}
  self.firsts = {}
  return self
end


function markov:add(t)
  if #t == 0 then
    return
  end
  -- add first item to "firsts" table
  local first = t[1]
  increment_item_count(self.firsts, first)
  -- add all items to map
  local prev
  for _, it in ipairs(t) do
    if prev then update_item(self.map, prev, it) end
    prev = it
  end
  update_item(self.map, prev, final)
end


function markov:generate()
  local res = {}
  local item = choose(self.firsts)
  while item ~= final do
    table.insert(res, item)
    item = choose(self.map[item])
  end
  return res
end


return markov
