PsyAddon = PsyAddon or {}
if SERVER then
    include("psyaddon/shared/shared.lua")
    include("psyaddon/server/sv_hooks.lua")
    AddCSLuaFile("psyaddon/client/cl_hooks.lua")
    AddCSLuaFile("psyaddon/shared/shared.lua")
else
    include("psyaddon/shared/shared.lua")
    include("psyaddon/client/cl_hooks.lua")
end

PsyAddon.Print("psyaddon loaded")