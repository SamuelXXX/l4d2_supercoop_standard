Msg("\n\n\n");
Msg(">>>c2m1_reserved_wanderers\n");
Msg("\n\n\n");
//进入第一个子弹堆，也就是装甲车附近触发
//完全下到沼泽里触发

DirectorOptions <-
{
	// Turn always wanderer on
	AlwaysAllowWanderers = 1

	// Set the number of infected that cannot be absorbed
	NumReservedWanderers = 30
}
