--
-- Möan.lua
--
-- Copyright (c) 2017 twentytwoo
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

local utf8 = require("utf8")
local PATH = (...):match('^(.*[%./])[^%.%/]+$') or ''
Moan = {
  indicatorCharacter = ">", -- Next message indicator
  optionCharacter = "- ",   -- Option select character
  indicatorDelay = 25,      -- Delay between each flash of indicator
  selectButton = "space",   -- Key that advances message
  typeSpeed = 0.01,         -- Delay per character typed out
  debug = false,            -- Display some debugging

  history = {},             -- contains all previous messages + titles
  currentMessage  = "",
  currentMsgInstance = 1,   -- The Moan.new function instance
  currentMsgKey= 1,         -- Key of value in the Moan.new messages
  currentOption = 1,        -- Key of option function in Moan.new option array
  currentImage = nil,       -- Avatar image

  _VERSION     = '0.2.8',
  _URL         = 'https://github.com/twentytwoo/Moan.lua',
  _DESCRIPTION = 'A simple messagebox system for LÖVE',

  UI = {}
}

-- Create the message instance container
allMessages = {}

-- Section of the text printed so far
local printedText  = ""
-- Timer to know when to print a new letter
local typeTimer    = Moan.typeSpeed
local typeTimerMax = Moan.typeSpeed
-- Current position in the text
local typePosition = 0
-- Initialise timer for the indicator
local indicatorTimer = 0
local defaultFont = love.graphics.newFont()

if Moan.font == nil then
  Moan.font = defaultFont
end

function Moan.new(title, messages, config)
  if type(title) == "table" then
    titleColor = title[2]
    title = title[1]
  else -- just a string
    titleColor = {255, 255, 255}
  end

  -- Config checking / defaulting
  config = config or {}
  x = config.x
  y = config.y
  image = config.image or "nil"
  options = config.options -- or {{"",function()end},{"",function()end},{"",function()end}}
  onstart = config.onstart or function() end
  oncomplete = config.oncomplete or function() end
  if image == nil or type(image) ~= "userdata" then
    image = love.graphics.newImage("assets/gfx/noimg.png")
  end

  -- Insert \n before text is printed, stops half-words being printed
  -- and then wrapped onto new line
  if Moan.autoWrap then
    for i=1, #messages do
      messages[i] = Moan.wordwrap(messages[i], 40)
    end
  end

  -- Insert the Moan.new into its own instance (table)
  allMessages[#allMessages+1] = {
    title=title,
    titleColor=titleColor,
    messages=messages,
    x=x,
    y=y,
    image=image,
    options=options,
    onstart=onstart,
    oncomplete=oncomplete
  }
  Moan.history[#Moan.history+1] = {title, messages}

  -- Set the last message as "\n", an indicator to change currentMsgInstance
  allMessages[#allMessages].messages[#messages+1] = "\n"
  Moan.showingMessage = true

  -- Only run .onstart()/setup if first message instance on first Moan.new
  -- Prevents onstart=Moan.new(... recursion crashing the game.
  if Moan.currentMsgInstance == 1 then
    -- Set the first message up, after this is set up via advanceMsg()
    typePosition = 0
    Moan.currentMessage = allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey]
    Moan.currentTitle = allMessages[Moan.currentMsgInstance].title
    Moan.currentImage = allMessages[Moan.currentMsgInstance].image
    Moan.showingOptions = false
    -- Run the first startup function
    allMessages[Moan.currentMsgInstance].onstart()
  end
end

function Moan.update(dt)
  -- Check if the output string is equal to final string, else we must be still typing it
  if printedText == Moan.currentMessage then
    typing = false else typing = true
  end

  if Moan.showingMessage then
    -- Tiny timer for the message indicator
    if (Moan.paused or not typing) then
      indicatorTimer = indicatorTimer + 1
      if indicatorTimer > Moan.indicatorDelay then
        Moan.showIndicator = not Moan.showIndicator
        indicatorTimer = 0
      end
    else
      Moan.showIndicator = false
    end

    -- Check if we're the 2nd to last message, verify if an options table exists, on next advance show options
    if allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey+1] == "\n" and type(allMessages[Moan.currentMsgInstance].options) == "table" then
      Moan.showingOptions = true
    end
    if Moan.showingOptions then
      -- Constantly update the option prefix
      for i=1, #allMessages[Moan.currentMsgInstance].options do
        -- Remove the indicators from other selections
        allMessages[Moan.currentMsgInstance].options[i][1] = string.gsub(allMessages[Moan.currentMsgInstance].options[i][1], Moan.optionCharacter.." " , "")
      end
      -- Add an indicator to the current selection
      if allMessages[Moan.currentMsgInstance].options[Moan.currentOption][1] ~= "" then
        allMessages[Moan.currentMsgInstance].options[Moan.currentOption][1] = Moan.optionCharacter.." ".. allMessages[Moan.currentMsgInstance].options[Moan.currentOption][1]
      end
    end

    -- Detect a 'pause' by checking the content of the last two characters in the printedText
    if string.sub(Moan.currentMessage, string.len(printedText)+1, string.len(printedText)+2) == "--" then
      Moan.paused = true
      else Moan.paused = false
    end

    --https://www.reddit.com/r/love2d/comments/4185xi/quick_question_typing_effect/
    if typePosition <= string.len(Moan.currentMessage) then

        -- Only decrease the timer when not paused
        if not Moan.paused then
          typeTimer = typeTimer - dt
      end

        -- Timer done, we need to print a new letter:
        -- Adjust position, use string.sub to get sub-string
        if typeTimer <= 0 then
          -- Only make the keypress sound if the next character is a letter
              if string.sub(Moan.currentMessage, typePosition, typePosition) ~= " " and typing then
            Moan.playSound(Moan.typeSound)
              end
            typeTimer = typeTimerMax
            typePosition = typePosition + 1

            -- UTF8 support, thanks @FluffySifilis
        local byteoffset = utf8.offset(Moan.currentMessage, typePosition)
        if byteoffset then
          printedText = string.sub(Moan.currentMessage, 0, byteoffset - 1)
        end
        end
    end
  end
end

function Moan.advanceMsg()
  if Moan.showingMessage then
    -- Check if we're at the last message in the instances queue (+1 because "\n" indicated end of instance)
    if allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey+1] == "\n" then
      -- Last message in instance, so run the final function.
      allMessages[Moan.currentMsgInstance].oncomplete()

      -- Check if we're the last instance in allMessages
      if allMessages[Moan.currentMsgInstance+1] == nil then
        Moan.currentMsgInstance = 1
        Moan.currentMsgKey = 1
        Moan.currentOption = 1
        typing = false
        Moan.showingMessage = false
        typePosition = 0
        Moan.showingOptions = false
        allMessages = {}
      else
        -- We're not the last instance, so we can go to the next one
        -- Reset the msgKey such that we read the first msg of the new instance
        Moan.currentMsgInstance = Moan.currentMsgInstance + 1
        Moan.currentMsgKey = 1
        Moan.currentOption = 1
        typePosition = 0
        Moan.showingOptions = false
        Moan.moveCamera()
      end
    else
      -- We're not the last message and we can show the next one
      -- Reset type position to restart typing
      typePosition = 0
      Moan.currentMsgKey = Moan.currentMsgKey + 1
    end
  end

  -- Check showingMessage - throws an error if next instance is nil
  if Moan.showingMessage then
    if Moan.currentMsgKey == 1 then
      allMessages[Moan.currentMsgInstance].onstart()
    end
    Moan.currentMessage = allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey] or ""
    Moan.currentTitle = allMessages[Moan.currentMsgInstance].title or ""
    Moan.currentImage = allMessages[Moan.currentMsgInstance].image
  end
end

function Moan.draw()
  -- This section is mostly unfinished...
  -- Lots of magic numbers and generally takes a lot of
  -- trial and error to look right, beware.

  love.graphics.setDefaultFilter( "nearest", "nearest")
  if Moan.showingMessage then
    local scale = 0.26
    local padding = 10

    local boxH = 118
    local boxW = love.graphics.getWidth()-(2*padding)
    local boxX = padding
    local boxY = love.graphics.getHeight()-(boxH+padding)

    local imgX = (boxX+padding)*(1/scale)
    local imgY = (boxY+padding)*(1/scale)
    local imgW = Moan.currentImage:getWidth()
    local imgH = Moan.currentImage:getHeight()

    local fontHeight = Moan.font:getHeight(" ")

    local titleBoxW = Moan.font:getWidth(Moan.currentTitle)+(2*padding)
    local titleBoxH = fontHeight+padding
    local titleBoxX = boxX
    local titleBoxY = boxY-titleBoxH-(padding/2)

    local titleColor = allMessages[Moan.currentMsgInstance].titleColor
    local titleX = titleBoxX+padding
    local titleY = titleBoxY+2

    local textX = (imgX+imgW)/(1/scale)+padding
    local textY = boxY+5

    local optionsY = textY+Moan.font:getHeight(printedText)-(padding/1.6)
    local optionsSpace = fontHeight/1.5

    local msgTextY = textY+Moan.font:getHeight()/1.2
    local msgLimit = boxW-(imgW/(1/scale))-(4*padding)

    local fontColour = { 1, 1, 1, 1 }
    local boxColour = { 0, 0, 0, 0.78431372549 }

    love.graphics.setFont(Moan.font)

    -- Message title
    love.graphics.setColor(boxColour)
    love.graphics.rectangle("fill", titleBoxX, titleBoxY, titleBoxW, titleBoxH)
    love.graphics.setColor(titleColor)
    love.graphics.print(Moan.currentTitle, titleX, titleY)

    -- Main message box
    love.graphics.setColor(boxColour)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
    love.graphics.setColor(fontColour)

    -- Message avatar
    --[[love.graphics.push()
      love.graphics.scale(scale, scale)
      love.graphics.draw(Moan.currentImage, imgX, imgY)
    love.graphics.pop()]]

    -- Message text
    if Moan.autoWrap then
      love.graphics.print(printedText, textX, textY)
    else
      love.graphics.printf(printedText, textX, textY, msgLimit)
    end

    -- Message options (when shown)
    if Moan.showingOptions and typing == false then
      for k, option in pairs(allMessages[Moan.currentMsgInstance].options) do
        -- First option has no Y padding...
        love.graphics.print(option[1], textX+padding, optionsY+((k-1)*optionsSpace))
      end
    end

    -- Next message/continue indicator
    if Moan.showIndicator then
      love.graphics.print(Moan.indicatorCharacter, boxX+boxW-(2.5*padding), boxY+boxH-(padding/2)-fontHeight)
    end
  end

  -- Reset fonts, run debugger if allowed
  love.graphics.setFont(defaultFont)
  Moan.drawDebug()
end

function Moan.keypressed(key)
  -- Lazily handle the keypress
  Moan.keyreleased(key)
end

function Moan.selectPressed()
  if Moan.showingOptions then
    if not typing then
      if Moan.currentMsgKey == #allMessages[Moan.currentMsgInstance].messages-1 then
        -- Execute the selected function
        for i=1, #allMessages[Moan.currentMsgInstance].options do
          if Moan.currentOption == i then
            allMessages[Moan.currentMsgInstance].options[i][2]()
            Moan.playSound(Moan.optionSwitchSound)
          end
        end
      end
      -- Option selection
      elseif key == "down" or key == "s" then
        Moan.currentOption = Moan.currentOption + 1
        Moan.playSound(Moan.optionSwitchSound)
      elseif key == "up" or key == "w" then
        Moan.currentOption = Moan.currentOption - 1
        Moan.playSound(Moan.optionSwitchSound)
      end
      -- Return to top/bottom of options on overflow
      if Moan.currentOption < 1 then
        Moan.currentOption = #allMessages[Moan.currentMsgInstance].options
      elseif Moan.currentOption > #allMessages[Moan.currentMsgInstance].options then
        Moan.currentOption = 1
    end
  end
  -- Check if we're still typing, if we are we can skip it
  -- If not, then go to next message/instance
  if Moan.paused then
    -- Get the text left and right of "--"
    leftSide = string.sub(Moan.currentMessage, 1, string.len(printedText))
    rightSide = string.sub(Moan.currentMessage, string.len(printedText)+3, string.len(Moan.currentMessage))
    -- And then concatenate them, thanks @pfirsich
    Moan.currentMessage = leftSide .. " " .. rightSide
    -- Put the typerwriter back a bit and start up again
    typePosition = typePosition - 1
    typeTimer = 0
  else
    if typing == true then
      -- Skip the typing completely
      printedText = Moan.currentMessage
      typePosition = string.len(Moan.currentMessage)
    else
      Moan.advanceMsg()
    end
  end
end

function Moan.setSpeed(speed)
  if speed == "fast" then
    Moan.typeSpeed = 0.01
  elseif speed == "medium" then
    Moan.typeSpeed = 0.04
  elseif speed == "slow" then
    Moan.typeSpeed = 0.08
  else
    assert(tonumber(speed), "Moan.setSpeed() - Expected number, got " .. tostring(speed))
    Moan.typeSpeed = speed
  end
  -- Update the timeout timer.
  typeTimerMax = Moan.typeSpeed
end

function Moan.setCamera(camToUse)
  Moan.currentCamera = camToUse
end

function Moan.moveCamera()
  -- Only move the camera if one exists
  if Moan.currentCamera ~= nil then
    -- Move the camera to the new instances position
    if (allMessages[Moan.currentMsgInstance].x and allMessages[Moan.currentMsgInstance].y) ~= nil then
      flux.to(Moan.currentCamera, 1, { x = allMessages[Moan.currentMsgInstance].x, y = allMessages[Moan.currentMsgInstance].y }):ease("cubicout")
    end
  end
end

function Moan.setTheme(style)
  for _, setting in pairs(Moan.UI) do
  end
end

function Moan.playSound(sound)
  if type(sound) == "userdata" then
    sound:play()
  end
end

function Moan.clearMessages()
  Moan.showingMessage = false -- Prevents crashing
  Moan.currentMsgKey = 1
  Moan.currentMsgInstance = 1
  allMessages = {}
end

function Moan.drawDebug()
  if Moan.debug == true then
    log = { -- It works...
      "typing", typing,
      "paused", Moan.paused,
      "showOptions", Moan.showingOptions,
      "indicatorTimer", indicatorTimer,
      "showIndicator", Moan.showIndicator,
      "printedText", printedText,
      "textToPrint", Moan.currentMessage,
      "currentMsgInstance", Moan.currentMsgInstance,
      "currentMsgKey", Moan.currentMsgKey,
      "currentOption", Moan.currentOption,
      "currentHeader", utf8.sub(Moan.currentMessage, utf8.len(printedText)+1, utf8.len(printedText)+2),
      "typeSpeed", Moan.typeSpeed,
      "typeSound", type(Moan.typeSound) .. " " .. tostring(Moan.typeSound),
      "allMessages.len", #allMessages,
      --"titleColor", unpack(allMessages[Moan.currentMsgInstance].titleColor)
    }
    for i=1, #log, 2 do
      love.graphics.print(tostring(log[i]) .. ":  " .. tostring(log[i+1]), 10, 7*i)
    end
  end
end

-- External UTF8 functions
-- https://github.com/alexander-yakushev/awesompd/blob/master/utf8.lua
function utf8.charbytes (s, i)
   -- argument defaults
   i = i or 1
   local c = string.byte(s, i)

   -- determine bytes needed for character, based on RFC 3629
   if c > 0 and c <= 127 then
      -- UTF8-1
      return 1
   elseif c >= 194 and c <= 223 then
      -- UTF8-2
      local c2 = string.byte(s, i + 1)
      return 2
   elseif c >= 224 and c <= 239 then
      -- UTF8-3
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      return 3
   elseif c >= 240 and c <= 244 then
      -- UTF8-4
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      local c4 = s:byte(i + 3)
      return 4
   end
end

function utf8.sub (s, i, j)
   j = j or -1

   if i == nil then
      return ""
   end

   local pos = 1
   local bytes = string.len(s)
   local len = 0

   -- only set l if i or j is negative
   local l = (i >= 0 and j >= 0) or utf8.len(s)
   local startChar = (i >= 0) and i or l + i + 1
   local endChar = (j >= 0) and j or l + j + 1

   -- can't have start before end!
   if startChar > endChar then
      return ""
   end

   -- byte offsets to pass to string.sub
   local startByte, endByte = 1, bytes

   while pos <= bytes do
      len = len + 1

      if len == startChar then
   startByte = pos
      end

      pos = pos + utf8.charbytes(s, pos)

      if len == endChar then
   endByte = pos - 1
   break
      end
   end

   return string.sub(s, startByte, endByte)
end

-- ripped from https://github.com/rxi/lume
function Moan.wordwrap(str, limit)
  limit = limit or 72
  local check
  if type(limit) == "number" then
    check = function(s) return #s >= limit end
  else
    check = limit
  end
  local rtn = {}
  local line = ""
  for word, spaces in str:gmatch("(%S+)(%s*)") do
    local s = line .. word
    if check(s) then
      table.insert(rtn, line .. "\n")
      line = word
    else
      line = s
    end
    for c in spaces:gmatch(".") do
      if c == "\n" then
        table.insert(rtn, line .. "\n")
        line = ""
      else
        line = line .. c
      end
    end
  end
  table.insert(rtn, line)
  return table.concat(rtn)
end

return Moan