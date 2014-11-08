#****************************************************************************
#**
#**	File:		/lua/CustomUnits/CustomUnits.lua
#**
#**	Description:	For use with the Sorian AI
#**
#**	Copyright � 2009 BrewLAN
#**
#****************************************************************************

UnitList = {
--------------------------------------------------------------------------------
-- Field Engineers
--------------------------------------------------------------------------------
T1BuildEngineer = {
    UEF = {'sel0119', 10},
    Aeon = {'sal0119', 10},
    Cybran = {'srl0119', 10},
    Seraphim = {'ssl0119', 10},
},
T2BuildEngineer = {
    UEF = {'xel0209', 10},
    Aeon = {'sal0209', 10},
    Cybran = {'srl0209', 10},
    Seraphim = {'ssl0219', 10},
},
T3BuildEngineer = {
    UEF = {'sel0319', 10},
    Aeon = {'sal0319', 10},
    Cybran = {'srl0319', 10},
    Seraphim = {'ssl0319', 10},
},
--------------------------------------------------------------------------------
-- Salvation/Scathis 2
--------------------------------------------------------------------------------
T4ArtilleryStructure =       {Aeon = {'xab2307', 100},Cybran = {'url0401', 100},},
T4ArtilleryStructureSorian = {Aeon = {'xab2307', 100},Cybran = {'url0401', 100},},
T4Artillery =                {Aeon = {'xab2307', 100},Cybran = {'url0401', 100},}, 
--------------------------------------------------------------------------------
-- Absolution
--------------------------------------------------------------------------------
T4LandExperimental1 = {
    Aeon = {'sal0401', 50},
    UEF = {'seb0401', 75},
},
T4LandExperimental2 = {
    Aeon = {'sal0401', 100},  
    UEF = {'seb0401', 100},
},
T4SeaExperimental1 =  {Aeon = {'sal0401', 25},},
--------------------------------------------------------------------------------
-- Centurion
--------------------------------------------------------------------------------
T4AirExperimental1 = {UEF = {'sea0401', 25},}, 
--------------------------------------------------------------------------------
-- T3 Aircraft
--------------------------------------------------------------------------------
T3AirTransport = {
    Aeon = {'saa0306', 100},
    Cyrban = {'sra0306', 100},
    Seraphim = {'ssa0306', 100},
},
T3AirGunship = {
    Seraphim = {'ssa0305', 100},
},
T3AirBomber = {
    Seraphim = {'ssa0305', 20},
},
T3TorpedoBomber = {
    Cybran = {'sra0307', 100},
    UEF = {'sea0307', 100},
    Seraphim = {'ssa0307', 100},
},
T2TorpedoBomber = {
    Cybran = {'sra0307', 33},
    UEF = {'sea0307', 33},
    Seraphim = {'ssa0307', 33},
},
T3AirScout ={
    Aeon = {'saa0310', 10},
},
T3AirFighter ={
    Aeon = {'saa0310', 10},
},
--------------------------------------------------------------------------------
-- T3 Land units
--------------------------------------------------------------------------------
T3LandBot = {
    Aeon = {'sal0311', 50},
    Seraphim = {'ssl0311', 50},
},
T3ArmoredAssault = {
    Aeon = {'sal0311', 100},
    Seraphim = {'ssl0311', 100},
},
T3ArmoredAssaultSorian = {
    Aeon = {'sal0311', 100},
    Seraphim = {'ssl0311', 100},
},
T3LandAA = {
    Cybran = {'srl0320', 100},
},
T3SniperBots = {
    Cybran = {'srl0320', 100},
    UEF = {'sel0320', 100},
},
T3LandArtillery = {
    Cybran = {'srl0320', 20},
    UEF = {'sel0320', 40},
},
--------------------------------------------------------------------------------
-- Aeon T2 Bomber
--------------------------------------------------------------------------------
T1AirBomber =     {Aeon = {'saa0211', 40},},
T2FighterBomber = {Aeon = {'saa0211', 20},},
T3AirBomber =     {Aeon = {'saa0211', 20},},
--------------------------------------------------------------------------------
-- T1 Aircraft
--------------------------------------------------------------------------------
T1Gunship = {
    Aeon = {'saa0105', 100},
    Seraphim = {'ssa0105', 100},
    UEF = {'sea0105', 100},
},
T1AirTransport = {
    UEF = {'sea0105', 25},
}, 
--------------------------------------------------------------------------------
-- Buildings from the other because overlap fucks it up
--------------------------------------------------------------------------------
T2RadarJammer = {
    Cybran =	{'srb4313', 45},
},
T3ShieldDefense = {
    Cybran =	{'urb4206', 100}, #ED4
},
T2ShieldDefense = {
    Cybran =	{'urb4205', 50}, #ED3
},
--------------------------------------------------------------------------------
-- End
--------------------------------------------------------------------------------
}