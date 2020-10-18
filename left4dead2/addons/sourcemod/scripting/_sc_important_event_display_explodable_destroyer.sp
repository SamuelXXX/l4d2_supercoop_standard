#pragma semicolon 1;

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>


#define PLUGIN_VERSION "1.0"

#define TEAM_SURVIVORS		2

new g_bLateLoad;
new g_bMapStarted;

new Handle:g_iExplodables;
new Handle:g_iLasthits; 


public Plugin:myinfo = 
{

    name = "L4D2 Exploder Informer",
    author = "SamaelXXX",
    description = "Prints a chat message someone shoot explodables",
    version = PLUGIN_VERSION,
    url = ""
}

public OnPluginStart( )
{
	HookEvent( "round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	
	g_iExplodables = CreateArray( );
	g_iLasthits = CreateArray( );

	if ( g_bLateLoad )
	{
		for ( new i = 1; i <= MaxClients; i++ )
		{
			if ( IsClientAndInGame( i ) )
			{
				// not sure
				OnClientDisconnect_Post( i );
				OnClientPutInServer( i );
				
			}
		}
	}
	RefreshExplodables( );
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	g_bLateLoad = late;
	return APLRes_Success;
}

public OnClientPutInServer( client )
{
	SDKHook( client, SDKHook_WeaponEquipPost, OnWeaponEquip );
}

public OnClientDisconnect_Post( client )
{
	SDKUnhook( client, SDKHook_WeaponEquipPost, OnWeaponEquip );
}

public OnMapStart( )
{
	// workaround for createentitybyname. round stars before OnMapStarted :(
	g_bMapStarted = true;
	RefreshExplodables( );
}

public OnMapEnd( )
{
	g_bMapStarted = false;
}

public Action:Event_RoundStart( Handle:event, const String:name[], bool:dontBroadcast )
{
	if( g_bMapStarted )
	{
		RefreshExplodables( );
	}
}

public Action:OnWeaponEquip(client, weapon)
{
	if(!IsValidEdict(weapon))
	{
		return;
	}
	// if gascan was burning or "spitting" it can be extinguished and still poured into car (c1m4_atrium) 
	// so when it will be destroyed we do not need any lasthits
	// char target_class[32];
	// GetEntityClassname(weapon,target_class,32);
	
	// char EdictModelName[ 128 ];
	// GetEntPropString( weapon, Prop_Data, "m_ModelName", EdictModelName, sizeof(EdictModelName) );
	// PrintToServer("Equip %s:%s",target_class,EdictModelName);
	new index = -1;
	index = FindValueInArray( g_iExplodables, weapon );
	if( index > -1 )
	{
		SetArrayCell( g_iLasthits, index, -1 );	
		//PrintToServer("Equip an registered explodable");
	}
	else if(IsExplodable(weapon))
	{
		//PrintToServer("Equip an not registered explodable");
		SDKHook(weapon, SDKHook_OnTakeDamage, OnTakeDamageExplodable );
		PushArrayCell( g_iExplodables, weapon );
		PushArrayCell( g_iLasthits, -1 );
	}
	
}

public bool:IsExplodable(entity)
{
	decl String:EdictModelName[ 128 ];
	decl String:EdictClassName[ 32 ];
	EdictModelName[0] = '\0';

	if ( !IsValidEdict( entity ) )
		return false;

	//return true;
			
	GetEdictClassname( entity, EdictClassName, sizeof( EdictClassName ) );

	if(StrEqual( EdictClassName, "weapon_gascan" ))
	{
		return true;
	}
	
	if(StrEqual( EdictClassName, "weapon_fireworkcrate" ))
	{
		return true;
	}

	if(StrEqual( EdictClassName, "weapon_propanetank" ))
	{
		return true;
	}

	if(StrEqual( EdictClassName, "weapon_oxygentank" ))
	{
		return true;
	}

	if(StrEqual( EdictClassName, "prop_fuel_barrel" ))
	{
		return true;
	}

	if( StrEqual( EdictClassName, "prop_physics" ) )
	{
		GetEntPropString( entity, Prop_Data, "m_ModelName", EdictModelName, sizeof( EdictModelName ) );
		if ( StrEqual( EdictModelName, "models/props_junk/gascan001a.mdl" ))
		{
			return true;
		}	
		if ( StrEqual( EdictModelName, "models/props_junk/explosive_box001.mdl" ))
		{
			return true;
		}
		if ( StrEqual( EdictModelName, "models/props_junk/propanecanister001a.mdl" ))
		{
			return true;
		}
		if ( StrEqual( EdictModelName, "models/props_industrial/barrel_fuel.mdl" ))
		{
			return true;
		}
		if ( StrEqual( EdictModelName, "models/props_equipment/oxygentank01.mdl" ))
		{
			return true;
		}
		
	}

	return false;
}

public OnEntityCreated( entity, const String:classname[] )
{
	// made for weaponspawners and auto respawning gascans (e.g. c1m4_atrium).
	if ( IsExplodable(entity) )
	{
		RefreshExplodables();
	}
} 

public OnEntityDestroyed( entity )
{
	//在捡起未移动过位置时的油桶或者烟花时，会触发销毁原先的油桶
	new killer = -1;
	new index = -1;
	if ( IsValidEdict( entity ) )
	{
		index = FindValueInArray( g_iExplodables, entity );
		if( index > -1 )
		{
			killer = GetArrayCell( g_iLasthits, index );
			// they can be destroyed at mapchange and if no one touched them, killer will be -1
			// also it will be -1 if it was picked up (after spitter or inferno)
			if( IsClientAndInGame( killer ) )
			{
				new String:PlayerName[ 32 ];
				GetClientName( killer, PlayerName, sizeof( PlayerName ) );

				decl String:EdictModelName[ 128 ];
				GetEntPropString( entity, Prop_Data, "m_ModelName", EdictModelName, sizeof( EdictModelName ) );

				decl String:EdictClassName[ 32 ];
				GetEdictClassname( entity, EdictClassName, sizeof( EdictClassName ) );

				if ( StrEqual( EdictModelName, "models/props_junk/gascan001a.mdl" ))
				{
					display_event(PlayerName,"引燃了汽油罐！");
				}
				else if ( StrEqual( EdictModelName, "models/props_junk/explosive_box001.mdl" ))
				{
					display_event(PlayerName,"引爆了烟花盒！");
				}
				else if ( StrEqual( EdictModelName, "models/props_junk/propanecanister001a.mdl" ))
				{
					display_event(PlayerName,"引爆了液化气罐！");
				}
				else if(StrEqual( EdictModelName, "models/props_industrial/barrel_fuel.mdl" ))
				{
					display_event(PlayerName,"引爆了大型汽油桶！");
				}
				else if(StrEqual( EdictModelName, "models/props_equipment/oxygentank01.mdl" ))
				{
					display_event(PlayerName,"引爆氧气瓶！");
				}
			}
					
			SDKUnhook( entity, SDKHook_OnTakeDamage, OnTakeDamageExplodable );
			SetArrayCell( g_iExplodables, index, -1 );
			RefreshExplodables();//烟花盒在销毁后貌似会用同样的id生成一个新的烟花盒，所以在销毁后同样需要处理一下
		}
	}
}

public Action:OnTakeDamageExplodable( victim, &attacker, &inflictor, &Float:damage, &damagetype )
{
	new index = -1;
	// save lasthit. when first inferno fired by player burns second gascan there are MANY ontakedamage calls from first inferno and player. we need only real player.
	// we need hits only from spitter or survivors.
	if ( 
		IsValidEdict( victim ) && 
		IsClientAndInGame( attacker ) && 
		GetClientTeam( attacker ) == TEAM_SURVIVORS 
	)
	{
		index = FindValueInArray( g_iExplodables, victim );
		if( index > -1 )
		{
			SetArrayCell( g_iLasthits, index, attacker );
		}
		// char target_class[32];
		// GetEntityClassname(victim,target_class,32);

		// char EdictModelName[ 128 ];
		// GetEntPropString( victim, Prop_Data, "m_ModelName", EdictModelName, sizeof(EdictModelName) );
		// PrintToServer("Damage %s:%s",target_class,EdictModelName);
	}	
}  

public UnhookExplodables( )
{
	new entity = -1;
	// unhook previous if they are still hooked
	for ( new i = 0; i < GetArraySize( g_iExplodables ); i++ )
	{
		entity = GetArrayCell( g_iExplodables, i );
		if( entity != -1 )
		{
			SDKUnhook( entity, SDKHook_OnTakeDamage, OnTakeDamageExplodable );
		}
	}
}

public RefreshExplodables( )
{
	UnhookExplodables();

	// reset arrays
	ClearArray( g_iExplodables );
	ClearArray( g_iLasthits );
	// find and save all gascans
	for ( new i = 0; i <= GetMaxEntities(); i++ )
	{
		if ( IsValidEdict( i ) )
		{
			if ( !IsExplodable(i) ) 
			{
				continue;
			}

			SDKHook( i, SDKHook_OnTakeDamage, OnTakeDamageExplodable );
				
			PushArrayCell( g_iExplodables, i );
			PushArrayCell( g_iLasthits, -1 );
		}
	}
}

bool:IsClientAndInGame(index)
{
	if (index > 0 && index < MaxClients)
	{
		return IsClientInGame(index);
	}
	return false;
}

stock void display_event(const char[] name,const char[] behaviour)
{
	PrintToChatAll("\x03[虾皮行为检测器] \x04%s\x01%s",name,behaviour);
}

stock int get_user_name(Handle event,char[] name,int len)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	GetClientName(client,name,len);
}