PsyAddon.Color = Color(211, 133, 188)
function PsyAddon.Print(...)
    MsgC(PsyAddon.Color, "[PsyAddon] ", SERVER and "[SV] " or "[CL] ", color_white, ...)
    MsgC("\n")
end

helper = helper or {}
function helper.StringMatch(str, substr, isolated)
    if isolated then
        return string.match(str, "%f[%w]" .. substr .. "%f[%W]") ~= nil
    else
        return string.find(str, substr, 1, true) ~= nil
    end
end