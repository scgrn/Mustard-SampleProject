imgui = {
    UPDATE = 0,
    RENDER = 1,
    
    mouseX = 0,
    mouseY = 0,
    mouseDown = false,

    hot = 0,
    active = 0
}

function imgui.prepare()
    imgui.mouseX, imgui.mouseY, imgui.mouseDown = AB.input.getMouseState()
    imgui.mouseX = (imgui.mouseX - videoConfig.xOffset) / videoConfig.xScale
    imgui.mouseY = (imgui.mouseY - videoConfig.yOffset) / videoConfig.yScale
end

function imgui.finish()
    if (not imgui.mouseDown) then
        imgui.active = 0
    else
        if (imgui.active == 0) then
            imgui.active = -1
        end
    end
end

local function regionHit(x, y, w, h)
    if (imgui.mouseX < x or imgui.mouseY < y - h or
        imgui.mouseX >= x + w or imgui.mouseY >= y) then

        return false
    else
        return true
    end
end

function imgui.button(id, x, y, w, h, mode, renderFunc, disabled)
    disabled = disabled or false

    if (mode == imgui.UPDATE and not disabled) then
        if (regionHit(x, y, w, h)) then
            imgui.hot = id
            if (imgui.active == 0 and imgui.mouseDown) then
                imgui.active = id
            end
        end

        --  button hot and active, but mouse not down, user clicked!
        if (not imgui.mouseDown and imgui.hot == id and imgui.active == id) then
            return true
        else
            return false
        end
    else
        -- mode == RENDER
        renderFunc(id == imgui.hot, id == imgui.active)
    end
end




