hook.Add("PlayerSay", "PsyAddon_PlayerSay", function(ply, text, team)
    local triggers = {"boom", "kaboom", "superboom", "megaboom"}
    local base_magnitude = 50
    local shouldExplode = false
    local index = nil
    for i, trigger in ipairs(triggers) do
        if helper.StringMatch(text, trigger, true) then
            shouldExplode = true
            index = i
            break
        end
    end

    if shouldExplode then
        local magnitude = base_magnitude * (2.0 ^ (index - 1))
        local explosion = ents.Create("env_explosion")
        explosion:SetOwner(ply)
        explosion:SetPos(ply:GetPos())
        explosion:Spawn()
        explosion:SetKeyValue("iMagnitude", tostring(magnitude))
        explosion:SetKeyValue("DamageForce", tostring(magnitude * magnitude)) -- physical force, not damage
        explosion:Fire("Explode", "", 0)
        PsyAddon.Print(ply:Nick() .. " triggered an explosion with magnitude " .. magnitude)
    end
end)

CreateConVar("psyaddon_max_redo_entities", "20", FCVAR_ARCHIVE, "How many entities a single redo can have")
CreateConVar("psyaddon_stack_limit", "10", FCVAR_ARCHIVE, "How many undos to keep")

util.AddNetworkString("PsyAddon_RedoToast")

hook.Add("PreUndo", "PsyAddon_PreUndo", function(utable)
    local entities = utable.Entities
    local ply = utable.Owner

    if not entities or not IsValid(ply) then return end 
    if #entities > GetConVar("psyaddon_max_redo_entities"):GetInt() then return end

    local dupeData = duplicator.CopyEnts(entities)
    if not dupeData then return end

    PsyAddon.RedoStack = PsyAddon.RedoStack or {}
    local stack = PsyAddon.RedoStack[ply] or {}
    PsyAddon.RedoStack[ply] = stack
    table.insert(stack, dupeData)
    if #stack > GetConVar("psyaddon_stack_limit"):GetInt() then table.remove(stack, 1) end
end)

concommand.Add("psyaddon_redo", function(ply)
    if not IsValid(ply) then return end

    -- get redo stack for player
    local stack = PsyAddon.RedoStack and PsyAddon.RedoStack[ply]
    if not stack or #stack == 0 then return end

    -- get last dupe from stack
    local dupeData = table.remove(stack, #stack)
    local entCount = table.Count(dupeData.Entities)
    local firstEntData = next(dupeData.Entities) and dupeData.Entities[next(dupeData.Entities)]

    local undoName = "Redo"
    if entCount > 1 then
        undoName = "Duplication (" .. entCount .. ")"
    elseif firstEntData then
        undoName = firstEntData.Class 
    end


    undo.Create(undoName)
        local spawned = duplicator.Paste(ply, dupeData.Entities, dupeData.Constraints)
        for _, ent in pairs(spawned or {}) do
            if IsValid(ent) then
                undo.AddEntity(ent)
            end
        end

        undo.SetPlayer(ply)
    undo.Finish()

    net.Start("PsyAddon_RedoToast")
        net.WriteString(undoName)
    net.Send(ply)
end)

concommand.Add("psyaddon_clearredo", function(ply)
    if not IsValid(ply) then return end
    PsyAddon.RedoStack[ply] = nil
end)

concommand.Add("psyaddon_stack", function(ply)
    if not IsValid(ply) then return end
    print("Stack size: " .. (#(PsyAddon.RedoStack and PsyAddon.RedoStack[ply] or {})))
end)
