-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

function Utilities.getZero()
    return 0
end

function Utilities.sqr(x)
    return x * x
end

-- Add v2 to v1
function Utilities.vAddV(v1, v2)
    return { x = v1.x + v2.x, y = v1.y + v2.y }
end

-- Subtract v2 from v1
function Utilities.vSubV(v1, v2)
    return { x = v1.x - v2.x, y = v1.y - v2.y }
end

-- Compute magnitude of v
function Utilities.vMag(v)
    return math.sqrt((v.x * v.x) + (v.y * v.y))
end

-- Compute magnitude of v
function Utilities.vScale(v, k)
    return { x = v.x * k, y = v.y * k }
end

-- Normalizes v into a unit vector
function Utilities.vNorm(v)
    local len = Utilities.vMag(v)
    if len == 0 then
        return { x = 0, y = 0 }
    else
        return { x = v.x / len, y = v.y / len }
    end
end

function Utilities.vDist(v1, v2)
    return math.sqrt(Utilities.sqr(v2.x - v1.x) + Utilities.sqr(v2.y - v1.y))
end

function Utilities.vDistSqr(v1, v2)
    return Utilities.sqr(v2.x - v1.x) + Utilities.sqr(v2.y - v1.y)
end

function Utilities.getModIndex(i, len)
    return (i - 1) % len + 1
end

function table.reduce(__table, __function, __initial)
    local accumulator = __initial
    for _, value in ipairs(__table) do
        accumulator = __function(accumulator, value)
    end
    return accumulator
end

function all(__table)
    for _, value in ipairs(__table) do
        if not value then
            return false
        end
    end
    return true
end

function any(__table)
    for _, value in ipairs(__table) do
        if value then
            return true
        end
    end
    return false
end

function table.removeByValue(__table, __value)
    for i, v in ipairs(__table) do
        if v == __value then
            table.remove(__table, i)
            break
        end
    end
end
