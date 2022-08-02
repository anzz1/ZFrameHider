local addOnName = ...
local addOnVersion = GetAddOnMetadata(addOnName, "Version") or "0.0.1"

ZFH_G = {}
ZFH_C = {}
ZFH_Silent = false

local function zfh_init()
    local hframes = ""
    for i=1,#ZFH_G do
        if (_G[ZFH_G[i]] and _G[ZFH_G[i]].Hide) then
            _G[ZFH_G[i]]:HookScript("OnShow", function(self) self:Hide() end)
            _G[ZFH_G[i]]:Hide()
            hframes = hframes .. ",\"" .. ZFH_G[i] .. "\""
        else
            DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Frame \"|c00ffffff" .. ZFH_G[i] .. "|r\" was not found and could not be hidden.", 1.0, 0.2, 0.2)
        end
    end
    for i=1,#ZFH_C do
        if (_G[ZFH_C[i]] and _G[ZFH_C[i]].Hide) then
            _G[ZFH_C[i]]:HookScript("OnShow", function(self) self:Hide() end)
            _G[ZFH_C[i]]:Hide()
            hframes = hframes .. ", \"" .. ZFH_C[i] .. "\""
        else
            DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Frame \"|c00ffffff" .. ZFH_C[i] .. "|r\" was not found and could not be hidden.", 1.0, 0.2, 0.2)
        end
    end
    if (not ZFH_Silent and hframes ~= "") then
        DEFAULT_CHAT_FRAME:AddMessage("[|c00bfffffZFrameHider|r] Hidden frames:|c00ffffff " .. string.sub(hframes, 2) .. "|r", 0.0, .8, 1)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    local addon = ...
    if (addon == addOnName) then
        f:UnregisterEvent("ADDON_LOADED")
        zfh_init()
    end
end)

SLASH_ZFRAMEHIDER1 = "/zframehider"
SLASH_ZFRAMEHIDER2 = "/framehider"
SLASH_ZFRAMEHIDER3 = "/framehide"
SLASH_ZFRAMEHIDER4 = "/zfh"
SlashCmdList["ZFRAMEHIDER"] = function (msg)
    msg = { string.split(" ", msg) }
    if (#msg > 0) then
        local cmd = string.lower(msg[1])
        if (cmd == "list") then
            DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Frame hide list", 0.0, .80, 1)
            DEFAULT_CHAT_FRAME:AddMessage("Global:", 0.0, .80, 1)
            if (#ZFH_G == 0) then
                DEFAULT_CHAT_FRAME:AddMessage("empty", 1, 1, 1)
            else
                for i=1,#ZFH_G do
                    DEFAULT_CHAT_FRAME:AddMessage("[#|c00bfffff" .. i .. "|r]|c00ffffff " .. ZFH_G[i], 0.0, .80, 1)
                end
            end
            DEFAULT_CHAT_FRAME:AddMessage("Per Character:", 0.0, .80, 1)
            if (#ZFH_C == 0) then
                DEFAULT_CHAT_FRAME:AddMessage("empty", 1, 1, 1)
            else
                for i=1,#ZFH_C do
                    DEFAULT_CHAT_FRAME:AddMessage("[#|c00bfffff" .. i .. "|r]|c00ffffff " .. ZFH_C[i], 0.0, .80, 1)
                end
            end
            return
        end
        if (cmd == "add") then
            local c
            if (#msg > 2) then
                c = string.lower(string.sub(msg[2], 1, 1))
            end
            if (c == "g" or c == "c") then
                local global = (c == "g")
                if (not tContains(global and ZFH_G or ZFH_C, msg[3])) then
                    table.insert(global and ZFH_G or ZFH_C, msg[3])
                end
                DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Added \"|c00bfffff" .. msg[3] .. "|r\" to frame hide list " .. (global and "(global)" or "(character)"), 0.0, .8, 1)
            else
                DEFAULT_CHAT_FRAME:AddMessage("Usage:", 0.0, .80, 1)
                DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh add <global/character> <name>|r: Add frame to hide list.", 0.0, .80, 1)
            end
            return
        end
        if (cmd == "del") then
            local c
            if (#msg > 2) then
                c = string.lower(string.sub(msg[2], 1, 1))
            end
            if (c == "g" or c == "c") then
                local global = (c == "g")
                local i
                if (string.sub(msg[3], 1, 1) == "#") then
                    i = tonumber(string.sub(msg[3], 2))
                else
                    i = tonumber(msg[3]) or tContains(global and ZFH_G or ZFH_C, msg[3])
                end
                if (i and i <= (global and #ZFH_G or #ZFH_C)) then
                    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Removed \"|c00bfffff" .. (global and ZFH_G[i] or ZFH_C[i]) .. "|r\" from frame hide list " .. (global and "(global)" or "(character)"), 0.0, .8, 1)
                    table.remove(global and ZFH_G or ZFH_C, i)
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Item " .. (tonumber(msg[3]) and ("id #|c00bfffff" .. msg[3] .. "|r") or ("\"|c00bfffff" .. msg[3] .. "|r\"")) .. " was not found in your " .. (global and "global" or " per character") .. " hide list.", 0.0, .8, 1)
                end
            else
                DEFAULT_CHAT_FRAME:AddMessage("Usage:", 0.0, .80, 1)
                DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh del <global/character> <name/#id>|r: Remove frame from hide list.", 0.0, .80, 1)
            end
            return
        end
        if (cmd == "purge") then
            ZFH_G = {}
            ZFH_C = {}
            DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Frame hide lists cleared.", 0.0, .8, 1)
            return
        end
        if (cmd == "silent") then
            if (msg[2]) then
                local i = tonumber(msg[2])
                local s = string.lower(msg[2])
                if (i == 1 or s == "on" or s == "true") then
                    ZFH_Silent = true
                elseif (i == 0 or s == "off" or s == "false") then
                    ZFH_Silent = false
                else
                    ZFH_Silent = not ZFH_Silent
                end
            else
                ZFH_Silent = not ZFH_Silent
            end
            DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r: Silent operation set to: " .. (ZFH_Silent and "|c0090ee90On|r" or "|c00ff4040Off|r"), 0.0, .8, 1)
            return
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffffZFrameHider|r v" .. addOnVersion .. " by kebabstorm", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh add global <name>|r: Add frame to global hide list.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh add character <name>|r: Add frame to per character hide list.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh del global <name/#id>|r: Remove frame from global hide list.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh del character <name/#id>|r: Remove frame from per character hide list.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh list|r: List all hidden frames.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh purge|r: Clear everything from your hide lists.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("|c00bfffff/zfh silent|r: Toggle login message.", 0.0, .80, 1)
    DEFAULT_CHAT_FRAME:AddMessage("Use /fstack to scout the names of frames you want hidden.", 0.0, .80, 1)
end
