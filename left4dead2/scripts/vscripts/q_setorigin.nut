function q_setorigin()
{
local hunter1 = Entities.FindByName(null, "rotaing hunter1");
local origin = activator.GetOrigin();
hunter1.SetOrigin(origin);
}
//故乡