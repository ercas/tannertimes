-- usage: love . /path/to/images/*.jpg

images = {}
currentBase = nil
currentOverlay = nil
scale = 1

imageExtensions = {
    "jpg";
    "png";
    "gif";
    "tiff";
}

--== functions ==============================================================---
-- check if a given file has an image extension
function isImage(filename)
    for _,ext in pairs(imageExtensions) do
        if string.find(string.lower(filename),string.lower(ext).."$") then
            return true
        end
    end
end

-- return an Image object, given the absolute filesystem path to an image file
function imageFromPath(path)
    local file = io.open(path)
    local imageDataRaw = file:read("*all")
    file:close()
    local imageData = love.filesystem.newFileData(imageDataRaw,path:match("[^/]+$"))
    local imageObject = love.graphics.newImage(imageData)
    return imageObject
end

--===========================================================================---
function love.load(args)
    for index, arg in pairs(args) do
        if isImage(arg) then
            table.insert(images,arg)
        else
            print(arg.." is not an image and has been ignored.")
        end
    end

    print("index", "value")
    for index, value in pairs(images) do
        print(index, value)
    end
end

function love.wheelmoved(x, y)
    scale = scale + (y * 0.1)
end

function love.draw()
    if not currentBase then
        currentBase = table.remove(images,1)
        image = imageFromPath(currentBase)
        --currentBase = love.graphics.newImage(table.remove(images,1))
    end
    love.graphics.draw(image,0,0,0,scale,scale)
end
