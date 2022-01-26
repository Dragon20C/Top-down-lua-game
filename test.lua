

local function get_ani_data(file_path,animation_table)
  local file = io.open(file_path,"r")
  local contents = file:read("*a")
  local i = contents:match("%b()")
  for a , b in i:gmatch("(%a+) = (%d+)") do
    animation_table[a] = tonumber(b)
  end
  return animation_table
end

local function get_animations(file_path)
    local animation_table = {}
    local file = io.open(file_path,"r")
    local contents = file:read("*a")
    for k, v in contents:gmatch("(%g%a+) = (%b{})") do -- A gets words and %b{} finds brackets (%a+)=(%b{}) (%d+),(%d)
        animation_table[k] = {}
        local frame_count = 0
        for num1,num2 in v:gmatch("(%d+),(%d+)") do
          frame_count = frame_count + 1
          table.insert(animation_table[k],{num1,num2})
        end
        animation_table[k.." frames"] = frame_count
      end
    file:close()
    animation_table = get_ani_data(file_path,animation_table)
    return animation_table
end

local ani_table = get_animations("Sprites/Player/MainPlayer.txt")

print(ani_table["up frames"])

--print(ani_table["frames"])
--local new_table  = {left = {}}

--table.insert(new_table["left"],{20,30})

--print(new_table["left"][1][2])


    
