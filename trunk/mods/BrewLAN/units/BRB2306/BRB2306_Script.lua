#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2301/URB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Gun Tower Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGenerator = CybranWeaponsFile.CDFHeavyMicrowaveLaserGenerator

BRB2306 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGenerator) {
        },
        Laser = Class(CDFParticleCannonWeapon) {
            FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_02_emit.bp'},
        },
    },
}

TypeClass = BRB2306