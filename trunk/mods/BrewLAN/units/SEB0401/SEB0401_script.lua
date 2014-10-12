#****************************************************************************
#**
#**  Summary  :  The Gantry script
#**
#****************************************************************************

local TLandFactoryUnit = import('/lua/terranunits.lua').TLandFactoryUnit 
local explosion = import('/lua/defaultexplosions.lua')

SEB0401 = Class(TLandFactoryUnit) { 
    
    OnCreate = function(self)
        TLandFactoryUnit.OnCreate(self) 
        self.BuildModeChange(self)
    end,
    
    OnStopBeingBuilt = function(self, builder, layer)
        TLandFactoryUnit.OnStopBeingBuilt(self, builder, layer)
    end,
           
    OnLayerChange = function(self, new, old)
        TLandFactoryUnit.OnLayerChange(self, new, old)
        self.BuildModeChange(self)
    end,

    OnScriptBitSet = function(self, bit)
        TLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.airmode = true
            self.BuildModeChange(self)
        end
    end,
             
    OnStartBuild = function(self, unitBeingBuilt, order)
        TLandFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.BuildModeChange(self)
    end,
    
    OnScriptBitClear = function(self, bit)
        TLandFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then	
            self.airmode = false    
            self.BuildModeChange(self)
        end
    end,

    BuildModeChange = function(self, mode)   
        local aiBrain = self:GetAIBrain()
        
        self:RestoreBuildRestrictions()
        
        local engineers = aiBrain:GetUnitsAroundPoint(categories.ENGINEER, self:GetPosition(), 30, 'Ally' )
        local stolentech = {}
        stolentech.CYBRAN = false
        stolentech.AEON = false
        stolentech.SERAPHIM = false
        for k, v in engineers do
            if EntityCategoryContains(categories.TECH3, v) then
                for race, val in stolentech do
                    if EntityCategoryContains(ParseEntityCategory(race), v) then
                        stolentech[race] = true
                    end
                end
            end 
        end
        for race, val in stolentech do
            if not val then
                self:AddBuildRestriction(categories[race])
            end
        end
        
        if aiBrain.BrainType == 'Human' then --Player UI changes.
            if self.airmode then
                self:AddBuildRestriction(categories.NAVAL)
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            else   
                if self:GetCurrentLayer() == 'Land' then
                    self:AddBuildRestriction(categories.NAVAL)
                elseif self:GetCurrentLayer() == 'Water' then
                    self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
                end  
                self:AddBuildRestriction(categories.AIR)
            end
        else --AI's dont need the restrictions that are only there for the sake of a clean UI.
            if self:GetCurrentLayer() == 'Land' then
                self:AddBuildRestriction(categories.NAVAL)
            elseif self:GetCurrentLayer() == 'Water' then
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            end  
        end 
        self:RequestRefreshUI()
    end,

    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        
        # Start build process
        if not self.BuildAnimManip then
            self.BuildAnimManip = CreateAnimator(self)
            self.BuildAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild, true):SetRate(0)
            self.Trash:Add(self.BuildAnimManip)
        end

        self.BuildAnimManip:SetRate(1)
    end,
    
    StopBuildFx = function(self)
        if self.BuildAnimManip then
            self.BuildAnimManip:SetRate(0)
        end
    end,
    
    OnPaused = function(self)
        TLandFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        TLandFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
    
    DeathThread = function(self, overkillRatio, instigator) 
        for i = 1, 8 do
            local r = 1 - 2 * math.random(0,1)
            local a = 'ArmA_00' .. i
            local b = 'ArmB_00' .. i
            local c = 'ArmC_00' .. i
            local d = 'Nozzle_00' .. i
            self:ForkThread(self.Flailing, a, math.random(10,20), 'z', r)
            self:ForkThread(self.Flailing, b, math.random(25,45), 'x', r)
            self:ForkThread(self.Flailing, c, math.random(30,45), 'x', r)
            self:ForkThread(self.Flailing, d, math.random(35,45), 'x', r)
        end
        TLandFactoryUnit.DeathThread(self, overkillRatio, instigator)
    end,
    
    Flailing = function(self, bone, a, d, r)     
        local rotator = CreateRotator(self, bone, d) 
        self.Trash:Add(rotator)    
        rotator:SetGoal(a*r)
        local b = a*5
        local c = a*15
        rotator:SetSpeed(math.random(b,c)) 
        WaitFor(rotator)
        local m = 1
        local l = (a+a)*(r*-1)
        local i = (a+a)*r
        while true do 
            local f = math.random(b*m,c*m)          
            m = m + (math.random(1,2)/10)
            rotator:SetGoal(l)
            rotator:SetSpeed(f)
            WaitFor(rotator)   
            rotator:SetGoal(i)
            rotator:SetSpeed(f)
            if f > 1000 then
                self.effects = {
                    '/effects/emitters/terran_bomber_bomb_explosion_06_emit.bp',
                    '/effects/emitters/flash_05_emit.bp',
                    '/effects/emitters/destruction_explosion_fire_01_emit.bp',
                    '/effects/emitters/destruction_explosion_fire_plume_01_emit.bp',
                }
                for k, v in self.effects do  
                    CreateEmitterAtBone(self, bone, self:GetArmy(), v)
                end    
                self:Fling(bone, f) 
                f = 0
            end
            WaitFor(rotator)
        end
    end,
    
    Fling = function(self, bone)
        --[[
        local spinner = CreateRotator()
        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        self.detector:WatchBone(bone)
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()
        --]]      
        self:HideBone(bone, true)
    end, 
    --[[
    OnAnimTerrainCollision = function(self, bone,x,y,z)
        DamageArea(self, {x,y,z}, 1, 250, 'Default', true, false)
        explosion.CreateDefaultHitExplosionAtBone( self, bone, 1.0 )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
    end,
    --]]
}

TypeClass = SEB0401