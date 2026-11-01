PsyAddon.Color = Color(100, 200, 255)
function PsyAddon.Print(...)
    MsgC(Color(100, 200, 255), "[PsyAddon] ", SERVER and "[SV] " or "[CL] ", color_white, ...)
    MsgC("\n")
end