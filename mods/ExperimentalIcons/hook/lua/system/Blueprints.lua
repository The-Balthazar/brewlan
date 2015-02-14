--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    ExperimentalIconOverhaul(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Icon modifications the hardcore way. May make a UI only version later. 
--------------------------------------------------------------------------------

function ExperimentalIconOverhaul(all_bps)
    local units = {
        --ssb5401 = 'icon_experimental_structure_transport',
    }
    for id, bp in all_bps do
        ------------------------------------------------------------------------
        -- Check for pre-defined overrides
        ------------------------------------------------------------------------
        if bp.StrategicIconName == 'icon_experimental_generic' and (bp.StrategicIconNameEIOOverride or units[id]) then
            bp.StrategicIconName = units[id] or bp.StrategicIconNameEIOOverride
        end
        if bp.StrategicIconName == 'icon_experimental_generic' then
            local icon = 'icon_experimental_'
            --------------------------------------------------------------------
            -- Define background shape 
            --------------------------------------------------------------------
            if table.find(bp.Categories, 'AIR') and table.find(bp.Categories, 'MOBILE') then
                if bp.Air.Winged then
                    icon = icon .. 'bomber_'
                elseif not bp.Air.Winged then
                    icon = icon .. 'gunship_'
                end
            elseif table.find(bp.Categories, 'STRUCTURE') and bp.Physics.MotionType == 'RULEUMT_None' then
                if table.find(bp.Categories, 'FACTORY') then
                    icon = icon .. 'factory_'
                else
                    icon = icon .. 'structure_'
                end
            elseif table.find(bp.Categories, 'NAVAL') and table.find(bp.Categories, 'MOBILE') then
                if table.find(bp.Categories, 'SUBMERSIBLE') then
                    icon = icon .. 'sub_'
                else
                    icon = icon .. 'ship_'
                end    
            elseif table.find(bp.Categories, 'LAND') and table.find(bp.Categories, 'MOBILE') then
                if table.find(bp.Categories, 'FACTORY') then
                    icon = icon .. 'mobilefactory_'
                else
                    icon = icon .. 'land_'
                end
            end
            --------------------------------------------------------------------
            -- Define the foreground icon
            --------------------------------------------------------------------
            local iconbackup = icon
            if table.find(bp.Categories, 'FIELDENGINEER') or table.find(bp.Categories, 'ENGINEER') then
                icon = icon .. 'engineer'
            elseif table.find(bp.Categories, 'TRANSPORTATION') then
                icon = icon .. 'transport'
            elseif table.find(bp.Categories, 'ARTILLERY') then
                icon = icon .. 'artillery'
            elseif table.find(bp.Categories, 'ANTIARTILLERY') then
                icon = icon .. 'antiartillery'
            elseif table.find(bp.Categories, 'DIRECTFIRE') or table.find(bp.Categories, 'GROUNDATTACK') or table.find(bp.Categories, 'ANTIAIR') or table.find(bp.Categories, 'ANTINAVY') then
                local layer = {
                    air = {0, 'antiair'},
                    land = {0, 'directfire'}, 
                    naval = {0, 'antinavy'},
                }
                --FIGHT FOR YOUR ICON! LITERALLY!
                for i, weapon in bp.Weapon do
                    local function DPS(weapon)
                        return (math.pow(weapon.Damage or 0, 1.2)) * (weapon.RateOfFire or 1) * ((weapon.ProjectilesPerOnFire or weapon.MuzzleSalvoSize) or 1) * (10 / (weapon.BeamCollisionDelay or 10))
                    end
                    if string.find(weapon.WeaponCategory, 'Anti Air') or weapon.RangeCategory == 'UWRC_AntiAir' then
                        layer.air[1] = layer.air[1] + DPS(weapon)
                    elseif (string.find(weapon.WeaponCategory, 'Direct Fire') or string.find(weapon.WeaponCategory, 'Bomb')) or weapon.RangeCategory == 'UWRC_DirectFire' then
                        layer.land[1] = layer.land[1] + DPS(weapon)
                    elseif string.find(weapon.WeaponCategory, 'Anti Navy') or weapon.RangeCategory == 'UWRC_AntiNavy' then
                        layer.naval[1] = layer.naval[1] + DPS(weapon)
                    end
                end
                local best = {0, 'directfire'}
                for l, data in layer do
                    if data[1] > best[1] then best = data end
                end
                icon = icon .. best[2]
            elseif table.find(bp.Categories, 'NUKE') or table.find(bp.Categories, 'MISSILE') or table.find(bp.Categories, 'SILO') then
                icon = icon .. 'missile'     
            elseif table.find(bp.Categories, 'ANTIMISSILE') then
                icon = icon .. 'antimissile'
            elseif table.find(bp.Categories, 'ECONOMIC') then
                if table.find(bp.Categories, 'MASSPRODUCTION') or table.find(bp.Categories, 'MASSFABRICATION') then
                    icon = icon .. 'mass'
                elseif table.find(bp.Categories, 'ENERGYPRODUCTION') then
                    icon = icon .. 'energy'
                else
                    icon = icon .. 'generic'
                end
            elseif table.find(bp.Categories, 'CARRIER') or table.find(bp.Categories, 'AIRSTAGINGPLATFORM') then
                icon = icon .. 'air'
            elseif table.find(bp.Categories, 'FACTORY') then
                local buildlayers = {
                    'LAND',
                    'AIR',
                    'NAVAL',
                }
                local bits = {'0','0','0'}
                if bp.Economy.BuildableCategory[1] then 
                    for i, layer in buildlayers do   
                        for _, buildcat in bp.Economy.BuildableCategory do
                            if string.find(buildcat, layer) then
                                bits[i] = '1'
                                break
                            end
                        end
                    end
                end
                local sbits = table.concat(bits)
                if sbits == '100' then
                    icon = icon .. 'land'
                elseif sbits == '010' then
                    icon = icon .. 'air'
                elseif sbits == '001' then
                    icon = icon .. 'naval'
                else  
                    icon = icon .. 'generic'
                end
            elseif table.find(bp.Categories, 'DEFENSE') and table.find(bp.Categories, 'SHIELD') then
                icon = icon .. 'shield'
            elseif table.find(bp.Categories, 'ANTISHIELD') then
                icon = icon .. 'antishield'
            elseif table.find(bp.Categories, 'COUNTERINTELLIGENCE') then
                icon = icon .. 'counterintel'
            elseif table.find(bp.Categories, 'STARGATE') then
                icon = icon .. 'transport'
            else
                local bomb = false
                if bp.Weapon then
                    for i, weapon in bp.Weapon do
                        if string.find(weapon.WeaponCategory, 'Kamikaze') then
                            bomb = true
                            break  
                        end
                    end
                end
                if bomb then
                    icon = icon .. 'bomb'
                else
                    icon = icon .. 'generic'
                end
            end
            bp.StrategicIconName = icon
        end
    end
end

end