-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, vector
    = minetest, nodecore, vector
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()


local optics = "nc_optics"

local txr = optics .. "_glass_frost.png"
local pact = optics .. "_port_active.png"
local pout = optics .. "_port_output.png"
local pinp = optics .. "_port_wide.png"
local pina = optics .. "_port_wide_act.png"

local function transistor_check_and(_, node, recv)
	local face = nodecore.facedirs[node.param2]
	local rl_and = recv(face.r) and recv(face.l)
	local rl_or = recv(face.r) or recv(face.l)
	if recv(face.f) then
		if not(rl_and) then
			return modname .. ":transistor_and_on"
		end
	else
        if rl_and then
			return modname .. ":transistor_and_on"
		end
	end
	return modname .. ":transistor_and"
end

local function transistor_check_xor(_, node, recv)
	local face = nodecore.facedirs[node.param2]
	local rl = recv(face.r) and recv(face.l)
	if recv(face.f) then
		if rl then
			return modname .. ":transistor_xor_on"
		end
	else
		if not(rl) and (recv(face.r) or recv(face.l)) then
			return modname .. ":transistor_xor_on"
		end
	end
	return modname .. ":transistor_xor"
end

local basedef_transistor_and = {
	description = "Transistor AND/NAND",
	drawtype = "mesh",
	mesh = modname .. "_transistor.obj",
	selection_box = nodecore.fixedbox(
		{-7/16, -7/16, -7/16, 7/16, 7/16, 7/16}
	),
	tiles = {
		txr,
		txr .. "^" .. pout,
		txr .. "^" .. pinp
	},
	backface_culling = true,
	groups = {
		silica = 1,
		optic_check = 1,
		cracky = 3,
		silica_prism = 1,
		scaling_time = 125,
		optic_gluable = 1
	},
	silktouch = false,
	drop = modname .. ":transistor_and",
	on_construct = nodecore.optic_check,
	on_destruct = nodecore.optic_check,
	on_spin = nodecore.optic_check,
	optic_check = transistor_check_and,
	paramtype = "light",
	paramtype2 = "facedir",
	on_rightclick = nodecore.node_spin_filtered(function(a, b)
			return vector.equals(a.f, b.r)
			and vector.equals(a.r, b.f)
			and vector.equals(a.l, b.l)
		end),
	sounds = nodecore.sounds("nc_optics_glassy")
}

local function reg_and(suff, def)
	minetest.register_node(modname .. ":transistor_and" .. suff,
		nodecore.underride(def, basedef_transistor_and))
end

reg_and("", {})
local active_tr_and = {
		description = "Active Transistor AND/NAND",
		tiles = {
			txr .. "^(" .. pact .. "^[opacity:96)",
			txr .. "^" .. pact .. "^" .. pout,
			txr .. "^" .. pinp .. "^" .. pina
		},
		light_source = 1,
		groups = {optic_source = 1},
		optic_source = function(_, node)
			local fd = nodecore.facedirs[node.param2]
			return {fd.k}
		end
	}
reg_and("_on", active_tr_and)

local basedef_transistor_xor = {
	description = "Transistor XOR/XNOR",
	drawtype = "mesh",
	mesh = modname .. "_transistor.obj",
	selection_box = nodecore.fixedbox(
		{-7/16, -7/16, -7/16, 7/16, 7/16, 7/16}
	),
	tiles = {
		txr,
		txr .. "^" .. pout,
		txr .. "^" .. pinp
	},
	backface_culling = true,
	groups = {
		silica = 1,
		optic_check = 1,
		cracky = 3,
		silica_prism = 1,
		scaling_time = 125,
		optic_gluable = 1
	},
	silktouch = false,
	drop = modname .. ":transistor_xor",
	on_construct = nodecore.optic_check,
	on_destruct = nodecore.optic_check,
	on_spin = nodecore.optic_check,
	optic_check = transistor_check_xor,
	paramtype = "light",
	paramtype2 = "facedir",
	on_rightclick = nodecore.node_spin_filtered(function(a, b)
			return vector.equals(a.f, b.r)
			and vector.equals(a.r, b.f)
			and vector.equals(a.l, b.l)
		end),
	sounds = nodecore.sounds("nc_optics_glassy")
}

local function reg_xor(suff, def)
	minetest.register_node(modname .. ":transistor_xor" .. suff,
		nodecore.underride(def, basedef_transistor_xor))
end

local active_tr_xor = {
    description = "Active Transistor XOR/XNOR",
    tiles = {
        txr .. "^(" .. pact .. "^[opacity:96)",
        txr .. "^" .. pact .. "^" .. pout,
        txr .. "^" .. pinp .. "^" .. pina
    },
    light_source = 1,
    groups = {optic_source = 1},
    optic_source = function(_, node)
        local fd = nodecore.facedirs[node.param2]
        return {fd.k}
    end
	}

reg_xor("", {})
reg_xor("_on", active_tr_xor)

