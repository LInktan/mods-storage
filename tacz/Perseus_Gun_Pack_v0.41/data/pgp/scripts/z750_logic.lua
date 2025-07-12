local M = {}

function M.shoot(api)
    if(api:getFireMode() == AUTO)then
        api:shootOnce(api:isShootingNeedConsumeAmmo() == FALSE)
    end
    if(api:getFireMode() == BURST)then
        api:shootOnce(api:isShootingNeedConsumeAmmo())
    end
    if(api:getFireMode() == SEMI)then
        api:shootOnce(api:isShootingNeedConsumeAmmo())
    end
end
function M.start_reload(api)
    local cache = {
        reloaded_flag = 0,
        max_ammo = 16,
        needed_count = api:getNeededAmmoAmount()
    }
    api:cacheScriptData(cache)
end

function M.tick_reload(api)
    local cache = api:getCachedScriptData()
    local reload_feed = 5 * 1000
    local reload_cooldown = 5.25 * 1000
    local need_ammo = api:getNeededAmmoAmount()
    local reload_time = api:getReloadTime()
    --reload
    if (cache.reloaded_flag == 0) then
        if(reload_time >= reload_feed and reload_time < reload_cooldown) then
            api:putAmmoInMagazine(cache.max_ammo)
            cache.reloaded_flag = 1
            return TACTICAL_RELOAD_FINISHING, reload_cooldown - reload_time
        elseif(reload_time >= reload_cooldown) then
            return NOT_RELOADING, -1
        elseif(reload_time < reload_feed) then
            return TACTICAL_RELOAD_FEEDING, reload_feed - reload_time
        end
    elseif(cache.reloaded_flag == 1)then
        if(reload_time >= reload_cooldown)then
            return NOT_RELOADING, -1
        else 
            return TACTICAL_RELOAD_FINISHING, reload_cooldown - reload_time
        end
    end
    -- regular return
    return NOT_RELOADING, -1
end

function M.start_bolt(api)
    return true
end

return M