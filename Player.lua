
local function Enum(tbl)
    local length = #tbl
    for i = 1, length do
        local v = tbl[i]
        tbl[v] = i
    end

    return tbl
end

local function get_ani_data(file_path,animation_table)
    local file = io.open(file_path,"r")
    local contents = file:read("*a")
    local i = contents:match("%b()")
    for a , b in i:gmatch("(%a+) = (%d+)") do -- Finds words and numbers that are inside ()
      animation_table[a] = tonumber(b)
    end
    return animation_table
  end
  
local function get_animations(file_path) -- Gets animation cords from a text file and also how many frames
    local animation_table = {}
    local file = io.open(file_path,"r")
    local contents = file:read("*a")
    for k, v in contents:gmatch("(%g%a+) = (%b{})") do
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

function Key_input(key)
    if love.keyboard.isDown(key) then
        return 1
    else
        return 0
    end
end

function Load_Player_Data()
    -- State Machine Section

    States = {"IDLE","WALKING","ATTACKING","DEAD"}
    Enum(States)
    Current_State = States.IDLE

    -- Movement Section
    Position = {X = 0, Y = 0}
    Motion = {X = 0, Y = 0}
    Calculations = {X = 0, Y = 0}
    Final_motion = {X = 0, Y = 0}

    Acceleration = 6
    FPS = 60
    Friction_duration = 0.2
    Player_direction = "down"

    -- Animation Section
    Animation_data = get_animations("Sprites/Player/MainPlayer.txt")

    Animation_value = {}
    Animation_value.width = Animation_data["width"]
    Animation_value.height = Animation_data["height"]

    Anim_fps = 6
    Anim_timer =  0
    Frames = 0
    Motion_counter = {X_Counter = 0, Y_Counter = 0}

    Sprite_sheet = love.graphics.newImage("Sprites/Player/MainPlayer.png")
    Player_image = love.graphics.newQuad(0,0,Animation_value.width,Animation_value.height,Sprite_sheet:getDimensions())

end

function Player_Init(pos_x,pos_y)
    Position.X = pos_x
    Position.Y = pos_y
end

function Player_Motion(DT)
    
    -- Checks which direction the user has input, example d = 1 and a = 0 means moving right
    Motion["X"] = Key_input("d") - Key_input("a")
    Motion["Y"] = Key_input("s") - Key_input("w")

    if Motion["X"] == 1 then 
        Player_direction = "right"
    elseif Motion["X"] == -1 then
        Player_direction = "left"
    end

    if Motion["Y"] == 1 then
        Player_direction = "down"
    elseif Motion["Y"] == -1 then
        Player_direction = "up"
    end

    if Motion["X"] ~= 0 or Motion["Y"] ~= 0 then
        Anim_timer = Anim_timer - DT
        if Anim_timer <= 0 then
            Anim_timer = 1/Anim_fps
            Frames = Frames + 1
            if Frames > Animation_data[Player_direction .. " frames"] then --- Finds the amount of frames a sprite sheet has so two dif animations can have dif frames
                Frames = 1
            end
        end

        Player_image:setViewport(Animation_data[Player_direction][Frames][1],Animation_data[Player_direction][Frames][2],Animation_value.width,Animation_value.height)
    else
        Anim_timer = -0.1
        Player_image:setViewport(0,Animation_data[Player_direction][1][2],Animation_value.width,Animation_value.height)
    end

    if Motion["X"] ~= 0 then -- Checks if the player is moving then apply some calculations
        Motion_counter.X_Counter = 0
        Calculations["X"] = Motion["X"] * Acceleration * DT * FPS
        Final_motion["X"] = Calculations["X"]
    end
      
    if Motion["X"] == 0 then -- Checks if not moving then slow down the player to a stop
        if Motion_counter.X_Counter < Friction_duration then
            Final_motion["X"] = Lerp(Calculations["X"],0,Motion_counter.X_Counter/Friction_duration)
            Motion_counter.X_Counter = Motion_counter.X_Counter + DT
        else
            Calculations["X"] = 0 -- When the timer has passed we set the values to 0 to make sure we dont have random values
            Final_motion["X"] = 0
        end
    end

    if Motion["Y"] ~= 0 then -- Up and down
        Motion_counter.Y_Counter = 0
        Calculations["Y"] = Motion["Y"] * Acceleration * DT * FPS
        Final_motion["Y"] = Calculations["Y"]
    end
      
    if Motion["Y"] == 0 then
        if Motion_counter.Y_Counter < Friction_duration then
            Final_motion["Y"] = Lerp(Calculations["Y"],0,Motion_counter.Y_Counter/Friction_duration)
            Motion_counter.Y_Counter = Motion_counter.Y_Counter + DT
        else
            Calculations["Y"] = 0
            Final_motion["Y"] = 0
        end
    end

    Position["X"] = Position["X"] + Final_motion["X"] -- Apply the motion to the players position
    Position["Y"] = Position["Y"] + Final_motion["Y"]
end


function Draw_Player()
    local scale = 6
    love.graphics.draw(Sprite_sheet,Player_image,Position["X"] - ((Animation_value.width / 2) * scale), Position["Y"] - ((Animation_value.height / 2) * scale),0,scale,scale,0,0)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(Motion.X .. " : " .. Motion.Y .. "\n" .. Player_direction ,300,400)
    love.graphics.print(Motion_counter.X_Counter .. " :\n " .. Motion_counter.Y_Counter ,300,450)
    love.graphics.print(States[Current_State] ,300,500)
end