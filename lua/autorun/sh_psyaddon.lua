PsyAddon = PsyAddon or {}
if SERVER then
    AddCSLuaFile("psyaddon/shared.lua")
    AddCSLuaFile("psyaddon/cl_cmds.lua")
    include("psyaddon/shared.lua")
else
    include("psyaddon/shared.lua")
    include("psyaddon/cl_cmds.lua")
    include("psyaddon/cl_hooks.lua")
end

PsyAddon.Print("psyaddon loaded")