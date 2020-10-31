//破晓
printl("Initializing Day Break Scripts")

::g_WeaponController <- {}
DoIncludeScript("custom_weapon_controller_daybreak", g_WeaponController)
if(g_WeaponController.AddCustomWeapon("models/weapons/melee/v_flamethrower.mdl", "custom_flamethrower_daybreak"))
{
	g_WeaponController.SetReplacePercentage("flamethrower", 15)
}