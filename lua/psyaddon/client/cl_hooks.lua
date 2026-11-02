net.Receive("PsyAddon_RedoToast", function()
    local name = net.ReadString()
    notification.AddLegacy("Redid \"" .. name .. "\"", NOTIFY_UNDO, 3)
    surface.PlaySound("ui/buttonclick.wav")
end)

hook.Add("EntityFireBullets", "PsyAddon_EntityFire", function() 
    print("Bullet fired")
end)