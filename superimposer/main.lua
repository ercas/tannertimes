-- usage: love . /path/to/images/*.jpg

images = {}
baseImage = nil
overlayImage = nil
position = {x = 0, y = 0}

mouseDown = false
mouseOriginalPosition = {x = 0, y = 0}
mouseDragged = {x = 0, y = 0}
scale = 1

imageExtensions = {
    "jpg",
    "png",
    "gif",
    "tiff"
}

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
    local imageData = love.filesystem.newFileData(imageDataRaw,path:match("[^/]+$"))
    local imageObject = love.graphics.newImage(imageData)
    return imageObject
end

--== input ==================================================================---
function love.mousepressed(x,y)
    print("mouse pressed")
    mouseDown = true
    mouseOriginalPosition = {x = x, y = y}
end

function love.mousemoved(x,y)
    if mouseDown then
        print("mouse dragging",
            mouseOriginalPosition.x - x, mouseOriginalPosition.y - y)
        mouseDragged = {
            x = -(mouseOriginalPosition.x - x),
            y = -(mouseOriginalPosition.y - y)
        }
    end
end

function love.mousereleased(x,y)
    print("mouse released")
    mouseDown = false
    position = {
        x = position.x + mouseDragged.x,
        y = position.y + mouseDragged.y
    }
    mouseDragged = {x = 0, y = 0}
    print("mouse dragged", mouseDragged.x, mouseDragged.y)
end

function love.wheelmoved(x,y)
    print("scroll", x, y)
    scale = scale + (y * 0.01)
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

    baseImage = imageFromPath(table.remove(images,1))
end

function love.draw()
    if not overlayImage then
        overlayImage = imageFromPath(table.remove(images,1))
    end
    love.graphics.draw(baseImage)
    love.graphics.draw(
        overlayImage,
        position.x + mouseDragged.x,
        position.y + mouseDragged.y,
        0,scale,scale
    )
end
