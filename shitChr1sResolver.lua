local angles_tab = {}
local dragging_2 = (function() local a={} local b,c,d,e,f,g,h,i,j,k,l,m,n,o,dg; local p={__index={drag=function(self,...) local q,r=self:get() local s,t=a.drag(q,r,...) if q~=s or r~=t then self:set(s,t) end; return s,t end, set=function(self,q,r) local j,k = client.screen_size() ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res) end, get=function(self) local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}} function a.new(u,v,w,x)x=x or 10000; local j,k=client.screen_size() local y=ui.new_slider("LUA","A",u.." window position 2",0,x,v/j*x) local z=ui.new_slider("LUA","A","\n"..u.." window position y 2",0,x,w/k*x) ui.set_visible(y,false) ui.set_visible(z,false) return setmetatable({name = u,x_reference = y,y_reference = z,res = x},p) end; function a.drag(q,r,A,B,C,D,E) if globals.framecount()~=b then c = ui.is_menu_open() f,g=d,e; d,e=ui.mouse_position() i=h; h=client.key_state(0x01)==true; m=l; l={} o=n; n=false; j,k=client.screen_size() end; if c and i~=nil then if (not i or o) and h and f>q and g>r and f<q+A and g<r+B then n=true; q,r=q+d-f,r+e-g; if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r)) end end if f>=q and g>=r and f<=q+A and g<=r+B then dg = true else dg = false end else  f,g,d,e = 0,0,0,0 dg = false end; table.insert(l,{q,r,A,B}) return q,r,A,B end;function a.match() return dg end;return a end)()
local hk_dragger = dragging_2.new("Running Chr1s Resolver Indicators", 500, 600)
local enabled_resolver = ui.new_checkbox("Rage", "Other", "[Rage] Resolver")
local enabled_resolver_hotkey = ui.new_hotkey("Rage", "Other", "\n [Rage]Resolver Hotkey", true)
local resolver_types = ui.new_combobox("Rage", "Other", "\n [Rage]Resolver Types", {"Correction", "Extra Extended", "Adaptive Correction", "Customized Angles"})
for i = 1, 6 do
	angles_tab[i] = {
		angle_slider = ui.new_slider("Rage", "Other", "Correction Angle Slider [Miss X/" .. i .. "]", - 60, 60, 0)
	}
end

local draw_indicator = ui.new_checkbox("Rage", "Other", "[Rage]Resolver Targets Indicators")
local indicator_types = ui.new_combobox("Rage", "Other", "\n [Rage]Resolver Indicators Types", {"Default", "New"})
local indicator_color = ui.new_color_picker("Rage", "Other", "[Rage]Global Color C_S", 0, 255, 255, 255)
local reset_player_data = ui.reference("Players", "Players", "Reset all")

local history = {}
local _V3_MT = {}
local jitter_delta = 15
local miss_number = 0
local missed_target = {}
local missed_number = {}
local player_direction = {}
_V3_MT.__index = _V3_MT
for i = 1, 64 do
	missed_target[i] = 0
	missed_number[i] = miss_number
end

function Vector3( x, y, z )
	if (type(x) ~= "number") then
		x = 0.0;
	end

	if (type(y) ~= "number") then
		y = 0.0;
	end

	if (type(z) ~= "number") then
		z = 0.0;
	end

	x = x or 0.0
	y = y or 0.0
	z = z or 0.0
	return setmetatable({x = x, y = y, z = z}, _V3_MT)
end

function _V3_MT.__eq(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

function _V3_MT.__unm(a)
	return Vector3(
		-a.x,
		-a.y,
		-a.z
	)
end

function _V3_MT.__add(a, b)
	local a_type = type(a)
	local b_type = type(b)
	if (a_type == "table" and b_type == "table") then
		return Vector3(
			a.x + b.x,
			a.y + b.y,
			a.z + b.z
		)

	elseif (a_type == "table" and b_type == "number") then
		return Vector3(
			a.x + b,
			a.y + b,
			a.z + b
		)

	elseif (a_type == "number" and b_type == "table") then
		return Vector3(
			a + b.x,
			a + b.y,
			a + b.z
		)
	end
end

function _V3_MT.__sub(a, b)
	local a_type = type(a)
	local b_type = type(b)
	if (a_type == "table" and b_type == "table") then
		return Vector3(
			a.x - b.x,
			a.y - b.y,
			a.z - b.z
		)

	elseif (a_type == "table" and b_type == "number") then
		return Vector3(
			a.x - b,
			a.y - b,
			a.z - b
		)

	elseif (a_type == "number" and b_type == "table") then
		return Vector3(
			a - b.x,
			a - b.y,
			a - b.z
		)
	end
end

function _V3_MT.__mul(a, b)
	local a_type = type(a)
	local b_type = type(b)
	if (a_type == "table" and b_type == "table") then
		return Vector3(
			a.x * b.x,
			a.y * b.y,
			a.z * b.z
		)

	elseif (a_type == "table" and b_type == "number") then
		return Vector3(
			a.x * b,
			a.y * b,
			a.z * b
		)

	elseif (a_type == "number" and b_type == "table") then
		return Vector3(
			a * b.x,
			a * b.y,
			a * b.z
		)
	end
end

function _V3_MT.__div(a, b)
	local a_type = type(a)
	local b_type = type(b)
	if (a_type == "table" and b_type == "table") then
		return Vector3(
			a.x / b.x,
			a.y / b.y,
			a.z / b.z
		)

	elseif (a_type == "table" and b_type == "number") then
		return Vector3(
			a.x / b,
			a.y / b,
			a.z / b
		)

	elseif (a_type == "number" and b_type == "table") then
		return Vector3(
			a / b.x,
			a / b.y,
			a / b.z
		)
	end
end

function _V3_MT.__tostring(a)
	return "(" .. a.x .. ", " .. a.y .. ", " .. a.z .. ")"
end

function _V3_MT:clear()
	self.x = 0.0
	self.y = 0.0
	self.z = 0.0
end

function _V3_MT:unpack()
	return self.x, self.y, self.z
end

function _V3_MT:length_2d_sqr()
	return (self.x * self.x) + (self.y * self.y)
end

function _V3_MT:length_sqr()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z)
end

function _V3_MT:length_2d()
	return math.sqrt(self:length_2d_sqr())
end

function _V3_MT:length()
	return math.sqrt(self:length_sqr())
end

function _V3_MT:dot(other)
	return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
end

function _V3_MT:cross(other)
	return Vector3(
		(self.y * other.z) - (self.z * other.y),
		(self.z * other.x) - (self.x * other.z),
		(self.x * other.y) - (self.y * other.x)
	)
end

function _V3_MT:dist_to(other)
	return (other - self):length()
end

function _V3_MT:is_zero(tolerance)
	tolerance = tolerance or 0.001
	if (self.x < tolerance and self.x > -tolerance and self.y < tolerance and self.y > -tolerance and self.z < tolerance and self.z > -tolerance) then
		return true
	end

	return false
end

function _V3_MT:normalize()
	local l = self:length()
	if (l <= 0.0) then
		return 0.0
	end

	self.x = self.x / l
	self.y = self.y / l
	self.z = self.z / l
	return l
end

function _V3_MT:normalize_no_len()
	local l = self:length()
	if (l <= 0.0) then
		return
	end

	self.x = self.x / l
	self.y = self.y / l
	self.z = self.z / l
end

function _V3_MT:normalized()
	local l = self:length()
	if (l <= 0.0) then
		return Vector3()
	end

	return Vector3(
		self.x / l,
		self.y / l,
		self.z / l
	)
end

function clamp(cur_val, min_val, max_val)
	if (cur_val < min_val) then
		return min_val
	elseif (cur_val > max_val) then
		return max_val
	end

	return cur_val
end

function normalize_angle(angle)
	local str
	local out
	str = tostring(angle)
	if (str == "nan" or str == "inf") then
		return 0.0
	end

	if (angle >= -180.0 and angle <= 180.0) then
		return angle
	end

	out = math.fmod(math.fmod(angle + 360.0, 360.0), 360.0)
	if (out > 180.0) then
		out = out - 360.0
	end

	return out
end

function vector_to_angle(forward)
	local l
	local pitch
	local yaw
	l = forward:length()
	if(l > 0.0) then
		pitch = math.deg(math.atan(-forward.z, l))
		yaw   = math.deg(math.atan(forward.y, forward.x))
	else
		if (forward.x > 0.0) then
			pitch = 270.0
		else
			pitch = 90.0
		end

		yaw = 0.0
	end

	return Vector3(pitch, yaw, 0.0)
end

function angle_forward(angle)
	local sin_pitch = math.sin(math.rad(angle.x))
	local cos_pitch = math.cos(math.rad(angle.x))
	local sin_yaw   = math.sin(math.rad(angle.y))
	local cos_yaw   = math.cos(math.rad(angle.y))
	return Vector3(
		cos_pitch * cos_yaw,
		cos_pitch * sin_yaw,
		-sin_pitch
	)
end

function angle_right(angle)
	local sin_pitch = math.sin(math.rad(angle.x ))
	local cos_pitch = math.cos(math.rad(angle.x ))
	local sin_yaw = math.sin(math.rad(angle.y ))
	local cos_yaw = math.cos(math.rad(angle.y))
	local sin_roll = math.sin(math.rad(angle.z))
	local cos_roll = math.cos(math.rad(angle.z))
	return Vector3(
		-1.0 * sin_roll * sin_pitch * cos_yaw + -1.0 * cos_roll * -sin_yaw,
		-1.0 * sin_roll * sin_pitch * sin_yaw + -1.0 * cos_roll * cos_yaw,
		-1.0 * sin_roll * cos_pitch
	)
end

function angle_up(angle)
	local sin_pitch = math.sin(math.rad(angle.x))
	local cos_pitch = math.cos(math.rad(angle.x))
	local sin_yaw = math.sin(math.rad(angle.y))
	local cos_yaw = math.cos(math.rad( angle.y))
	local sin_roll = math.sin(math.rad(angle.z))
	local cos_roll = math.cos(math.rad(angle.z))
	return Vector3(
		cos_roll * sin_pitch * cos_yaw + -sin_roll * -sin_yaw,
		cos_roll * sin_pitch * sin_yaw + -sin_roll * cos_yaw,
		cos_roll * cos_pitch
	)
end

function get_FOV(view_angles, start_pos, end_pos)
	local type_str
	local fwd
	local delta
	local fov
	fwd = angle_forward(view_angles)
	delta = (end_pos - start_pos):normalized()
	fov = math.acos(fwd:dot(delta) / delta:length())
	return math.max(0.0, math.deg(fov))
end

local line_goes_through_smoke

do
	local success, match = client.find_signature("client_panorama.dll", "\x55\x8B\xEC\x83\xEC\x08\x8B\x15\xCC\xCC\xCC\xCC\x0F\x57")

	if success and match ~= nil then
		local lgts_type = ffi.typeof("bool(__thiscall*)(float, float, float, float, float, float, short);")
		line_goes_through_smoke = ffi.cast(lgts_type, match)
	end
end

function math.round(number, precision)
	local mult = 10 ^ (precision or 0)
	return math.floor(number * mult + 0.5) / mult
end

local angle_c = {}
local angle_mt = {
	__index = angle_c
}

angle_mt.__call = function(angle, p_new, y_new, r_new)
	p_new = p_new or angle.p
	y_new = y_new or angle.y
	r_new = r_new or angle.r
	angle.p = p_new
	angle.y = y_new
	angle.r = r_new
end

local function angle(p, y, r)
	return setmetatable(
		{
			p = p or 0,
			y = y or 0,
			r = r or 0
		},
		angle_mt
	)
end

function angle_c:set(p, y, r)
	p = p or self.p
	y = y or self.y
	r = r or self.r
	self.p = p
	self.y = y
	self.r = r
end

function angle_c:offset(p, y, r)
	p = self.p + p or 0
	y = self.y + y or 0
	r = self.r + r or 0
	self.p = self.p + p
	self.y = self.y + y
	self.r = self.r + r
end

function angle_c:clone()
	return setmetatable(
		{
			p = self.p,
			y = self.y,
			r = self.r
		},
		angle_mt
	)
end

function angle_c:clone_offset(p, y, r)
	p = self.p + p or 0
	y = self.y + y or 0
	r = self.r + r or 0

	return angle(
		self.p + p,
		self.y + y,
		self.r + r
	)
end

function angle_c:clone_set(p, y, r)
	p = p or self.p
	y = y or self.y
	r = r or self.r

	return angle(
		p,
		y,
		r
	)
end

function angle_c:unpack()
	return self.p, self.y, self.r
end

function angle_c:nullify()
	self.p = 0
	self.y = 0
	self.r = 0
end

function angle_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

function angle_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

function angle_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a + operand_b.p,
			operand_a + operand_b.y,
			operand_a + operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p + operand_b,
			operand_a.y + operand_b,
			operand_a.r + operand_b
		)
	end

	return angle(
		operand_a.p + operand_b.p,
		operand_a.y + operand_b.y,
		operand_a.r + operand_b.r
	)
end

function angle_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a - operand_b.p,
			operand_a - operand_b.y,
			operand_a - operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p - operand_b,
			operand_a.y - operand_b,
			operand_a.r - operand_b
		)
	end

	return angle(
		operand_a.p - operand_b.p,
		operand_a.y - operand_b.y,
		operand_a.r - operand_b.r
	)
end

function angle_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a * operand_b.p,
			operand_a * operand_b.y,
			operand_a * operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p * operand_b,
			operand_a.y * operand_b,
			operand_a.r * operand_b
		)
	end

	return angle(
		operand_a.p * operand_b.p,
		operand_a.y * operand_b.y,
		operand_a.r * operand_b.r
	)
end

function angle_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a / operand_b.p,
			operand_a / operand_b.y,
			operand_a / operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p / operand_b,
			operand_a.y / operand_b,
			operand_a.r / operand_b
		)
	end

	return angle(
		operand_a.p / operand_b.p,
		operand_a.y / operand_b.y,
		operand_a.r / operand_b.r
	)
end

function angle_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			math.pow(operand_a, operand_b.p),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.r)
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			math.pow(operand_a.p, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.r, operand_b)
		)
	end

	return angle(
		math.pow(operand_a.p, operand_b.p),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.r, operand_b.r)
	)
end

function angle_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a % operand_b.p,
			operand_a % operand_b.y,
			operand_a % operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p % operand_b,
			operand_a.y % operand_b,
			operand_a.r % operand_b
		)
	end

	return angle(
		operand_a.p % operand_b.p,
		operand_a.y % operand_b.y,
		operand_a.r % operand_b.r
	)
end

function angle_mt.__unm(operand_a)
	return angle(
		-operand_a.p,
		-operand_a.y,
		-operand_a.r
	)
end

function angle_c:round_zero()
	self.p = math.floor(self.p + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.r = math.floor(self.r + 0.5)
end

function angle_c:round(precision)
	self.p = math.round(self.p, precision)
	self.y = math.round(self.y, precision)
	self.r = math.round(self.r, precision)
end

function angle_c:round_base(base)
	self.p = base * math.round(self.p / base)
	self.y = base * math.round(self.y / base)
	self.r = base * math.round(self.r / base)
end

function angle_c:rounded_zero()
	return angle(
		math.floor(self.p + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.r + 0.5)
	)
end

function angle_c:rounded(precision)
	return angle(
		math.round(self.p, precision),
		math.round(self.y, precision),
		math.round(self.r, precision)
	)
end

function angle_c:rounded_base(base)
	return angle(
		base * math.round(self.p / base),
		base * math.round(self.y / base),
		base * math.round(self.r / base)
	)
end

local vector_c = {}
local vector_mt = {
	__index = vector_c,
}

vector_mt.__call = function(vector, x_new, y_new, z_new)
	x_new = x_new or vector.x
	y_new = y_new or vector.y
	z_new = z_new or vector.z

	vector.x = x_new
	vector.y = y_new
	vector.z = z_new
end

local function vector(x, y, z)
	return setmetatable(
		{
			x = x or 0,
			y = y or 0,
			z = z or 0
		},

		vector_mt
	)
end

function vector_c:set(x_new, y_new, z_new)
	x_new = x_new or self.x
	y_new = y_new or self.y
	z_new = z_new or self.z

	self.x = x_new
	self.y = y_new
	self.z = z_new
end

function vector_c:offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	self.x = self.x + x_offset
	self.y = self.y + y_offset
	self.z = self.z + z_offset
end

function vector_c:clone()
	return setmetatable(
		{
			x = self.x,
			y = self.y,
			z = self.z
		},
		vector_mt
	)
end

function vector_c:clone_offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	return setmetatable(
		{
			x = self.x + x_offset,
			y = self.y + y_offset,
			z = self.z + z_offset
		},
		vector_mt
	)
end

function vector_c:clone_set(x_new, y_new, z_new)
	x_new = x_new or self.x
	y_new = y_new or self.y
	z_new = z_new or self.z

	return vector(
		x_new,
		y_new,
		z_new
	)
end

function vector_c:unpack()
	return self.x, self.y, self.z
end

function vector_c:nullify()
	self.x = 0
	self.y = 0
	self.z = 0
end

function vector_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

function vector_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

function vector_mt.__eq(operand_a, operand_b)
	return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

function vector_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
	end

	return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

function vector_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
	end

	return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end

function vector_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a + operand_b.x,
			operand_a + operand_b.y,
			operand_a + operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x + operand_b,
			operand_a.y + operand_b,
			operand_a.z + operand_b
		)
	end

	return vector(
		operand_a.x + operand_b.x,
		operand_a.y + operand_b.y,
		operand_a.z + operand_b.z
	)
end

function vector_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a - operand_b.x,
			operand_a - operand_b.y,
			operand_a - operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x - operand_b,
			operand_a.y - operand_b,
			operand_a.z - operand_b
		)
	end

	return vector(
		operand_a.x - operand_b.x,
		operand_a.y - operand_b.y,
		operand_a.z - operand_b.z
	)
end

function vector_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a * operand_b.x,
			operand_a * operand_b.y,
			operand_a * operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x * operand_b,
			operand_a.y * operand_b,
			operand_a.z * operand_b
		)
	end

	return vector(
		operand_a.x * operand_b.x,
		operand_a.y * operand_b.y,
		operand_a.z * operand_b.z
	)
end

function vector_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a / operand_b.x,
			operand_a / operand_b.y,
			operand_a / operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x / operand_b,
			operand_a.y / operand_b,
			operand_a.z / operand_b
		)
	end

	return vector(
		operand_a.x / operand_b.x,
		operand_a.y / operand_b.y,
		operand_a.z / operand_b.z
	)
end

function vector_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			math.pow(operand_a, operand_b.x),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.z)
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			math.pow(operand_a.x, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.z, operand_b)
		)
	end

	return vector(
		math.pow(operand_a.x, operand_b.x),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.z, operand_b.z)
	)
end

function vector_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a % operand_b.x,
			operand_a % operand_b.y,
			operand_a % operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x % operand_b,
			operand_a.y % operand_b,
			operand_a.z % operand_b
		)
	end

	return vector(
		operand_a.x % operand_b.x,
		operand_a.y % operand_b.y,
		operand_a.z % operand_b.z
	)
end

function vector_mt.__unm(operand_a)
	return vector(
		-operand_a.x,
		-operand_a.y,
		-operand_a.z
	)
end

function vector_c:length2_squared()
	return (self.x * self.x) + (self.y * self.y);
end

function vector_c:length2()
	return math.sqrt(self:length2_squared())
end

function vector_c:length_squared()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

function vector_c:length()
	return math.sqrt(self:length_squared())
end

function vector_c:dot_product(b)
	return (self.x * b.x) + (self.y * b.y) + (self.z * b.z)
end

function vector_c:cross_product(b)
	return vector(
		(self.y * b.z) - (self.z * b.y),
		(self.z * b.x) - (self.x * b.z),
		(self.x * b.y) - (self.y * b.x)
	)
end

function vector_c:distance2(destination)
	return (destination - self):length2()
end

function vector_c:distance(destination)
	return (destination - self):length()
end

function vector_c:distance_x(destination)
	return math.abs(self.x - destination.x)
end

function vector_c:distance_y(destination)
	return math.abs(self.y - destination.y)
end

function vector_c:distance_z(destination)
	return math.abs(self.z - destination.z)
end

function vector_c:in_range(destination, distance)
	return self:distance(destination) <= distance
end

function vector_c:round_zero()
	self.x = math.floor(self.x + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.z = math.floor(self.z + 0.5)
end

function vector_c:round(precision)
	self.x = math.round(self.x, precision)
	self.y = math.round(self.y, precision)
	self.z = math.round(self.z, precision)
end

function vector_c:round_base(base)
	self.x = base * math.round(self.x / base)
	self.y = base * math.round(self.y / base)
	self.z = base * math.round(self.z / base)
end

function vector_c:rounded_zero()
	return vector(
		math.floor(self.x + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.z + 0.5)
	)
end

function vector_c:rounded(precision)
	return vector(
		math.round(self.x, precision),
		math.round(self.y, precision),
		math.round(self.z, precision)
	)
end

function vector_c:rounded_base(base)
	return vector(
		base * math.round(self.x / base),
		base * math.round(self.y / base),
		base * math.round(self.z / base)
	)
end

function vector_c:normalize()
	local length = self:length()
	if (length ~= 0) then
		self.x = self.x / length
		self.y = self.y / length
		self.z = self.z / length
	else
		self.x = 0
		self.y = 0
		self.z = 1
	end
end

function vector_c:normalized_length()
	return self:length()
end

function vector_c:normalized()
	local length = self:length()
	if (length ~= 0) then
		return vector(
			self.x / length,
			self.y / length,
			self.z / length
		)
	else
		return vector(0, 0, 1)
	end
end

function vector_c:to_screen(only_within_screen_boundary)
	local x, y = renderer.world_to_screen(self.x, self.y, self.z)
	if (x == nil or y == nil) then
		return nil
	end

	if (only_within_screen_boundary == true) then
		local screen_x, screen_y = client.screen_size()

		if (x < 0 or x > screen_x or y < 0 or y > screen_y) then
			return nil
		end
	end

	return vector(x, y)
end

function vector_c:magnitude()
	return math.sqrt(
		math.pow(self.x, 2) +
			math.pow(self.y, 2) +
			math.pow(self.z, 2)
	)
end

function vector_c:angle_to(destination)
	local delta_vector = vector(destination.x - self.x, destination.y - self.y, destination.z - self.z)
	local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))
	local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
	local pitch = math.deg(math.atan2(-delta_vector.z, hyp))
	return angle(pitch, yaw)
end

function vector_c:lerp(destination, percentage)
	return self + (destination - self) * percentage
end

local function vector_internal_division(source, destination, m, n)
	return vector((source.x * n + destination.x * m) / (m + n),
		(source.y * n + destination.y * m) / (m + n),
		(source.z * n + destination.z * m) / (m + n))
end

function vector_c:trace_line_to(destination, skip_entindex)
	skip_entindex = skip_entindex or -1

	return client.trace_line(
		skip_entindex,
		self.x,
		self.y,
		self.z,
		destination.x,
		destination.y,
		destination.z
	)
end

function vector_c:trace_line_impact(destination, skip_entindex)
	skip_entindex = skip_entindex or -1

	local fraction, eid = client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y, destination.z)
	local impact = self:lerp(destination, fraction)

	return fraction, eid, impact
end

function vector_c:trace_line_skip_indices(destination, max_traces, callback)
	max_traces = max_traces or 10

	local fraction, eid = 0, -1
	local impact = self
	local i = 0

	while (max_traces >= i and fraction < 1 and ((eid > -1 and callback(eid)) or impact == self)) do
		fraction, eid, impact = impact:trace_line_impact(destination, eid)
		i = i + 1
	end

	return self:distance(impact) / self:distance(destination), eid, impact
end

function vector_c:trace_line_skip_class(destination, skip_classes, skip_distance)
	local should_skip = function(index, skip_entity)
		local class_name = entity.get_classname(index) or ""
		for i in 1, #skip_entity do
			if class_name == skip_entity[i] then
				return true
			end
		end

		return false
	end

	local angles = self:angle_to(destination)
	local direction = angles:to_forward_vector()
	local last_traced_position = self
	while true do
		local fraction, hit_entity = last_traced_position:trace_line_to(destination)
		if fraction == 1 and hit_entity == -1 then  -- If we didn't hit anything.
			return 1, -1
		else
			if should_skip(hit_entity, skip_classes) then  -- If entity should be skipped.
				last_traced_position = vector_internal_division(self, destination, fraction, 1 - fraction)
				last_traced_position = last_traced_position + direction * skip_distance
			else
				return fraction, hit_entity, self:lerp(destination, fraction)
			end
		end
	end
end

function vector_c:trace_bullet_to(destination, eid)
	return client.trace_bullet(
		eid,
		self.x,
		self.y,
		self.z,
		destination.x,
		destination.y,
		destination.z
	)
end

function vector_c:closest_ray_point(ray_start, ray_end)
	local to = self - ray_start
	local direction = ray_end - ray_start
	local length = direction:length()
	direction:normalize()
	local ray_along = to:dot_product(direction)
	if (ray_along < 0) then
		return ray_start
	elseif (ray_along > length) then
		return ray_end
	end

	return ray_start + direction * ray_along
end

function vector_c:ray_divided(ray_end, ratio)
	return (self * ratio + ray_end) / (1 + ratio)
end

function vector_c:ray_segmented(ray_end, segments)
	local points = {}

	for i = 0, segments do
		points[i] = vector_internal_division(self, ray_end, i, segments - i)
	end

	return points
end

function vector_c:ray(ray_end, total_segments)
	total_segments = total_segments or 128
	local segments = {}
	local step = self:distance(ray_end) / total_segments
	local angle = self:angle_to(ray_end)
	local direction = angle:to_forward_vector()

	for i = 1, total_segments do
		table.insert(segments, self + (direction * (step * i)))
	end

	local src_screen_position = vector(0, 0, 0)
	local dst_screen_position = vector(0, 0, 0)
	local src_in_screen = false
	local dst_in_screen = false

	for i = 1, #segments do
		src_screen_position = segments[i]:to_screen()
		if src_screen_position ~= nil then
			src_in_screen = true
			break
		end
	end

	for i = #segments, 1, -1 do
		dst_screen_position = segments[i]:to_screen()
		if dst_screen_position ~= nil then
			dst_in_screen = true
			break
		end
	end

	if src_in_screen and dst_in_screen then
		return src_screen_position, dst_screen_position
	end

	return nil
end

function vector_c:ray_intersects_smoke(ray_end)
	if (line_goes_through_smoke == nil) then
		error("Unsafe scripts must be allowed in order to use vector_c:ray_intersects_smoke")
	end

	return line_goes_through_smoke(self.x, self.y, self.z, ray_end.x, ray_end.y, ray_end.z, 1)
end

function vector_c:inside_polygon2(polygon)
	local odd_nodes = false
	local polygon_vertices = #polygon
	local j = polygon_vertices

	for i = 1, polygon_vertices do
		if (polygon[i].y < self.y and polygon[j].y >= self.y or polygon[j].y < self.y and polygon[i].y >= self.y) then
			if (polygon[i].x + (self.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < self.x) then
				odd_nodes = not odd_nodes
			end
		end

		j = i
	end

	return odd_nodes
end

function vector_c:draw_circle(radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1
	local screen_x_line_old, screen_y_line_old
	for rot = start_degrees, percentage * 360, accuracy do
		local rot_temp = math.rad(rot)
		local lineX, lineY, lineZ = radius * math.cos(rot_temp) + self.x, radius * math.sin(rot_temp) + self.y, self.z
		local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~= nil and screen_x_line_old ~= nil then

			for i = 1, width do
				local i = i - 1
				renderer.line(screen_x_line, screen_y_line - i, screen_x_line_old, screen_y_line_old - i, r, g, b, a)
			end

			if outline then
				local outline_a = a / 255 * 160
				renderer.line(screen_x_line, screen_y_line - width, screen_x_line_old, screen_y_line_old - width, 16, 16, 16, outline_a)
				renderer.line(screen_x_line, screen_y_line + 1, screen_x_line_old, screen_y_line_old + 1, 16, 16, 16, outline_a)
			end
		end

		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

function vector_c:min(value)
	self.x = math.min(value, self.x)
	self.y = math.min(value, self.y)
	self.z = math.min(value, self.z)
end

function vector_c:max(value)
	self.x = math.max(value, self.x)
	self.y = math.max(value, self.y)
	self.z = math.max(value, self.z)
end

function vector_c:minned(value)
	return vector(
		math.min(value, self.x),
		math.min(value, self.y),
		math.min(value, self.z)
	)
end

function vector_c:maxed(value)
	return vector(
		math.max(value, self.x),
		math.max(value, self.y),
		math.max(value, self.z)
	)
end

function angle_c:to_forward_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	return vector(cp * cy, cp * sy, -sp)
end

function angle_c:to_up_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))
	return vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

function angle_c:to_right_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))
	return vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

function angle_c:to_backward_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	return -vector(cp * cy, cp * sy, -sp)
end

function angle_c:to_left_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))
	return -vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

function angle_c:to_down_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))
	return -vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

function angle_c:fov_to(source, destination)
	local fwd = self:to_forward_vector()
	local delta = (destination - source):normalized()
	local fov = math.acos(fwd:dot_product(delta) / delta:length())
	return math.max(0.0, math.deg(fov))
end

function angle_c:bearing(precision)
	local yaw = 180 - self.y + 90
	local degrees = (yaw % 360 + 360) % 360
	degrees = degrees > 180 and degrees - 360 or degrees
	return math.round(degrees + 180, precision)
end

function angle_c:start_degrees()
	local yaw = self.y
	local degrees = (yaw % 360 + 360) % 360
	degrees = degrees > 180 and degrees - 360 or degrees
	return degrees + 180
end

function angle_c:normalize()
	local pitch = self.p
	if (pitch < -89) then
		pitch = -89
	elseif (pitch > 89) then
		pitch = 89
	end

	local yaw = self.y
	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < -180 do
		yaw = yaw + 360
	end

	return angle(pitch, yaw, 0)
end

function angle_c:normalized()
	if (self.p < -89) then
		self.p = -89
	elseif (self.p > 89) then
		self.p = 89
	end

	local yaw = self.y
	while yaw > 180 do
		yaw = yaw - 360
	end

	while yaw < -180 do
		yaw = yaw + 360
	end

	self.y = yaw
	self.r = 0
end

function vector_c.draw_polygon(polygon, r, g, b, a, segments)
	for id, vertex in pairs(polygon) do
		local next_vertex = polygon[id + 1]
		if (next_vertex == nil) then
			next_vertex = polygon[1]
		end

		local ray_a, ray_b = vertex:ray(next_vertex, (segments or 64))
		if (ray_a ~= nil and ray_b ~= nil) then
			renderer.line(
				ray_a.x, ray_a.y,
				ray_b.x, ray_b.y,
				r, g, b, a
			)
		end
	end
end

function vector_c.eye_position(eid)
	local origin = vector(entity.get_origin(eid))
	local duck_amount = entity.get_prop(eid, "m_flDuckAmount") or 0
	origin.z = origin.z + 46 + (1 - duck_amount) * 18
	return origin
end

local callback_ui = function(e)
	for i = 1, 6 do
		ui.set_visible(angles_tab[i].angle_slider, ui.get(enabled_resolver) and ui.get(resolver_types) == "Customized Angles")
	end

	ui.set_visible(resolver_types, ui.get(enabled_resolver))
	ui.set_visible(draw_indicator, ui.get(enabled_resolver))
	ui.set_visible(enabled_resolver_hotkey, ui.get(enabled_resolver))
	ui.set_visible(indicator_color, ui.get(enabled_resolver) and ui.get(draw_indicator))
	ui.set_visible(indicator_types, ui.get(enabled_resolver) and ui.get(draw_indicator))
end

callback_ui()
ui.set_callback(resolver_types, callback_ui)
ui.set_callback(draw_indicator, callback_ui)
ui.set_callback(enabled_resolver, callback_ui)

local function switch_value(value, state, add_value)
	return state and (value - add_value) or - (value - add_value)
end

local function ent_speed_2d(index)
	local x, y, z = entity.get_prop(index, "m_vecVelocity")
	return math.sqrt(x * x + y * y)
end

local function jumping(ent)
	return bit.band(entity.get_prop(ent, "m_fFlags"), 1) == 1
end

local function sideways_data(enemy, lx, ly, lz)
	local dx, dy, dz = (vector(lx, ly, lz):angle_to(vector(entity.get_origin(enemy))) - angle(entity.get_prop(enemy, "m_angEyeAngles"))):unpack()
	local yaw_delta = math.abs(dy)
	if ((yaw_delta >= 80 and yaw_delta <= 100) or (yaw_delta >= 250 and yaw_delta <= 270) or (yaw_delta >= 430 and yaw_delta <= 460)) then
		return true
	end

	return false
end

local function extrapolate(player, x, y, z)
	local xv, yv, zv = entity.get_prop(player, "m_vecVelocity")
	local new_x = x + globals.tickinterval() * xv
	local new_y = y + globals.tickinterval() * yv
	local new_z = z + globals.tickinterval() * zv
	return new_x, new_y, new_z
end

local function sideways_player(enemy)
	local local_player = entity.get_local_player()
	local lox, loy, loz = entity.get_origin(local_player)
	local x1, y1, x2, y2 = entity.get_bounding_box(enemy)
	local lpx, lpy, lpz = extrapolate(local_player, lox, loy, loz)
	if sideways_data(enemy, lpx, lpy, lpz) then
		return true
	end

	return false
end

local function max_desync(entityindex)
	local spd = math.min(260, ent_speed_2d(entityindex))
	local walkfrac = math.max(0, math.min(1, spd / 135))
	local mult = 1 - 0.5 * walkfrac
	local duckamnt = entity.get_prop(entityindex, "m_flDuckAmount")
	if duckamnt > 0 then
		local duckfrac = math.max(0, math.min(1, spd / 88))
		mult = mult + ((duckamnt * duckfrac) * (0.5 - mult))
	end
	
	return math.floor((58 * mult))
end

local function player_direction(index)
	if entity.is_enemy(index) then
		local onground = jumping(index)
		if onground then
			local ohx, ohy, ohz = entity.hitbox_position(index, 1)
			local lx, ly = renderer.world_to_screen(ohx - 12, ohy, ohz)
			local rx, ry = renderer.world_to_screen(ohx + 12, ohy, ohz)
			local px, py, pz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
			local _, ldmg = client.trace_bullet(entity.get_local_player(), px, py, pz, ohx - 12, ohy, ohz)
			local _, rdmg = client.trace_bullet(entity.get_local_player(), px, py, pz, ohx + 12, ohy, ohz)
			if rdmg > ldmg then
				return "R"
			elseif rdmg < ldmg then
				return "L"
			end
		end
	end

	return "Unknown"
end

client.set_event_callback("aim_miss", function(target)
	if entity.get_steam64(target.target) < 1 or target.reason ~= "?" or not ui.get(enabled_resolver) or not ui.get(enabled_resolver_hotkey) then
		return
	end

	local player = entity.get_players(true)
	for i = 1, #player do
		local enemys = player[i]
		if target.target == enemys then
			missed_target[enemys] = target.target
			missed_number[enemys] = miss_number + 1
		end
	end
end)

client.set_event_callback("paint_ui", function(e)
	if not entity.is_alive(entity.get_local_player()) or not ui.get(enabled_resolver) or not ui.get(enabled_resolver_hotkey) then
		return
	end

	local active_players = 0
	local x, y =  hk_dragger:get()
	local player = entity.get_players(true)
	local weapon_r, weapon_g, weapon_b, weapon_a = ui.get(indicator_color)
	local alpha = 1 + math.sin(math.abs(- math.pi + globals.realtime() % (math.pi * 2))) * 254
	local pulse = 8 + math.sin(math.abs(- math.pi + (globals.realtime() * (0.6 / 1)) % (math.pi * 2))) * 12
	if ui.get(draw_indicator) then
		if ui.get(indicator_types) == "Default" then
			for i = 1, #player do
				if plist.get(player[i], "Force body yaw") or plist.get(player[i], "Override prefer body aim") == "Off" or plist.get(player[i], "Override safe point") == "Off" then
					active_players = active_players + 1
				end
			end

			local addiction_y = (#player * 10)
			client.draw_gradient(ctx, x + 5, y, 200, 10, 0, 0, 0, 20, 10, 10, 10, 30, true)
			client.draw_gradient(ctx, x, y, 205, 20 + addiction_y, 0, 0, 0, 200, 10, 10, 10, 30, true)
			client.draw_gradient(ctx, x, y - 2, 40 + pulse * 3, 2, weapon_r, weapon_g, weapon_b, 255, 25, 25, 25, 5, true)
			client.draw_gradient(ctx, x, y, pulse * 0.7, 20 + addiction_y, weapon_r, weapon_g, weapon_b, 255, 25, 25, 25, 5, true)
			client.draw_gradient(ctx, x, y + 20 + addiction_y, 120 + pulse * 5, 2, weapon_r, weapon_g, weapon_b, 255, 25, 25, 25, 20, true)
			renderer.text(x + 10, y + 3, 255, 155, 155, 180, "", 0, "RESOLVER")
			renderer.text(active_players <= 0 and x + 80 or x + 85, y + 3, active_players <= 0 and weapon_r or 255, active_players <= 0 and weapon_g or 155, active_players <= 0 and weapon_b or 155, alpha, "", 0, active_players <= 0 and "WAITING..." or "ACTIVE")
			renderer.text(x + 155, y + 3, 128, 183, 255, 255, "", 0, "   Chr1s")
		elseif ui.get(indicator_types) == "New" then
			local function draw_box_lines(x, y, w, h, r, g, b, a, r_2, g_2, b_2, a_2, dynamic_val)
				renderer.gradient(x, y, w, h + 5, 17, 17, 17, 50, 17, 17, 17, 50, true)
				renderer.gradient(x, y, (w / 2) + 1, 2, r, g, b, dynamic_val * a, r_2, g_2, b_2, a_2, true)
				renderer.gradient(x + w / 2, y, w - w / 2, 2, r, g, b, a, r_2, g_2, b_2, 0, true)
				renderer.gradient(x, y + 20, (w / 2) + 1 + 20, 2, r, g, b, 0, r_2, g_2, b_2, a_2, true)
				renderer.gradient(x + w / 2 + 20, y + 20, w - w / 2 - 20, 2, r, g, b, a, r_2, g_2, b_2, dynamic_val * a_2, true)
				renderer.gradient(x, y, 2, 20, r, g, b, a, r_2, g_2, b_2, dynamic_val * a_2, false)
				renderer.gradient(x + w - 2, y, 2, 20, r, g, b, dynamic_val * a, r_2, g_2, b_2, a_2, false)
			end

			local h, w = 17, renderer.measure_text(nil, "Resolver") + 158
			draw_box_lines(x + 3, y, w, h, weapon_r, weapon_g, weapon_b, weapon_a, weapon_r, weapon_g, weapon_b, weapon_a, (alpha / 255))
			renderer.text(x + w / 2 - 20, y + 5, 255, 255, 255, 255, "", 0, "RESOLVER")
		end
	end

	for i = 1, #player do
		local enemys = player[i]
		if entity.get_steam64(enemys) < 1 then
			plist.set(enemys, "Force body yaw", true)
			plist.set(enemys, "Correction active", false)
			plist.set(enemys, "Force body yaw value", 0)
		elseif sideways_player(enemys) then
			plist.set(enemys, "Override safe point", "Off")
			plist.set(enemys, "Override prefer body aim", "Off")
			if missed_target[enemys] == enemys and missed_number[enemys] == 0 then
				plist.set(enemys, "Force body yaw", false)
				plist.set(enemys, "Correction active", true)
				plist.set(enemys, "Force body yaw value", 0)
			elseif missed_target[enemys] == enemys and missed_number[enemys] == 1 then
				plist.set(enemys, "Force body yaw", true)
				plist.set(enemys, "Correction active", true)
				plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(19, 22) or max_desync(enemys), player_direction(enemys) == "R", 0))
			elseif missed_target[enemys] == enemys and missed_number[enemys] == 2 then
				plist.set(enemys, "Force body yaw", true)
				plist.set(enemys, "Correction active", true)
				plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(- 18, - 16) or max_desync(enemys), player_direction(enemys) == "R", 11))
			else
				plist.set(enemys, "Force body yaw", false)
				plist.set(enemys, "Correction active", true)
				plist.set(enemys, "Force body yaw value", 0)
			end

		elseif entity.get_steam64(enemys) >= 1 and not sideways_player(enemys) then
			plist.set(enemys, "Override safe point", "-")
			plist.set(enemys, "Override prefer body aim", "-")
			if ui.get(resolver_types) == "Correction" then
				local skeet_resolver_angles = math.min(58, entity.get_prop(enemys, "m_flPoseParameter", 11) * 120 - 60)
				if missed_target[enemys] == enemys and missed_number[enemys] == 0 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 1 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", - skeet_resolver_angles)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 2 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", skeet_resolver_angles)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 3 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", - skeet_resolver_angles)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 4 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", skeet_resolver_angles)
				else
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				end

			elseif ui.get(resolver_types) == "Extra Extended" then
				if missed_target[enemys] == enemys and missed_number[enemys] == 0 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 1 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(20, 24) or max_desync(enemys), player_direction(enemys) == "R", 0))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 2 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(- 20, - 24) or - max_desync(enemys), player_direction(enemys) == "R", 0))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 3 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(- 10, - 18) or - max_desync(enemys), player_direction(enemys) == "R", 0))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 4 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(10, 18) or max_desync(enemys), player_direction(enemys) == "R", 0))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 5 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", switch_value(player_direction(enemys) == "Unknown" and math.random(10, 36) or max_desync(enemys), player_direction(enemys) == "R", 0))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 6 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", 0)
				else
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				end

			elseif ui.get(resolver_types) == "Adaptive Correction" then
				local skeet_resolver_angles = math.min(58, entity.get_prop(enemys, "m_flPoseParameter", 11) * 120 - 60)
				if missed_target[enemys] == enemys and missed_number[enemys] == 0 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 1 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", skeet_resolver_angles)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 2 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", false)
					plist.set(enemys, "Force body yaw value", math.max(skeet_resolver_angles > 0 and (skeet_resolver_angles - 11) or (- skeet_resolver_angles - 10), - 58))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 3 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", - skeet_resolver_angles - 6)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 4 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", skeet_resolver_angles > 0 and math.min(skeet_resolver_angles + 7, 58) or math.min(skeet_resolver_angles + 6, 58))
				else
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				end

			elseif ui.get(resolver_types) == "Customized Angles" then
				if missed_target[enemys] == enemys and missed_number[enemys] == 0 then
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 1 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", ui.get(angles_tab[1].angle_slider))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 2 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", ui.get(angles_tab[2].angle_slider))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 3 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", ui.get(angles_tab[3].angle_slider))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 4 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", ui.get(angles_tab[4].angle_slider))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 5 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", ui.get(angles_tab[5].angle_slider))
				elseif missed_target[enemys] == enemys and missed_number[enemys] == 6 then
					plist.set(enemys, "Force body yaw", true)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", ui.get(angles_tab[6].angle_slider))
				else
					plist.set(enemys, "Force body yaw", false)
					plist.set(enemys, "Correction active", true)
					plist.set(enemys, "Force body yaw value", 0)
				end
			end
		end

		if not entity.is_alive(enemys) then
			missed_number[enemys] = 0
			plist.set(enemys, "Force body yaw", false)
			plist.set(enemys, "Correction active", true)
			plist.set(enemys, "Force body yaw value", 0)
		end

		if #player >= 1 and ui.get(draw_indicator) then
			local remove_state = ui.get(indicator_types) == "Default" and 10 or 0
			renderer.text(x + 10, y + 15 + (i * 10) - remove_state, 255, 155, 155, 180, "", 0, i)
			renderer.text(x + 25, y + 15 + (i * 10) - remove_state, 255, 155, 155, 180, "", 0, "Target: ")
			renderer.text(x + 65, y + 15 + (i * 10) - remove_state, 215, 155, 155, 210, "", 0, entity.get_player_name(enemys))
			renderer.text(x + 148, y + 15 + (i * 10) - remove_state, plist.get(enemys, "Force body yaw") and 255 or 0, plist.get(enemys, "Force body yaw") and 0 or 255, 0, 255, "", 0, "● ")
			renderer.text(x + 156, y + 15 + (i * 10) - remove_state, plist.get(enemys, "Force body yaw") and 255 or weapon_r, plist.get(enemys, "Force body yaw") and 155 or weapon_g, plist.get(enemys, "Force body yaw") and 155 or weapon_b, plist.get(enemys, "Force body yaw") and 180 or (weapon_a / 255) * alpha, "", 0, plist.get(enemys, "Force body yaw") and "Resolver" or "Waiting")
		end
	end

	hk_dragger:drag(200, ui.get(indicator_types) == "Default" and (20 + #player * 10) or 20)
end)

client.set_event_callback("player_hurt", function(e)
	if client.userid_to_entindex(e.attacker) ~= entity.get_local_player() or not entity.is_alive(entity.get_local_player()) or not ui.get(enabled_resolver) or not ui.get(enabled_resolver_hotkey) or not ui.get(draw_indicator) or not plist.get(client.userid_to_entindex(e.userid), "Force body yaw") then
		return
	end

	local weapon_r, weapon_g, weapon_b, weapon_a = ui.get(indicator_color)
	local hitgroup_names = {"身体", "头", "背后", "胃", "左手", "右手", "左脚", "右脚", "脖子", "?", "其他"}
	client.color_log(weapon_r, weapon_g, weapon_b, "[Chr1s.Lua] 成功解析 " .. entity.get_player_name(client.userid_to_entindex(e.userid)) .. ", 角度:" .. plist.get(client.userid_to_entindex(e.userid), "Force body yaw value") .. ", 部位: " .. (hitgroup_names[e.hitgroup + 1] or "?") .. ", 伤害: " .. e.dmg_health)
end)

local function reset_resolver_data(reset_possess_data)
	miss_number = 0
	missed_target = {}
	missed_number = {}
	ui.set(reset_player_data, reset_possess_data)
end

client.set_event_callback("round_start", function(r)
	reset_resolver_data(true)
end)

client.set_event_callback("client_disconnect", function(r)
	reset_resolver_data(true)
end)

client.set_event_callback("game_newmap", function(r)
	reset_resolver_data(true)
end)

client.set_event_callback("cs_game_disconnected", function(r)
	reset_resolver_data(true)
end)