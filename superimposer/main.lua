-- usage: love . /path/to/images/*.jpg

-- config
imageExtensions = {
    "jpg",
    "png",
}
rotationSensitivity = 0.01
scaleSensitivity = 0.01

-- image properties
images = {}
baseImage = nil
overlayImage = nil
position = {x = 0, y = 0}
rotation =  0
scale = 1

-- used for controls
dragging = false
mouseOriginalPosition = {x = 0, y = 0}
mouseDragged = {x = 0, y = 0}

rotating = false
mouseRotationOrigin = 0
mouseRotated = 0

--== functions ==============================================================---
-- check if a given file has an image extension (as specified by the
-- imageExtensions table)
function isImage(filename)
    for _,ext in pairs(imageExtensions) do
        if string.find(string.lower(filename),string.lower(ext).."$") then
            return true
        end
    end
end

-- return an Image object, given the absolute filesystem path to an image file.
-- could be smushed into a one liner, but open source is about learning, right?
function imageFromPath(path)
    local file = io.open(path)
    local imageDataRaw = file:read("*all")
    file:close()
    local imageData = love.filesystem.newFileData(imageDataRaw, path:match("[^/]+$"))
    local imageObject = love.graphics.newImage(imageData)
    return imageObject
end

--== input ==================================================================---
function love.mousepressed(x, y, button)
    print("mouse pressed", button)
    if button == 1 then
        dragging = true
        mouseOriginalPosition = {x = x, y = y}
    elseif button == 2 then
        rotating = true
        mouseRotationOrigin = x
    end
end

function love.mousemoved(x, y, button)
    if dragging then
        mouseDragged = {
            x = -(mouseOriginalPosition.x - x),
            y = -(mouseOriginalPosition.y - y)
        }
        print("mouse dragging", mouseDragged.x, mouseDragged.y, button)
    end
    -- not elseif because a user could be dragging and rotating at the same time
    if rotating then
        mouseRotated = (mouseRotationOrigin - x) * rotationSensitivity
        print("mouse rotating", mouseRotated)
    end
end

function love.mousereleased(x, y, button)
    print("mouse released", button)
    if button == 1 then
        print("total drag", mouseDragged.x, mouseDragged.y)
        dragging = false
        position = {
            x = position.x + mouseDragged.x,
            y = position.y + mouseDragged.y
        }
        print("new position", position.x, position.y)
        mouseDragged = {x = 0, y = 0}
    elseif button == 2 then
        print("total rotation", mouseRotated)
        rotating = false
        rotation = rotation + mouseRotated
        print("new rotation", rotation)
        mouseRotated = 0
    end
end

function love.wheelmoved(x, y)
    print("scroll", x, y)
    scale = scale + (y * scaleSensitivity)
end

--===========================================================================---
function love.load(args)
    -- parse arguments for valid images and add them to the images table
    for index, arg in pairs(args) do
        if isImage(arg) then
            table.insert(images,arg)
        else
            print(arg.." is not an image and has been ignored.")
        end
    end

    -- quit if there's not enough images
    if #images < 2 then
        print("\nERROR: not enough images provided.")
        love.event.push("quit")
        return
    end

    -- list images for debug purposes
    print("index", "value")
    for index, value in pairs(images) do
        print(index, value)
    end

    baseImage = imageFromPath(table.remove(images, 1))
end

function love.draw()
    if not overlayImage then
        overlayImage = imageFromPath(table.remove(images, 1))
    end
    love.graphics.draw(baseImage)
    love.graphics.draw(
        overlayImage,
        position.x + mouseDragged.x,
        position.y + mouseDragged.y,
        rotation + mouseRotated,
        scale, scale
    )
end
