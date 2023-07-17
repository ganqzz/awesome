--
-- Scratchpad
--
local gears = require("gears")
local awful = require("awful")
local awesome = awesome
local client = client

-- Find the first client that meets the rule
local function find_client(rule)
    for _, c in pairs(client.get()) do
        if c and c.valid and awful.rules.match(c, rule) then
            return c
        end
    end
    return nil
end

-- scratchpad registry
--   `name`: `scratchpad`
local registry = {}

-- scratchpad prototype
local scratchpad = {}

-- Create and register scratchpad
function scratchpad.add(args)
    registry[args.name] = scratchpad._new(args)
end

-- Get scratchpad by name
function scratchpad.get(name)
    return registry[name]
end

-- Hide all scratchpads
function scratchpad.hide_all()
    for _, spad in pairs(registry) do
        spad:hide()
    end
end

-- Set client geometry
function scratchpad:set_geom()
    local wa = awful.screen.focused().workarea
    local geom = {
        width = self.geometry.width,
        height = self.geometry.height,
    }
    if self.center then
        geom.x = wa.x + (wa.width - self.geometry.width) / 2
        geom.y = wa.y + (wa.height - self.geometry.height) / 2
    else
        geom.x = wa.x + self.geometry.x
        geom.y = wa.y + self.geometry.y
    end
    self.client:geometry(geom)
end

-- Show scratchpad (internal)
function scratchpad:_show()
    local c = self.client
    c.sticky = self.sticky
    c.ontop = self.ontop
    c.floating = true
    c.fullscreen = false
    c.maximized = false
    c.minimized = false
    c.hidden = false

    -- bring the client to the current tag
    c:tags({ awful.screen.focused().selected_tag })
    c:raise()
    client.focus = c
end

-- Hide scratchpad (internal)
function scratchpad:_hide()
    self.client.sticky = false -- must be false on hiding the client
    self.client.hidden = true
    self.client:tags({})       -- delete all tags from the client
end

-- Attach the client and register signals
function scratchpad:attach_client(c, hidden)
    self.client = c

    if self.autohide then
        c:connect_signal("unfocus", function()
            self:_hide()
        end)
    end

    -- When the client closed, dettach it
    c:connect_signal("unmanage", function()
        self.client = nil
    end)

    -- Reset geometry because `restart` forgets the last geometry
    self:set_geom()

    if hidden then
        self:_hide()
    else
        self:_show()
    end
end

-- Spawn new client
function scratchpad:spawn_client(hidden)
    local function on_manage(c)
        if awful.rules.match(c, self.rule) then
            self:attach_client(c, hidden)
            client.disconnect_signal("manage", on_manage) -- one shot
        end
    end
    client.connect_signal("manage", on_manage)
    awful.spawn(self.command) -- async
end

-- Show scratchpad (public)
function scratchpad:show()
    if self.client then
        self:_show()
    else
        local c = find_client(self.rule)
        if c then
            -- client found, attach it
            self:attach_client(c)
        else
            -- otherwise, spawn new client
            self:spawn_client()
        end
    end
end

-- Hide scratchpad (public)
function scratchpad:hide()
    if self.client then
        self:_hide()
    end
end

-- Toggle scratchpad
function scratchpad:toggle()
    if self.client and self.client.first_tag and client.focus == self.client then
        self:_hide()
    else
        self:show()
    end
end

-- Factory
function scratchpad._new(args)
    args = args or {}
    if not args.name or not args.command then
        error("scratchpad: `name` and `command` arguments are required")
        return
    end

    local obj = {
        rule = args.rule or { instance = args.name },
        sticky = false,
        ontop = false,
        autohide = false,
        center = true,
        geometry = { width = 800, height = 600, x = 100, y = 100 },
    }
    gears.table.crush(obj, args)
    gears.table.crush(obj, scratchpad)

    return obj
end

-- After `restart`, re-attach all the existing scratchpad clients
awesome.connect_signal("startup", function()
    for _, spad in pairs(registry) do
        local c = find_client(spad.rule)
        if c then
            spad:attach_client(c, true)
        end
    end
end)

return scratchpad
