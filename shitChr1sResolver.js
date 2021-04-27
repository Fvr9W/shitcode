Cheat.PrintChat(' \x0e• [Chr1s解析器V3] 注入成功!(控制台有介绍). \n');
Cheat.PrintChat(' \x0c       最后更新时间：2021年3月30日. \n');
var isname = Cheat.GetUsername();
			Cheat.PrintColor([117, 112, 255, 255], '• 你使用的东西来自北落\n');
			Cheat.PrintColor([117, 112, 255, 255], '• 倒卖死个妈妈 \n');
			Cheat.PrintColor([117, 112, 255, 255], '• 我的联系方式： \n');
			Cheat.PrintColor([117, 112, 255, 255], '• QQ：2493798279 \n');
			Cheat.PrintColor([117, 112, 255, 255], '• 欢迎你来购买，玩得开心: ' + isname + '\n');




function trace_enemy()
{
    localPlayer_index = Entity.GetLocalPlayer();
    localPlayer_eyepos = Entity.GetEyePosition(localPlayer_index);
    enemies = Entity.GetEnemies();
    for ( i = 0; i < enemies.length; i++)
    {
       if (Entity.IsValid(enemies[i]) == true && Entity.IsAlive(enemies[i]) && Entity.IsDormant(enemies[i]) == false)
        {
        hitbox_pos = Entity.GetHitboxPosition(localPlayer_index, 0);
        bot_eyepos = Entity.GetEyePosition(enemies[i])
        result = Trace.Bullet(enemies[i], localPlayer_index, bot_eyepos, hitbox_pos);
        

        }
    }

}
Cheat.RegisterCallback("CreateMove", "trace_enemy");

function extrapolate_tick(entity, ticks, x, y, z)
{
    velocity = Entity.GetProp(entity, "CBasePlayer", "m_vecVelocity[0]");
    new_pos = [x, y, z];
    new_pos[0] = new_pos[0] + velocity[0] * Globals.TickInterval() * ticks;
    new_pos[1] = new_pos[1] + velocity[1] * Globals.TickInterval() * ticks;
    new_pos[2] = new_pos[2] + velocity[2] * Globals.TickInterval() * ticks;
    return new_pos;
}

function is_lethal(entity)
{
    local_player = Entity.GetLocalPlayer();
    eye_pos = Entity.GetEyePosition(local_player);
    ticks = 64
    extrapolated_location = extrapolate_tick(local_player, ticks, eye_pos[0], eye_pos[1], eye_pos[2]);
    entity_hp = Entity.GetProp(entity, "CBasePlayer", "m_iHealth");
    lethal_damage = 92
    if (lethal_damage > entity_hp) return true;
    else return false;
}

function force_head(entity)
{
    local_player = Entity.GetLocalPlayer();
    head_pos = Entity.GetHitboxPosition(entity, 0);
    head_damage = Trace.Bullet(local_player, entity, Entity.GetEyePosition(local_player), head_pos);
    Ragebot.ForceTargetMinimumDamage(entity, head_damage[1]);
}

function get_condition(entity)
{
    flags = Entity.GetProp(entity, "CBasePlayer", "m_fFlags");
    entity_velocity = Entity.GetProp(entity, "CBasePlayer", "m_vecVelocity[0]");
    entity_speed = Math.sqrt(entity_velocity[0] * entity_velocity[0] + entity_velocity[1] * entity_velocity[1]).toFixed(0);
    wpn_info = Entity.GetCCSWeaponInfo(entity);
    if (wpn_info == undefined) return;
    if (flags & 1 << 1) return "crouching";
    else if (!(flags & 1 << 0) && !(flags & 1 << 0x12)) return "in-air";
    else if (entity_speed <= 2) return "standing";
    else if (entity_speed >= wpn_info["max_speed"]) return "running";
    else if (entity_speed <= (wpn_info["max_speed"] / 0.6).toFixed(0)) return "slow-walking";
}

function XTQwaWQ()
{
	enemies = Entity.GetEnemies()
	 for(i in enemies)
    {
		if(Entity.IsAlive(enemies[i]) && !Entity.IsDormant(enemies[i]))
		{
			if(is_lethal(enemies[i])){
					target = Ragebot.GetTarget()				
					Ragebot.ForceTargetSafety(target)
			} else if (get_condition(enemies[i]) == "slow-walking") {
			Ragebot.ForceTargetMinimumDamage(enemies[i], 101)
			}
	}
}
}

Cheat.RegisterCallback('CreateMove','XTQwaWQ')

function qwH2xloS()
{
    enemies = Entity.GetEnemies()
    for(i in enemies)
    {
        if(Entity.IsAlive(enemies[i]) && !Entity.IsDormant(enemies[i]))
        {
			var health = Entity.GetProp(enemies[i], "CBasePlayer", "m_iHealth")
            var duck = Entity.GetProp(enemies[i],"CCSPlayer", "m_flDuckAmount")
            if(duck > 0.9) var ducking = 1
            if(duck < 0.9) var ducking = 0
            var box = Entity.GetRenderBox(enemies[i])
			
            if(ducking == 1)
            {
				Ragebot.OverrideMinimumDamage(target, health-9)
            } 
            else if(ducking == 0)
            {
				return;
            }
        }
    }
}
Cheat.RegisterCallback('CreateMove','qwH2xloS')

function DisableBaim() {
    if (UI.IsHotkeyActive('Rage', 'GENERAL', 'Force body aim')) UI.ToggleHotkey('Rage', 'GENERAL', 'Force body aim');
}

function on_create_move()
{
  var local = Entity.GetLocalPlayer();
  if(!Entity.IsAlive(local)) return;
  var enemies = Entity.GetEnemies();

  for(var i = 0; i < enemies.length;i++)
  {
    var enemy = enemies[i];
    var dif = Globals.Tickcount() - last_shot_time[enemy]
    var has_shot = dif >= 0 && dif <= 12;
    if(has_shot){
DisableBaim();
force_head(enemy);
  }
  }

}
function STGAhnw7()
{
  var shooter = Entity.GetEntityFromUserID(Event.GetInt("userid"));
  last_shot_time[shooter] = Globals.Tickcount();
}

function u027jeiaW()
{
  var entity = Entity.GetEntityFromUserID(Event.GetInt("userid"));
  if(entity == Entity.GetLocalPlayer())
    last_shot_time = []
}


Cheat.RegisterCallback("weapon_fire", "STGAhnw7")
Cheat.RegisterCallback("player_connect_full", "u027jeiaW")
Cheat.RegisterCallback("CreateMove","on_create_move")

function wo19SHDo2() {
    var USShc9cv = Entity.GetEnemies();
    var NFMhvu6e = Ragebot.GetTarget();
	var NXVxzhnf = 30
    for (i = 0x0; i < USShc9cv.length; i++) {
        if (!Entity.IsValid(USShc9cv[i])) continue;
        if (!Entity.IsAlive(USShc9cv[i])) continue;
        if (Entity.IsDormant(USShc9cv[i])) continue;
        if (GetMaxDesync(USShc9cv[i]) < NXVxzhnf && !IsInAir(USShc9cv[i])) {
            DisableBaim();
    target = Ragebot.GetTarget()
	Ragebot.ForceTargetHitchance(target, 80)
   var cF7Qrc2d = Entity.GetEnemies();
	var aqM2hlen = Entity.GetRenderBox(cF7Qrc2d[i]);
    var nfMhvu6e = Entity.GetProp(aqM2hlen, 'CBasePlayer', 'm_iHealth');
    head_pos = Entity.GetHitboxPosition(aqM2hlen, 0x0);
    result_head = Trace.Bullet(Entity.GetLocalPlayer(), aqM2hlen, Entity.GetEyePosition(Entity.GetLocalPlayer()), head_pos);
    if (nfMhvu6e > result_head[0x1]) Ragebot.ForceTargetMinimumDamage(aqM2hlen, result_head[0x1]);
    else Ragebot.ForceTargetMinimumDamage(aqM2hlen, nfMhvu6e);
        }
}
}

function GetMaxDesync(CF7qrc2d) {
    var Q7Vhhmwz = Entity.GetProp(CF7qrc2d, 'CBasePlayer', 'm_vecVelocity[0]');
    var NFmhvu6e = Math.sqrt(Q7Vhhmwz[0x0] * Q7Vhhmwz[0x0] + Q7Vhhmwz[0x1] * Q7Vhhmwz[0x1]);
    return 0x3a - 0x3a * NFmhvu6e / 0x244;
}

Cheat.RegisterCallback("CreateMove","wo19SHDo2")

function isDoubleTapActive() {
    var _0x3f94xc = UI.GetValue('Rage', 'Exploits', 'Doubletap');
    var _0x3f94xd = UI.IsHotkeyActive('Rage', 'Exploits', 'Doubletap');
    return _0x3f94xc && _0x3f94xd
}

function loIDk291dl1() {
	g_Local9 = Entity.GetLocalPlayer();
    var _0x3f94xf = Boolean(Entity.GetProp(g_Local9, 'CCSPlayer', 'm_bIsScoped'));
    if ( _0x3f94xf && UI.GetValue('Rage', 'GENERAL', 'Exploits', 'Doubletap')) {
        UI.SetValue('Visual', 'SELF', 'ESP', 'Hold firing animation', true)
    };
    if ( _0x3f94xf && !UI.GetValue('Rage', 'GENERAL', 'Exploits', 'Doubletap')) {
        UI.SetValue('Visual', 'SELF', 'ESP', 'Hold firing animation', false)
    };
    if ( !_0x3f94xf && !UI.GetValue('Rage', 'GENERAL', 'Exploits', 'Doubletap')) {
        UI.SetValue('Visual', 'SELF', 'ESP', 'Hold firing animation', false)
    };
    if ( !_0x3f94xf && UI.GetValue('Rage', 'GENERAL', 'Exploits', 'Doubletap')) {
        UI.SetValue('Visual', 'SELF', 'ESP', 'Hold firing animation', false)
	}
}
Cheat.RegisterCallback("Draw","loIDk291dl1")

function xYwS23dD() {
	localplayer_index = Entity.GetLocalPlayer( );
    var_0x32("Resolver_index_var", "resolve.index_var(57,-57)");
	var_0x_32("Resolver_index_var", "resolve.index_var(-30,30)");
	var_0x32("Resolver_index_var", "resolve.index_Entity.enemyPlayer_var(-17,17)");
    var_0x32("Resolver_index_var", "resolve.index,var(51,-52)");
    var_0x_42("Resolver.Get_index", "resolver_var.globalCurtime");
    var_1x_32("Resolver_index_var", "resolve.index_var(-25,25)");
	var_1x_53("Resolver_index_var", "resolve.index_var(-65,55)");
	var_2x_43("Resolver_index_var", "resolve.index_var(-25,35)");
	var_2x_73("Resolver_index_var", "resolve.index_var(-65,65)");
}

Cheat.RegisterCallback("Draw", "xYwS23dD");

var waiting_for_hit = false;

var target_idx = 0;

var tick_count = -1;

var misses = [64];

var safety_ents = [64];

uwuSDTs1()


function i88ja9JSkw() {
    waiting_for_hit = true;
    target_idx = Event.GetInt("target_index");
    tick_count = Globals.Tickcount()
}

function i88jwT2A7() {
    var entity = Entity.GetEntityFromUserID(Event.GetInt("userid"));


    if (entity == Entity.GetLocalPlayer())
        return;

    
    var attacker = Entity.GetEntityFromUserID(Event.GetInt("attacker"));

   
    if (attacker != Entity.GetLocalPlayer())
        return;

    if (entity != target_idx)
        return;
	
    waiting_for_hit = false;
    target_idx = 0;
    tick_count = -1;
 
}

function IuBn2d() {
    var tick_interval = 1000 / Globals.Tickrate();

    var wait_ticks = 1 + Math.ceil((Local.Latency() * 2) / tick_interval);

    if (Globals.Tickcount() - tick_count >= wait_ticks && waiting_for_hit) {
        misses[target_idx]++;

        if (misses[target_idx] >= 2) {
            safety_ents[target_idx] = 1;
        }

        waiting_for_hit = false;
        target_idx = 0;
        tick_count = -1;
    }

    var rbot_target = Ragebot.GetTarget();

    if (rbot_target == 0)
        return;

    if (safety_ents[rbot_target] == 1) {
        Ragebot.ForceTargetSafety(rbot_target);
    }
}

function De45Rk() {
    var idx = Entity.GetEntityFromUserID(Event.GetInt("userid"));
    reset_specific_miss_logs(idx)
}

function uwuSDTs1() {
    for (var i = 0; i < 64; i++) {
        reset_specific_miss_logs(i)
    }
}

function reset_specific_miss_logs(idx) {
    misses[idx] = 0;
    safety_ents[idx] = 0;
}

Cheat.RegisterCallback("ragebot_fire", "i88ja9JSkw");
Cheat.RegisterCallback("player_hurt", "i88jwT2A7");
Cheat.RegisterCallback("player_hurt", "i88jwT2A7");
Cheat.RegisterCallback("CreateMove", "IuBn2d");
Cheat.RegisterCallback("player_death", "De45Rk");
Cheat.RegisterCallback("round_start", "uwuSDTs1");

function f8ajSIe2() {
    var weapons = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
    if (weapons != 'ssg 08' && weapons != 'r8 revolver') {
        return
    };
    var flags = Entity.GetProp(Entity.GetLocalPlayer(), 'CBasePlayer', 'm_fFlags');
    if (!(flags & 1 << 0) && !(flags & 1 << 18)) {
            target = Ragebot.GetTarget();
            value = 40;
            Ragebot.ForceTargetHitchance(target, value);
    }
}

Cheat.RegisterCallback('CreateMove', 'f8ajSIe2');

Cheat.PrintChat(' \x0e• [Chr1s解析器V3] 注入成功!(控制台有介绍). \n');
Cheat.PrintChat(' \x0c       最后更新时间：2021年3月30日. \n');
var isname = Cheat.GetUsername();
			Cheat.PrintColor([117, 112, 255, 255], '• 你使用的东西来自Chr1s\n');
			Cheat.PrintColor([117, 112, 255, 255], '• 倒卖死个妈妈 \n');
			Cheat.PrintColor([117, 112, 255, 255], '• 我的联系方式： \n');
			Cheat.PrintColor([117, 112, 255, 255], '• QQ：2493798279 \n');
			Cheat.PrintColor([117, 112, 255, 255], '• 欢迎你来购买，玩得开心: ' + isname + '\n');


var exploits = ["Rage", "Exploits"];
function u9uy2bASDjk(){
    localplayer_index = Entity.GetLocalPlayer( );
    localplayer_weapon = Entity.GetWeapon(localplayer_index);
    weapon_name = Entity.GetName(localplayer_weapon);
    inaccuracy = Local.GetInaccuracy();
    spread = Local.GetSpread();
    localPlayer_index = Entity.GetLocalPlayer();
    localPlayer_eyepos = Entity.GetEyePosition(localPlayer_index);
    var target = Ragebot.GetTarget()
    var health = Entity.GetProp(target, "CBasePlayer", "m_iHealth")
    var charge = Exploit.GetCharge()
    var active = UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap") && charge == 1
    for ( i = 0; i < target.length; i++){
        hitbox_pos_head = Entity.GetHitboxPosition(target[i], 0);
        hitbox_pos_body = Entity.GetHitboxPosition(target[i], 3);
        hitbox_pos_thorax = Entity.GetHitboxPosition(target[i], 4);
        hitbox_pos_chest = Entity.GetHitboxPosition(target[i], 5);
        hitbox_pos_upp_chest = Entity.GetHitboxPosition(target[i], 6);
        result_head = Trace.Line(localPlayer_index, localPlayer_eyepos, hitbox_pos_head);
        result_body = Trace.Line(localPlayer_index, localPlayer_eyepos, hitbox_pos_body);
        result_thorax = Trace.Line(localPlayer_index, localPlayer_eyepos, hitbox_pos_thorax);
        result_chest = Trace.Line(localPlayer_index, localPlayer_eyepos, hitbox_pos_chest);
        result_upp_chest = Trace.Line(localPlayer_index, localPlayer_eyepos, hitbox_pos_upp_chest);
    }
        if(result_head = "undefined")return;
        if(result_body = "undefined")return;
        if(result_thorax = "undefined")return;
        if(result_chest = "undefined")return;
        if(result_upp_chest = "undefined")return;
    for (k = 0; k < 12; k++)   {
        if(active && inaccuracy > 0.3 && spread > 0.3 && weapon_name == "scar 20" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health / 3)}
        else if(active && inaccuracy < 0.3 && spread < 0.3 && weapon_name == "scar 20" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, (health / 2) + 3)}
        else if(UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap") && weapon_name == "scar 20" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health)}
        else if(active && inaccuracy > 0.3 && spread > 0.3 && weapon_name == "g3sg1" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health / 3)}
        else if(active && inaccuracy < 0.3 && spread < 0.3 && weapon_name == "g3sg1" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, (health / 2) + 3)}
        else if(UI.IsHotkeyActive("Rage", "GENERAL", "Exploits", "Doubletap") && weapon_name == "g3sg1" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health)}
        else if(inaccuracy > 0.5 && spread > 0.5 && weapon_name == "r8 revolver" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health / 3)}
        else if(inaccuracy > 0.2 && spread > 0.2 && weapon_name == "r8 revolver" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health / 2)}
        else if(inaccuracy < 0.15 && spread < 0.15 && weapon_name == "r8 revolver" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health)}
        else if(inaccuracy > 0.5 && spread > 0.5  && weapon_name == "awp"){
            Ragebot.OverrideMinimumDamage(k, health / 3)}
        else if(inaccuracy > 0.2 && spread > 0.2  && weapon_name == "awp"){
            Ragebot.OverrideMinimumDamage(k, health / 2)}
        else if((result_head > 0.80 || result_body > 0.85 || result_thorax > 0.85 || result_chest > 0.85 || result_upp_chest > 0.85)  && weapon_name == "awp" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health)}
        else if((result_head < 0.80 || result_body < 0.85 || result_thorax < 0.85 || result_chest < 0.85 || result_upp_chest < 0.85)  && weapon_name == "awp" && Entity.IsAlive(target) && Entity.IsValid(target)){
            Ragebot.OverrideMinimumDamage(k, health * 0.75)}
}
}
Cheat.RegisterCallback("CreateMove", "u9uy2bASDjk")

var screen_size = Render.GetScreenSize();

function calc_dist(a, b) {
    x = a[0] - b[0];
    y = a[1] - b[1];
    z = a[2] - b[2];
    return Math.sqrt(x * x + y * y + z * z);
}

function draw()
{
	var weapons = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
    var local_player = Entity.GetLocalPlayer();
    if (!Entity.IsAlive(local_player)) return;
	if (weapons != 'r8 revolver') {
        return
    };
            color = [168, 50, 66, 255];
			color1 = [61, 235, 52, 255];
			 var LocalPlayerIndex = Entity.GetLocalPlayer();
            var enemies = Entity.GetEnemies();
            for (var i = 0; i < enemies.length; i++)
            {
                if (Entity.IsAlive(enemies[i]) && Entity.IsValid(enemies[i]) && !Entity.IsDormant(enemies[i]))
                {
					 const no_kevlar = Entity.GetProp(enemies[i],"CCSPlayerResource", "m_iArmor") == 0
					 	if (!no_kevlar) {
					if(get_metric_distance(Entity.GetRenderOrigin(Entity.GetLocalPlayer()), Entity.GetRenderOrigin(enemies[i])) < 15) {
					hitbox_pos = Entity.GetHitboxPosition(enemies[i], 2); // change hitbox here https://www.onetap.com/scripting/gethitboxposition.77/
                    wts_hitbox = Render.WorldToScreen(hitbox_pos);
                    //Cheat.Print(wts_hitbox + "\n")
                    Render.Line(screen_size[0] / 2, screen_size[1] / 2, wts_hitbox[0], wts_hitbox[1], color);
					} 
					} 
					
						if (no_kevlar) {
					if(get_metric_distance(Entity.GetRenderOrigin(Entity.GetLocalPlayer()), Entity.GetRenderOrigin(enemies[i])) < 15) {
					hitbox_pos = Entity.GetHitboxPosition(enemies[i], 2); // change hitbox here https://www.onetap.com/scripting/gethitboxposition.77/
                    wts_hitbox = Render.WorldToScreen(hitbox_pos);
                    //Cheat.Print(wts_hitbox + "\n")
                    Render.Line(screen_size[0] / 2, screen_size[1] / 2, wts_hitbox[0], wts_hitbox[1], color1);
					} 
					}
            }
        }
}

Cheat.RegisterCallback("Draw", "draw");

function r8101 (){
	var weapons = Entity.GetName(Entity.GetWeapon(Entity.GetLocalPlayer()));
	if (weapons != 'r8 revolver') {
        return
    };
	var LocalPlayerIndex = Entity.GetLocalPlayer();
            var enemies = Entity.GetEnemies();
            for (var i = 0; i < enemies.length; i++)
            {
                if (Entity.IsAlive(enemies[i]) && Entity.IsValid(enemies[i]) && !Entity.IsDormant(enemies[i]))
                {
					 const no_kevlar = Entity.GetProp(enemies[i],"CCSPlayerResource", "m_iArmor") == 0
					 	if (no_kevlar) {
							if(get_metric_distance(Entity.GetRenderOrigin(Entity.GetLocalPlayer()), Entity.GetRenderOrigin(enemies[i])) < 15) {
							Ragebot.ForceTargetMinimumDamage(enemies[i], 101)
							} else return;
						}
}
			}
}
Cheat.RegisterCallback("CreateMove", "r8101")


function closestTarget() {
    var local = Entity.GetLocalPlayer();
    var enemies = Entity.GetEnemies();
    var dists = [];
    var damage = [];
    for(e in enemies) {
        if(!Entity.IsAlive(enemies[e]) || Entity.IsDormant(enemies[e]) || !Entity.IsValid(enemies[e])) continue;
        dists.push([enemies[e], calcDist(Entity.GetHitboxPosition(local, 0), Entity.GetHitboxPosition(enemies[e], 0))]);
    }
    dists.sort(function(a, b)
    {
        return a[1] - b[1];
    });
    if(dists.length == 0 || dists == []) return target = -1; 
    return dists[0][0];
}

// clean dist func, thanks rzr
function calcDist(a, b)
{
    x = a[0] - b[0];
    y = a[1] - b[1];
    z = a[2] - b[2];
    return Math.sqrt( x * x + y * y + z * z );
}

Cheat.PrintChat(' \x0e• [Chr1s解析器V3] 注入成功!(控制台有介绍). \n');
Cheat.PrintChat(' \x0c       最后更新时间：2021年3月30日. \n');
var isname = Cheat.GetUsername();
			Cheat.PrintColor([117, 112, 255, 255], '• 你使用的东西来自北落\n');
			Cheat.PrintColor([117, 112, 255, 255], '• 倒卖死个妈妈 \n');
			Cheat.PrintColor([117, 112, 255, 255], '• 我的联系方式： \n');
			Cheat.PrintColor([117, 112, 255, 255], '• QQ：2493798279 \n');
			Cheat.PrintColor([117, 112, 255, 255], '• 欢迎你来购买，玩得开心: ' + isname + '\n');


function get_metric_distance(a, b)
{
    return Math.floor(Math.sqrt(Math.pow(a[0] - b[0], 2) + Math.pow(a[1] - b[1], 2) + Math.pow(a[2] - b[2], 2)) * 0.0254 );
}