// CA Hierarchy setup 
// Author: Poulern (@me for issues)
// Server execution only and run once at the start of mission

//Total tickets (Where one ticket = 1 respawn, default 5 for vehicles) per team in addition to the group tickets;
_caWestTickets = 50;


_hierarchy = {
_side = _this select 0;
_corank = ca_corank;
_slrank = ca_slrank;
_ftlrank = ca_ftlrank;

/*
Parameters for ca_fnc_setupGroup:
 * 0: Groupid (String): The groupid that is set in the editor field callsign.
 * 1: Superior (String): The groupid of the group that ranks above it in the hierarchy, if equal to groupid, then the group is an independent group or its own platoon.
 * 2: Side (Side): This is set automatically, if you need to set up for multiple sides copy the template and name it _westhierarchy, _easthierachy etc. as needed and change the call below
 Every element below this is optional, but reccomended to set. 
 * 2: Rank (Number): The number from 1-6 that the unit rank should be. 1 is Corporal and 6 is Colonel
 * 3: Short range radio channel (Number): What channel the 343 will be on by default and on respawn. 
 * 4: Long range radio Array (Array): Array of channels the long range radios will be on by default and on respawn. There will be one radio given per channel to ranks set in ca_acre2settings.sqf
 * 5: Group color (String): The color of the group in the hierarchy and its groupmarker. Available colors: "ColorBlack","ColorGrey","ColorRed","ColorBrown",
 "ColorOrange","ColorYellow","ColorKhaki","ColorGreen","ColorBlue","ColorPink","ColorWhite"
 * 6: Group tickets (Number): The number of tickets this group gets to play with at the start of the mission. 
 * 7: Group type (String): What markertype the unit has. This is if you want to use the non-automatic mode that the groupmarker uses. 

["CO","CO",_side,_corank,16,[4,5,6],"ColorYellow",3] spawn ca_fnc_setupGroup;

*/

["CO","CO",_side,_corank,16,[4,5,6],"ColorYellow",3] spawn ca_fnc_setupGroup;

	["ASL","CO",_side,_slrank,1,[4,1],"ColorRed",5] spawn ca_fnc_setupGroup;

	["A1","ASL",_side,_ftlrank,2,[1],"ColorRed",2] spawn ca_fnc_setupGroup;
	["A2","ASL",_side,_ftlrank,3,[1],"ColorRed",2] spawn ca_fnc_setupGroup;
	["AV","ASL",_side,_ftlrank,4,[5,1],"ColorRed",2] spawn ca_fnc_setupGroup;


	["BSL","CO",_side,_slrank,5,[4,2],"ColorBlue",5] spawn ca_fnc_setupGroup;

	["B1","BSL",_side,_ftlrank,6,[2],"ColorBlue",2] spawn ca_fnc_setupGroup;
	["B2","BSL",_side,_ftlrank,7,[2],"ColorBlue",2] spawn ca_fnc_setupGroup;
	["BV","BSL",_side,_ftlrank,8,[5,2],"ColorBlue",2] spawn ca_fnc_setupGroup;


	["CSL","CO",_side,_slrank,9,[4,3],"ColorGreen",5] spawn ca_fnc_setupGroup;

	["C1","CSL",_side,_ftlrank,10,[3],"ColorGreen",2] spawn ca_fnc_setupGroup;
	["C2","CSL",_side,_ftlrank,11,[3],"ColorGreen",2] spawn ca_fnc_setupGroup;
	["CV","CSL",_side,_ftlrank,12,[5,3],"ColorGreen",2] spawn ca_fnc_setupGroup;


	["MMG","CO",_side,_slrank,13,[4,8],"ColorOrange",5] spawn ca_fnc_setupGroup;

	["MAT","MMG",_side,_ftlrank,14,[8],"ColorOrange",2] spawn ca_fnc_setupGroup;


	["ENG","CO",_side,_slrank,15,[5],"ColorGrey",2,"b_maint"] spawn ca_fnc_setupGroup;
};

// Change to numbers if needed for TvTs/events with multiple sides
_caEastTickets = _caWestTickets;
_caIndependentTickets = _caWestTickets;

// Radio channels setup
// ====================================================================================

// Long range channel names for 148, 152, 117, Vehicle radios. This correlates to "ALPHA SQUAD" = Channel 1 in the platoon hierarchy array above. 
_caWestLongrangeChannelList = ["ALPHA SQUAD","BRAVO SQUAD","CHARLIE SQUAD","INFANTRY COMMAND","VEHICLE COMMAND","FORWARD AIR CONTROL","AIR COMMAND","WEAPONS SQUAD"];
_caEastLongrangeChannelList = _caWestLongrangeChannelList;
_caIndependentLongrangeChannelList = _caWestLongrangeChannelList;
/* Default setup on 343 (short range) for the hierarchy above:
CH1:ASL CH2:A1 CH3:A2 CH4:AV CH5:BSL CH6:B1 CH7:B2 CH8:BV CH9:CSL CH10:C1 CH11:C2 CH12:CV CH13:MMG CH14:MAT CH15:ENG CH16:CO
*/
// ====================================================================================
/* Ranks for various actions like respawning, 
0 - Private
1 - Corporal - Default for Fireteam lead
2 - Sergeant - Default for Squad lead
3 - Lieutenant - Default for Commanding Officer
4 - Captain 
5 - Major
6 - Colonel
*/
_corank = 3;
_slrank = 2;
_ftlrank = 1;

// Respawn settings
// ====================================================================================

// How far away an enemy must be to the respawner for respawn to be available
ca_enemyradius = 250;
// How close you must be to your squad lead or CO to be able to recieve more tickets
ca_ticketradius = 50;

//Delay between each time a group can be respawned
ca_grouprespawncooldown = 300;

// END OF SETUP VARIABLES
// Executing setup as described above
// ====================================================================================
// ====================================================================================
sleep 2;

missionNamespace setVariable ['f_radios_settings_acre2_lr_groups_blufor',_caWestLongrangeChannelList, true]; 
missionNamespace setVariable ['f_radios_settings_acre2_lr_groups_opfor',_caEastLongrangeChannelList, true]; 
missionNamespace setVariable ['f_radios_settings_acre2_lr_groups_indfor',_caIndependentLongrangeChannelList, true]; 

missionNamespace setVariable ['ca_corank',_corank, true]; 
missionNamespace setVariable ['ca_slrank',_slrank, true]; 
missionNamespace setVariable ['ca_ftlrank',_ftlrank, true]; 
ca_allWestPlayerGroups = [];
ca_allEastPlayerGroups = [];
ca_allIndependentPlayerGroups = [];

{
	if (side _x == west) then {ca_allWestPlayerGroups pushBackUnique group _x};
	if (side _x == east) then {ca_allEastPlayerGroups pushBackUnique group _x};
	if (side _x == independent) then {ca_allIndependentPlayerGroups pushBackUnique group _x};
} forEach allunits;

ca_WestJIPgroups = [];
ca_EastJIPgroups = [];
ca_IndependentJIPgroups = [];
sleep 5;

[west] spawn _hierarchy;
[east] spawn _hierarchy;
[independent] spawn _hierarchy;

sleep 10;
missionNamespace setVariable ['ca_WestJIPgroups',ca_WestJIPgroups, true]; 
missionNamespace setVariable ['ca_EastJIPgroups',ca_EastJIPgroups, true]; 
missionNamespace setVariable ['ca_IndependentJIPgroups',ca_IndependentJIPgroups, true]; 

missionNamespace setVariable ['ca_WestTickets',_caWestTickets, true]; 
missionNamespace setVariable ['ca_EastTickets',_caEastTickets, true]; 
missionNamespace setVariable ['ca_IndependentTickets',_caIndependentTickets, true]; 

missionNamespace setVariable ['ca_enemyradius',ca_enemyradius, true]; 
missionNamespace setVariable ['ca_ticketradius',ca_ticketradius, true]; 
missionNamespace setVariable ['ca_grouprespawncooldown',ca_grouprespawncooldown, true]; 

sleep 2;
missionNamespace setVariable ['ca_platoonsetup',true, true]; 

