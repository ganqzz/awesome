local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

-- MPRIS controller service
local mpris = {
    player_list = nil,
    current_player = "",
    step = 5,
    timeout = 5,
}

-- Get current player information
local CMD_STS =
[[playerctl -f '{{status}};{{xesam:title}};{{xesam:artist}};{{xesam:album}};{{mpris:length}};{{mpris:artUrl}}' metadata]]

-- private variables
local old_stdout = nil
local timer = nil

local function notify(stdout)
    if stdout == old_stdout then return end
    old_stdout = stdout
    local player_info = {
        status = "Unknown",
        title = "",
        artist = "",
        album = "",
        length = 0,
        art_url = "",
    }
    if stdout ~= nil and stdout ~= "" then
        local words = gears.string.split(stdout, ";")
        if words[1] ~= nil or words[1] ~= "" then
            player_info.status = words[1]
            if player_info.status ~= "Stopped" then
                player_info.title = words[2]
                player_info.artist = words[3]
                player_info.album = words[4]
                player_info.length = tonumber(words[5])
                player_info.art_url = words[6]
            end
        end
    end
    awesome.emit_signal("mpris::update", player_info)
end

-- public functions

function mpris.prev()
    awful.spawn.easy_async_with_shell("playerctl previous;" .. CMD_STS, notify)
end

function mpris.next()
    awful.spawn.easy_async_with_shell("playerctl next;" .. CMD_STS, notify)
end

function mpris.play_pause()
    awful.spawn.easy_async_with_shell("playerctl play-pause;" .. CMD_STS, notify)
end

--[[ function mpris.refresh_player_list()
    awful.spawn.easy_async("playerctl -l", function(stdout)
        local t = {}
        for player in stdout:gmatch("[^\n]+") do
            if player ~= nil and player ~= "" then
                -- set the first player as the current if not set
                if mpris.current_player == "" then mpris.current_player = player end
                table.insert(t, player)
            end
        end
        mpris.player_list = t
    end)
end

function mpris.get_player_list()
    return mpris.player_list
end ]]

-- Start timer
function mpris.start()
    if not timer then
        timer = helpers.watch(CMD_STS, mpris.timeout, notify)
    end
end

return mpris
