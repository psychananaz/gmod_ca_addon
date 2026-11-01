concommand.Add("pa_test", function(ply, cmd, args)
    ent_all = ents.GetAll()
    for _, ent in ipairs(ent_all) do
        print(ent)
    end
end)