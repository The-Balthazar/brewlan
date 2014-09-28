#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local CLandFactoryUnit = import('/lua/cybranunits.lua').CLandFactoryUnit    

SRB5310 = Class(CLandFactoryUnit) {        
    BuildAttachBone = 'WallNode',    
    OnCreate = function(self,builder,layer)      
        self:AddBuildRestriction(categories.ANTINAVY)
        CLandFactoryUnit.OnCreate(self,builder,layer)    
        self.Info = {
            ents = {
                northUnit = {
                    ent = {},
                    val = false,
                },
                southUnit = {
                    ent = {},
                    val = false,
                },
                eastUnit = {
                    ent = {},
                    val = false,
                },
                westUnit = {
                    ent = {},
                    val = false,
                },
            },
            bones = self:GetBlueprint().Display.AdjacencyConnectionInfo.Bones
        }
        self:BoneUpdate(self.Info.bones)  
        self:CreateTarmac(true, true, true, false, false)
    end, 
          
    BoneCalculation = function(self)   
        local cat = self:GetBlueprint().Display.AdjacencyConnection
        for k, v in self.Info.ents do              
            v.val = EntityCategoryContains(categories[cat], v.ent)
        end      
        local TowerCalc = 0
        if self.Info.ents.northUnit.val then
            self:SetAllBones('bonetype', 'North', 'show')
            TowerCalc = TowerCalc + 99
        else
            self:SetAllBones('bonetype', 'North', 'hide')
        end 
        if self.Info.ents.southUnit.val then     
            self:SetAllBones('bonetype', 'South', 'show')
            TowerCalc = TowerCalc + 101 
        else
            self:SetAllBones('bonetype', 'South', 'hide')
        end 
        if self.Info.ents.eastUnit.val then     
            self:SetAllBones('bonetype', 'East', 'show')
            TowerCalc = TowerCalc + 97 
        else
            self:SetAllBones('bonetype', 'East', 'hide')
        end   
        if self.Info.ents.westUnit.val then     
            self:SetAllBones('bonetype', 'West', 'show')
            TowerCalc = TowerCalc + 103 
        else
            self:SetAllBones('bonetype', 'West', 'hide')
        end
        if TowerCalc == 200 then
            self:SetAllBones('bonetype', 'Tower', 'hide')
        else
            self:SetAllBones('bonetype', 'Tower', 'show')
            self:SetAllBones('conflict', 'Tower', 'hide')
            if self.Info.ents.northUnit.val then
                self:SetAllBones('conflict', 'North', 'hide')
            end 
            if self.Info.ents.southUnit.val then     
                self:SetAllBones('conflict', 'South', 'hide') 
            end 
            if self.Info.ents.eastUnit.val then     
                self:SetAllBones('conflict', 'East', 'hide') 
            end   
            if self.Info.ents.westUnit.val then     
                self:SetAllBones('conflict', 'West', 'hide')   
            end
        end
        if self:GetBlueprint().Display.AdjacencyBeamConnections then
            for k1, v1 in self.Info.ents do
                if v1.val then
                    --if not v1.ent:isDead() then 
                        for k, v in self.Info.bones do
                            if v.bonetype == 'Beam' then
                                AttachBeamEntityToEntity(self, k, v1.ent, k, self:GetArmy(), v.beamtype)
                            end
                        end
                    --end
                end
            end
        end
        self:BoneUpdate(self.Info.bones)  
    end,
    
    SetAllBones = function(self, check, bonetype, action)
        for k, v in self.Info.bones do
            if v[check] == bonetype then
                v.visibility = action
            end
        end                                                
    end,   
             
    BoneUpdate = function(self, bones)
        for k, v in bones do
            if v.visibility == 'show' then   
                if self:IsValidBone(k) then
                    self:ShowBone(k, true)
                end
            else
                if self:IsValidBone(k) then   
                    self:HideBone(k, true) 
                end
            end
        end                                               
    end,   
    
    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        local MyX, MyY, MyZ = unpack(self:GetPosition())
        local AX, AY, AZ = unpack(adjacentUnit:GetPosition())
        local cat = self:GetBlueprint().Display.AdjacencyConnection
        if EntityCategoryContains(categories[cat], adjacentUnit) then
            if MyX > AX then
                self.Info.ents.westUnit.ent = adjacentUnit
            end
            if MyX < AX then         
                self.Info.ents.eastUnit.ent = adjacentUnit
            end
            if MyZ > AZ then         
                self.Info.ents.northUnit.ent = adjacentUnit
            end
            if MyZ < AZ then   
                self.Info.ents.southUnit.ent = adjacentUnit
            end
        end      
        self:BoneCalculation() 
        --CLandFactoryUnit.OnAdjacentTo(self,builder,layer)  
    end,
    
    CreateBlinkingLights = function(self, color)
    end, 
      
    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        --self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
        self.AttachedUnit = unitBeingBuilt
    end,
         
    StartBuildFx = function(self, unitBeingBuilt)
    end,  
    
    OnDamage = function(self, instigator, amount, vector, damageType)    
        CLandFactoryUnit.OnDamage(self, instigator, amount, vector, damageType)
        if self.AttachedUnit and not self.AttachedUnit:IsDead() then
            local amountR = amount * .5
            self.AttachedUnit:OnDamage(instigator, amountR, vector, damageType)
            --if self.AttachedUnit:IsDead() then
            --    self:DetachAll(self:GetBlueprint().Display.BuildAttachBone or 0)
            --    self:DestroyBuildRotator()
            --end
            --self:DoTakeDamage(instigator, amount, vector, damageType)
        end
    end,     
    
    OnScriptBitSet = function(self, bit)
        CLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 7 then
            if self.AttachedUnit then
                self.AttachedUnit:Destroy() 
            end   
            self:SetScriptBit('RULEUTC_SpecialToggle',false) 
            IssueClearCommands({self})
        end
    end,
            
    --[[OnScriptBitClear = function(self, bit)
        CLandFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 7 then
            if self.AttachedUnit then
                self.AttachedUnit:Destroy() 
            end 
            IssueClearCommands({self})
        end
    end,--]] 
      
    UpgradingState = State(CLandFactoryUnit.UpgradingState) {
        Main = function(self)
            CLandFactoryUnit.UpgradingState.Main(self)
        end,
        
        OnStopBuild = function(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 then
                if self.AttachedUnit then
                    self.AttachedUnit:Destroy() 
                end
            end
            CLandFactoryUnit.UpgradingState.OnStopBuild(self, unitBuilding) 
                --unitBuilding.Info.ents = self.Info.ents
                --unitBuilding:BoneCalculation()  
        end,
    }
}

TypeClass = SRB5310