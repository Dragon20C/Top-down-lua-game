local moon_light = {}


-- Clamp function
function Clamp(number,min,max)
    return math.min(math.max(number, min), max)
end

-- Find middle point between two positions
function Mid_point(A_X,A_Y,B_X,B_Y)
    return {((A_X + B_X) / 2), ((A_Y + B_Y) / 2)}
end

-- Check if number is even
function Is_even(number)
    return number%2 == 0
end

-- Linear Interpolation function
function Lerp(start_v,end_v,percent)
    return start_v + (end_v - start_v) * percent
end

-- Pow returns the base to the exponent power, as in base^exponent
function Pow(x,y)
    return x^y
end

-- Round number by amount of numbers after decimal
function Round(x, n)
    n = Pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5)
    end
    return x / n
end

-- Maps a value to a different range, example value = 0.5, min = 0 max = 1, out_min = 0 out_max = 100 output = 50
function Map(value,value_min,value_max,out_min,out_max)
        return (value - value_min) * (out_max - out_min) / (value_max - value_min) + out_min
end

-- Normalize two numbers
function Normalize(x,y)
    local l=(x*x+y*y)^.5
    if l==0 then
        return 0,0,0
    else
        return x/l,y/l,l
    end
end

-- Check current operating system
function Check_os()
    local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
    if BinaryFormat == "dll" then
        return "Windows"
    elseif BinaryFormat == "so" then
        return "Linux"
    elseif BinaryFormat == "dylib" then
        return "MacOS"
    end
    BinaryFormat = nil
end

return moon_light