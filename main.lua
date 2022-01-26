

function New_Button(text,x,y,width,height,func)
    return {text = text,x = x,y = y, width = width,height = height,func = func, now = false, last = false}
end
local buttons = {}
font = nil

local function Enum(tbl)
    local length = #tbl
    for i = 1, length do
        local v = tbl[i]
        tbl[v] = i
    end

    return tbl
end


function love.load()
    font = love.graphics.newFont(32)
    moon = require "Library/moon_light"

    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()

    game_state = {"MENU","OVERWORLD"} -- Enum for game state
    
    Enum(game_state)

    current_game_state = game_state.MENU

    table.insert(buttons,New_Button("Start Game" --Text
    ,Mid_point(0,0,screen_width,screen_height)[1] - 200 -- X
    ,100 - 50 -- Y
    ,400,70 -- Width and height
    ,function() current_game_state = game_state.OVERWORLD  end)) -- Function

    table.insert(buttons,New_Button("Continue"
    ,Mid_point(0,0,screen_width,screen_height)[1] - 200
    ,100 - 50
    ,400,70
    ,function() return "continuing" end))

    table.insert(buttons,New_Button("Exit"
    ,Mid_point(0,0,screen_width,screen_height)[1] - 200
    ,100 - 50
    ,400,70
    ,function() return "exiting" end))

    love.graphics.setDefaultFilter("nearest","nearest")

    require "Player"
    Load_Player_Data()
    Player_Init(Mid_point(0,0,screen_width,screen_height)[1] - (16 / 2),Mid_point(0,0,screen_width,screen_height)[2] - (21 / 2))

end



function love.update(dt)
    if current_game_state == game_state.OVERWORLD then

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
    Player_Motion(dt)
    end
end


function love.draw()
    if current_game_state == game_state.MENU then
        for index, button in ipairs(buttons) do
            local height = index * 120 -- Giving each button hieght
            local colour = {0.2,0.2,0.8,1}
            local mx,my = love.mouse.getPosition()
            local selected = mx > button.x and mx < button.x + button.width and my > button.y + height and my < button.y + height + 5 + button.height
            if selected then
                colour = {0.8,0.2,0.2,1}
            end
            button.now = love.mouse.isDown(1)
    
            if button.now and button.last ~= button.now  and selected then
                button.func()
            end
            love.graphics.setColor(unpack(colour))
            
            love.graphics.rectangle("fill",button["x"],button["y"] + height,button["width"],button["height"])
    
            love.graphics.setColor(1,1,1,1)
    
            local text_width = font:getWidth(button.text)
            local text_height = font:getHeight(button.text)
    
            love.graphics.print(button["text"],font,button["x"] + (button.width / 2) - (text_width / 2),button["y"] + (text_height / 2) + height)
        end
        --love.graphics.rectangle("fill",position["x"] - 25,position["y"] - 25,50,50)
        --love.graphics.print("Horiztonal value : " .. movement["H"] .. "\nVertical value : " .. movement["V"],100,400)
        --love.graphics.print(message,100,400)
        --love.graphics.print(button["text"],font,button["x"] + (button["width"] / 4),button["y"] + (button["height"] / 4) + height)
    elseif current_game_state == game_state.OVERWORLD then
        
        
        love.graphics.setColor(0.8,0.8,0.8,1) -- set background to a solid colour
        love.graphics.rectangle("fill",0,0,screen_width,screen_height)
        Draw_Player()
       -- love.graphics.draw(sprite_image,player_sprite,position["x"] - ((sprite.width / 2) * scale), position["y"] - ((sprite.height / 2) * scale),0,scale,scale,0,0)
        love.graphics.setColor(0,0,0,1)

        
        --love.graphics.rectangle("fill",position["x"] - 25,position["y"] - 25,50,50)
    end
end
