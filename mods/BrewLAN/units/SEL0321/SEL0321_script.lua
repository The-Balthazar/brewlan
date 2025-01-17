--------------------------------------------------------------------------------
--  Summary  :  UEF Mobile Strategic Missile Defence Platform Script
--------------------------------------------------------------------------------
local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TAMInterceptorWeapon = import('/lua/terranweapons.lua').TAMInterceptorWeapon

SEL0321 = Class(TLandUnit) {
    Weapons = {
        AntiNuke = Class(TAMInterceptorWeapon) {
            RackSalvoFireReadyState = State(TAMInterceptorWeapon.RackSalvoFireReadyState) {
                Main = function(self)
                    local MuzzleSalvoSize = self:GetBlueprint().MuzzleSalvoSize or 2
                    if self.unit:GetTacticalSiloAmmoCount() < MuzzleSalvoSize then
                        self:ForkThread(
                            function(self)
                                WaitTicks(1)
                                if self.unit:GetTacticalSiloAmmoCount() > MuzzleSalvoSize - 1 then
                                    --Last minute panic check, not sure if it will actually work, very hard to test chance to test it
                                    TAMInterceptorWeapon.RackSalvoFireReadyState.Main(self)
                                end
                            end
                        )
                        return
                    else
                        TAMInterceptorWeapon.RackSalvoFireReadyState.Main(self)
                    end
                end,
            },
        },
    },
}

TypeClass = SEL0321
