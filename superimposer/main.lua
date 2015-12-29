-- usage: love . /path/to/images/*.jpg

-- TODO:
-- possibly rework the rotation mechanism so the controls are more similar to
-- gimp's controls

love.window.setMode(400, 600, { resizable = true })

-- config
imageExtensions = {
    "jpg",
    "png",
}
rotationSensitivity = 0.005
scaleSensitivity = 0.01
verbose = false
outputScript = "superimpose.sh"
outputImage = "superimposed.png"

-- misc
images = {}

baseImage = nil
basePath = nil
baseCenter = {x = 0, y = 0}
baseScale = 1 -- only used internally to make the baseImage fill the window

windowWidth = 0
windowHeight = 0

convertString = "/usr/bin/env convert" -- manipulated further in love.load
hasImageMagick = false

-- overlay image properties
overlayImage = nil
overlayPath = nil
translation = {x = 0, y = 0}
rotation =  0
scale = 1

actualTranslation = {x = 0, y = 0} -- translation, adjusted for baseScale
degreesRotation = 0 -- rotation in degrees instead of radians

-- used for transformations
dragging = false
mouseOriginalPosition = {x = 0, y = 0}
mouseDragged = {x = 0, y = 0}

rotating = false
mouseRotationOrigin = 0
mouseRotated = 0

--== functions ===============================================================--
-- append a new layer to convertString
--[[
    how to composite with imagemagick:

    convert -size [FINAL IMAGE SIZE] xc:none \
        \( 1.jpg -alpha on -channel a -evaluate set [LAYER_OPACITY] -background transparent -rotate [DEG] -scale [SCALE]% \) -gravity center -geometry [OFFSET] -composite \
        \( 2.jpg -alpha on -channel a -evaluate set [LAYER_OPACITY] -background transparent -rotate [DEG] -scale [SCALE]% \) -gravity center -geometry [OFFSET] -composite \
        out.jpg
--]]
function appendLayer(path, x, y, rot, scale, transparency)
    local xSign, ySign, layerString
    if x >= 0 then
        xSign = "+"
    else
        xSign = ""
    end
    if y >= 0 then
        ySign = "+"
    else
        ySign = ""
    end
    if not transparency then
        transparency = "$LAYER_OPACITY"
    end
    layerString = "\n    \\( \""..
                      path.."\" -alpha on -channel a "..
                      "-evaluate set "..transparency.."% "..
                      "-background transparent "..
                      "-rotate "..rot.." "..
                      "-scale "..math.floor(scale*100).."% "..
                  "\\) "..
                  "-gravity center "..
                  "-geometry "..xSign..x..
                                ySign..y.." "..
                  "-composite \\"
    convertString = convertString..layerString
    echo("appended "..layerString)
end

-- wrapper for print
function echo(str)
    if verbose then
        print(str)
    end
end

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
    echo("opening "..path)
    local file = io.open(path)
    local imageDataRaw = file:read("*all")
    file:close()
    local imageData = love.filesystem.newFileData(imageDataRaw, path:match("[^/]+$"))
    local imageObject = love.graphics.newImage(imageData)
    return imageObject
end

-- rescale everything so that the base image fills as much of the window as
-- possible. this is only a visual thing and has no bearing on the actual scale.
function setBaseScale()
    windowWidth, windowHeight = love.graphics.getDimensions()
    local widthProportion = windowWidth/baseImage:getWidth()
    local heightProportion = windowHeight/baseImage:getHeight()
    if widthProportion < heightProportion then
        baseScale = widthProportion
    else
        baseScale = heightProportion
    end
    baseCenter = {
        x = baseImage:getWidth() * baseScale / 2,
        y = baseImage:getHeight() * baseScale / 2
    }
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

function love.mousepressed(x, y, button)
    echo("mouse pressed", button)
    
    -- begin dragging
    if button == 1 then
        dragging = true
        mouseOriginalPosition = {x = x, y = y}

    -- begin rotating
    elseif button == 2 then
        rotating = true
        mouseRotationOrigin = math.atan((translation.y - mouseDragged.y + baseCenter.y - y) / 
                                 (translation.x - mouseDragged.x + baseCenter.x - x))
        if x < (translation.x - mouseDragged.x + baseCenter.x) then
            mouseRotationOrigin = mouseRotationOrigin + math.pi
        end

    -- save the new layer
    elseif button == 3 then
        echo("saving...")

        appendLayer(overlayPath, actualTranslation.x, actualTranslation.y, degreesRotation, scale)

        -- load next image or exit
        if #images > 0 then
            overlayNewImage()
            collectgarbage("collect")
        else
            print("\nno images left")

            -- add final touches to convertString and turn it into a standalone
            -- shell script
            convertString = "#!/usr/bin/env sh "..
                            "\n# generated with superimposer"..
                            "\n\n"..convertString..
                            "\n    "..outputImage.." && \\"..
                            "\necho 'wrote composited image to "..outputImage.."' || \\"..
                            "\necho 'error compositing images'"
            echo("final script: "..convertString)
            
            -- write convertString to a file and make it executable
            local newFile = io.open(outputScript,"w")
            newFile:write(convertString)
            newFile:close()
            os.execute("chmod +x "..outputScript)

            print("\nwrote script to "..outputScript)
            print("to use: sh superimpose.sh OR ./superimpose.sh")
            print("\nchange the LAYER_OPACITY variable in that script if you need more or")
            print("less transparent layers.")
            if not hasImageMagick then
                print("\nWARNING: this script needs ImageMagick installed to run.")
                print("you can download ImageMagick at http://www.imagemagick.org/script/index.php")
                print("this program should also be available in your distribution's repository.")
            end
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
        echo("mouse dragging", mouseDragged.x, mouseDragged.y, button)
    end

    -- not elseif because a user could be dragging and rotating at the same time
    if rotating then
        mouseRotated = math.atan((translation.y - mouseDragged.y + baseCenter.y - y) / 
                                 (translation.x - mouseDragged.x + baseCenter.x - x))
        if x < (translation.x - mouseDragged.x + baseCenter.x) then
            mouseRotated = mouseRotated + math.pi
        end
        mouseRotated = -(mouseRotationOrigin - mouseRotated)
        echo("mouse rotating", mouseRotated)
    end

end

function love.mousereleased(x, y, button)
    echo("mouse released", button)

    -- save drag
    if button == 1 then
        echo("total drag", mouseDragged.x, mouseDragged.y)
        dragging = false
        translation = {
            x = translation.x + mouseDragged.x,
            y = translation.y + mouseDragged.y
        }
        echo("new translation", translation.x, translation.y)
        mouseDragged = {x = 0, y = 0}

    -- save rotate
    elseif button == 2 then
        echo("total rotation", mouseRotated)
        rotating = false
        rotation = rotation + mouseRotated
        if rotation > (math.pi * 2) then
            rotation = rotation - (math.pi * 2)
        elseif rotation < 0 then
            rotation = rotation  + (math.pi * 2)
        end
        echo("new rotation", rotation)
        mouseRotated = 0
    end
end

function love.wheelmoved(x, y)
    echo("scroll", x, y)
    scale = scale + (y * scaleSensitivity)
    if scale < 0 then
        scale = 0
    end
end

--== other events ============================================================--
function love.resize()
    setBaseScale()
end

--============================================================================--
function love.load(args)
    -- parse arguments for valid images and add them to the images table
    for index, arg in pairs(args) do
        if isImage(arg) then
            table.insert(images,arg)
        else
            print(arg.." is not a valid image and has been ignored.")
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
    echo("index", "value")
    for index, value in pairs(images) do
        echo(index, value)
    end
    echo("loaded "..#images.." images")

    -- check if imagemagick is available. os.execute doesn't seem to be
    -- returning anything, and neither is io.popen, so a temp file hack has to
    -- be used.
    imageMagickStatus = "/tmp/superimposer-imageMagickStatus.temp"
    os.execute("command -v convert > "..imageMagickStatus)
    imageMagickStatusFile = io.open(imageMagickStatus,"r")
    if string.len(imageMagickStatusFile:read("*all")) == 0 then
        print("\nWARNING: imageMagick not available.")
    else
        hasImageMagick = true
    end
    imageMagickStatusFile:close()
    os.execute("rm "..imageMagickStatus)

    basePath = table.remove(images, 1)
    baseImage = imageFromPath(basePath)
    setBaseScale()
    
    -- generate the rest of convertString, minus layers and output image
    convertString = "LAYER_OPACITY=50"..
                    "\nMAGICK_TMPDIR=$HOME # this is where temporary files will be kept"..
                    "\n\n"..convertString.." "..
                    "-size "..baseImage:getWidth().."x"..baseImage:getHeight().." "..
                    "xc:none \\"..
                    "\n    -limit memory 128M -limit map 256M \\"
    appendLayer(basePath, 0, 0, 0, 1, 100)

    overlayNewImage()
end

function love.draw()
    local x = translation.x + mouseDragged.x
    local y = translation.y + mouseDragged.y
    local rot = rotation + mouseRotated
    local sc = scale * baseScale

    actualTranslation = {
        x = math.floor(x / baseScale),
        y = math.floor(y / baseScale),
    }
    degreesRotation = math.floor(math.deg(rot))

    -- base image
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(baseImage, 0, 0, 0, baseScale, baseScale)

    -- overlay image
    love.graphics.setColor(255, 255, 255, 150)
    love.graphics.draw(
        overlayImage,
        x + baseCenter.x,
        y + baseCenter.y,
        rot,
        sc,
        sc,
        overlayImage:getWidth()/2,
        overlayImage:getHeight()/2
    )

    -- heads up display
    love.graphics.setColor(0, 0, 0, 150)
    love.graphics.rectangle("fill", 0, 0, windowWidth, 22)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("translation: "..actualTranslation.x..", "..actualTranslation.y.." pixels  |  rotation: "..degreesRotation.." degrees  |  scale: "..(scale * 100).."%  |  overlay: "..overlayPath, 5, 5)
end
