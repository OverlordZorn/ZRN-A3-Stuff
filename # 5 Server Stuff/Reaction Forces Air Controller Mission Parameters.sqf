class Missions
{
	class MP_AirControl_m01 // name for the first entry - can be anything (characters/numbers/underscore, but no spaces!)
	{
		template = "MP_AirControl_m01.Altis";
		difficulty = "custom";
		class Params
		{
			lxRF_EnableSave = 1;
			lxRF_EnFaction = 0 // AAF 1 CSAT;
			lxRF_OnlyPilots = 0; // 1 true
			lxRF_StartGameParam = 0; // 0,5,10,15,20,25,30,40,50,60,70,80,90;
			lxRF_ViewDistance = 1600; // 2000,2250,2500,2750,3000,3250,3500,3750,4000,4250,4500,4750,5000
		};
	};
};
