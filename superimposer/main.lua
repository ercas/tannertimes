-- usage: love . /path/to/images/*.jpg

-- TODO:
-- possibly rework the rotation mechanism so the controls are more similar to
-- gimp's controls

-- config
imageExtensions = {
    "jpg",
    "png",
}
rotationSensitivity = 0.005
scaleSensitivity = 0.01

images = {}
baseImage = nil
baseScale = 1 -- only used internally to make the baseImage fill the window
convertString = ""
windowWidth = 0
windowHeight = 0

-- overlay image properties
overlayImage = nil
overlayPath = nil
translation = {x = 0, y = 0}
rotation =  0
scale = 1

-- used for controls
dragging = false
mouseOriginalPosition = {x = 0, y = 0}
mouseDragged = {x = 0, y = 0}

rotating = false
mouseRotationOrigin = 0
mouseRotated = 0

--== functions ===============================================================--
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

-- overlay a new image and reset the variables
function overlayNewImage()
    overlayPath = table.remove(images,1)
    overlayImage = imageFromPath(overlayPath)
    translation = {x = 0, y = 0}
    rotation =  0
    scale = 1
end

--== input ===================================================================--
-- for mouse:
-- button 1 = dragging
-- button 2 = rotating
-- button 3 scroll = scaling
-- button 3 press = save

function love.mousepressed(x, y, button)
    print("mouse pressed", button)
    if button == 1 then
        dragging = true
        mouseOriginalPosition = {x = x, y = y}
    elseif button == 2 then
        rotating = true
        mouseRotationOrigin = x
    elseif button == 3 then
        print("saving...")
        -- TODO: translate transformations into an imagemagick command
--[[
NOTE TO SELF: how to composite with imagemagick

convert -size [FINAL IMAGE SIZE] xc:white \
    \( 1.jpg -alpha on -channel a -evaluate set [LAYER_TRANSPARENCY] -background transparent -rotate [DEG] \) -gravity center -geometry [OFFSET] -composite \
    \( 2.jpg -alpha on -channel a -evaluate set [LAYER_TRANSPARENCY] -background transparent -rotate [DEG] \) -gravity center -geometry [OFFSET] -composite \
    \( 3.jpg -alpha on -channel a -evaluate set [LAYER_TRANSPARENCY] -background transparent -rotate [DEG] \) -gravity center -geometry [OFFSET] -composite \
    out.jpg

where
    DEG = rotation
    OFFSET = "+"..translation.x.."+"..translation.y

ex
rm -f out.jpg
convert -size 620x372 xc:none \
    \( c.jpg \) -composite \
    \( c.jpg -alpha on -channel a -evaluate set 50% -background transparent -rotate 15 \) -gravity center -geometry +100+100 -composite \
    out.jpg
feh out.jpg
--]]
        print("saved")
        if #images > 1 then
            overlayNewImage()
            collectgarbage("collect")
        else
            print("\nno images left")
            love.event.push("quit")
        end
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
        translation = {
            x = translation.x + mouseDragged.x,
            y = translation.y + mouseDragged.y
        }
        print("new translation", translation.x, translation.y)
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

--============================================================================--
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
        print("\nERROR: not enough valid images provided.")
        print("usage: love superimposer /path/to/image1.jpg /path/to/image2.jpg")
        print("valid image types: jpg, png")
        love.event.push("quit")
        return
    end

    -- list images for debug purposes
    print("index", "value")
    for index, value in pairs(images) do
        print(index, value)
    end

    baseImage = imageFromPath(table.remove(images, 1))

    -- set the baseScale
    windowWidth, windowHeight = love.graphics.getDimensions()
    local widthProportion = windowWidth/baseImage:getWidth()
    local heightProportion = windowHeight/baseImage:getHeight()
    if widthProportion < heightProportion then
        baseScale = widthProportion
    else
        baseScale = heightProportion
    end

    -- overlay the first image
    overlayNewImage()
end

function love.draw()
    local x = translation.x + mouseDragged.x
    local y = translation.y + mouseDragged.y
    local rot = rotation + mouseRotated
    local sc = scale * baseScale

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(baseImage, 0, 0, 0, baseScale, baseScale)

    love.graphics.setColor(255, 255, 255, 150)
    love.graphics.draw(
        overlayImage,
        x + baseImage:getWidth() * baseScale / 2,
        y + baseImage:getHeight() * baseScale / 2,
        rot,
        sc,
        sc,
        overlayImage:getWidth()/2,
        overlayImage:getHeight()/2
    )

    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.rectangle("fill", 0, 0, windowWidth, 22)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("translation: "..math.floor(x / baseScale)..","..math.floor(y / baseScale).." pixels  |  rotation: "..rot.." radians  |  scale: "..(scale * 100).."%  |  path: "..overlayPath, 5, 5)
end
