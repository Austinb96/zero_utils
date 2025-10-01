function zutils.physicsThread(fn, start_paused)
    local thread = {
        running = false,
    }
    
    local _pcall = pcall
    local _GetGameTimer = GetGameTimer
    local _Wait = Wait
    function thread:start()
        if self.running then
            printwarn("PhysicsThread is already running.")
            return
        end

        self.running = true
        local last_time = GetGameTimer()
        CreateThread(function()
            while self.running do
                local current_time = _GetGameTimer()
                local delta = (current_time - last_time) / 1000
                last_time = current_time
                local success, err = _pcall(fn, delta)
                if not success then
                    printerr("Error in PhysicsThread callback: %s", err)
                    self:pause()
                end
                _Wait(0)
            end
            printdb("PhysicsThread stopped.")
        end)
    end
    function thread:pause()
        self.running = false
    end
    
    if not start_paused then
        thread:start()
    end
    
    return thread
end

return zutils.physicsThread
