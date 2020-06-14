--
-- Copyright (c) 2020 lalawue
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

-- clean text from http://www.sogou.com/labs/, before feed in GloVe

require("base.scratch")
local LacCore = require("middle.thulac")
local FileManager = require("middle.file_manager")

local argFile = ...

local CleanText = {}
CleanText.__index = CleanText

function CleanText:initLacCore()
    self.lac = LacCore.newLac("lib/models", "data/user_words.txt", 0, 0, 0)
    assert(self.lac)
end

function CleanText:loadContent(filename)
    self.content = FileManager.readAllContent(filename)
    return self.content ~= nil
end

function CleanText:nextTagContent(tag)
    self.iter = self.iter or 1
    local pattern = string.format("<%s>([^<]-)</%s>", tag, tag)
    local s, e = self.content:find(pattern, self.iter)
    if s and e then
        self.iter = e + 1
        local tag_len = tag:len()
        return self.content:sub(s + tag_len + 2, e - tag_len - 3)
    end
    return nil
end

local dummy_tbl = {}

function CleanText:nextBlock()
    local url = self:nextTagContent("url")
    local content = self:nextTagContent("content")
    if url == nil and content == nil then
        return nil
    elseif url:len() > 0 and content:len() > 0 then
        return {url, self:cleanString(content)}
    else
        return dummy_tbl
    end
end

function CleanText:cleanString(content)
    content = content:gsub("", "")
    return content
end

local skip_words_tbl =
    table.readonly(
    {
        ["e"] = true,
        ["o"] = true,
        ["u"] = true,
        ["y"] = true,
        ["w"] = true,
        ["x"] = true,
        ["m"] = true,
        ["q"] = true,
        ["mq"] = true
    }
)

function CleanText:segContent(content)
    --[[
n/名词 np/人名 ns/地名 ni/机构名 nz/其它专名
m/数词 q/量词 mq/数量词 t/时间词 f/方位词 s/处所词
v/动词 a/形容词 d/副词 h/前接成分 k/后接成分 i/习语
j/简称 r/代词 c/连词 p/介词 u/助词 y/语气助词
e/叹词 o/拟声词 g/语素 w/标点 x/其它
    ]]
    local count = self.lac:seg(content)
    for i = 1, count, 1 do
        local word, tag = self.lac:fetch(i)
        if not skip_words_tbl[tag] then
            io.write(word, " ")
        end
    end
end

--
--
local ct = setmetatable({}, CleanText)
if not ct:loadContent(argFile) then
    os.exit(1)
else
    ct:initLacCore()
end

local tbl = nil
repeat
    tbl = ct:nextBlock()
    if tbl and #tbl > 0 then
        local url = tbl[1]
        if not url:find("auto.sohu.com") then
            --print(tbl[2])
            ct:segContent(tbl[2])
        end
    end
until tbl == nil
