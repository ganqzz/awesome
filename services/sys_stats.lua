local awful = require("awful")
local helpers = require("helpers")
local awesome = awesome

-- data store
local data = { cores = {}, freq = 0, }

-- gather sysinfo at startup
data.min_freq = 0.8
data.max_freq = 3.3

-- services
local cpu = {
    timeout = 2,
    _timer = nil,
}

local mem = {
    timeout = 5,
    _timer = nil,
}

local net = {
    interface = "*",
    timeout = 2,
    _timer = nil,
}

-- CPU
local function collect()
    local i = 1
    for line in io.lines("/proc/stat") do
        if string.sub(line, 1, 3) ~= "cpu" then break end

        local core = data.cores[i] or { active = 0, total = 0, usage = 0 }
        local idle, total = 0, 0

        local j = 1
        for field in string.gmatch(line, "%s+(%d+)") do
            if j == 4 or j == 5 then -- 4: idle, 5: io wait
                idle = idle + field
            end
            total = total + field
            j = j + 1
        end

        local active = total - idle

        if core.active ~= active or core.total ~= total then
            -- Calculate delta values
            local dactive = active - core.active
            local dtotal  = total - core.total
            local usage   = (dactive / dtotal) * 100

            -- Save current values
            core.active   = active
            core.total    = total
            core.usage    = usage
            data.cores[i] = core
        end
        i = i + 1
    end

    -- CPU Frequency
    -- local freq = 0
    -- for line in io.lines("/proc/cpuinfo") do
    --     repeat  -- `continue` trick
    --         if string.sub(line, 1, 7) ~= "cpu MHz" then break end
    --         freq = math.max(freq, tonumber(string.match(line, ":%s(%d+%.%d+)")) / 1000)  -- GHz
    --     until true
    -- end
    -- data.freq = freq

    return data
end

function cpu.start()
    if not cpu._timer then
        cpu._timer = helpers.start_timer_task(cpu.timeout, function()
            awesome.emit_signal("cpu_stats::update", collect())
        end)
    end
end

awesome.connect_signal("cpu_stats::start", cpu.start)

-- Memory
function mem.start()
    if not mem._timer then
        mem._timer = helpers.watch('sh -c "LANG=C free"', mem.timeout, function(stdout)
            local total, used = string.match(stdout, '(%d+)%s+(%d+)')
            awesome.emit_signal("mem_stats::update", { total = total, used = used })
        end)
    end
end

awesome.connect_signal("mem_stats::start", mem.start)

-- Network
function net.start()
    if not net._timer then
        local prev_rx, prev_tx
        net._timer = helpers.watch(
            string.format([[sh -c "cat /sys/class/net/%s/statistics/*_bytes"]], net.interface),
            net.timeout,
            function(stdout)
                local cur_vals = helpers.split(stdout, "\n")
                local cur_rx, cur_tx = 0, 0
                local rx_speed, tx_speed = 0, 0

                for i, v in ipairs(cur_vals) do
                    if i % 2 == 1 then cur_rx = cur_rx + v end
                    if i % 2 == 0 then cur_tx = cur_tx + v end
                end

                if prev_rx and prev_tx then
                    rx_speed = (cur_rx - prev_rx) / net.timeout
                    tx_speed = (cur_tx - prev_tx) / net.timeout
                end
                prev_rx, prev_tx = cur_rx, cur_tx
                awesome.emit_signal("net_stats::update", rx_speed, tx_speed)
            end)
    end
end

awesome.connect_signal("net_stats::start", net.start)

-- Module
return {
    cpu = cpu,
    mem = mem,
    net = net,
}
