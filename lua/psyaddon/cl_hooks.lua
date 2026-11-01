hook.Add("PlayerSay", "PsyAddon_PlayerSay", function(ply, text, public)
    if string.lower(text) == "!test" then
        ent_all = ents.GetAll()
        for _, ent in ipairs(ent_all) do
            print(ent)
        end
    end
end)