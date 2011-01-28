-- GLSL Lua shaders for CubeCreate

local function lazyshader(stype, name, v, f)
	Shader.defer(stype, name, "Shader.normal(" .. stype .. ", \"" .. name .. "\", [[" .. v .. "]], [[" .. f .. "]])")
end

lmcoordscale = 1.0 / 32767.0

---------------------------------------------------
--
-- used for any textured polys that don't have a shader set
--
---------------------------------------------------

Shader.normal(4, "default",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_MultiTexCoord0;
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			gl_FragColor = gl_Color * texture2D(tex0, gl_TexCoord[0].xy);
		}
	]]
)

Shader.normal(4, "rect",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_MultiTexCoord0;
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0;
		void main(void)
		{
			gl_FragColor = gl_Color * texture2DRect(tex0, gl_TexCoord[0].xy);
		}
	]]
)

Shader.normal(4, "cubemap",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_MultiTexCoord0;
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		uniform samplerCube tex0;
		void main(void)
		{
			gl_FragColor = gl_Color * textureCube(tex0, gl_TexCoord[0].xyz);
		}
	]]
)

Shader.normal(4, "rgbonly",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_MultiTexCoord0;
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			gl_FragColor.rgb = gl_Color.rgb * texture2D(tex0, gl_TexCoord[0].xy).rgb;
			gl_FragColor.a   = gl_Color.a;
		}
	]]
)

----------------------------------------------------------------------
--
-- same, but now without texture sampling (some HUD stuff needs this)
--
----------------------------------------------------------------------

Shader.normal(4, "notexture",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_Color;
		}
	]]
)

Shader.normal(4, "notextureglsl",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_Color;
		}
	]]
)

----------------------------------------------------------------------
--
-- fogged variants of default shaders
--
----------------------------------------------------------------------

Shader.normal(4, "fogged",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_MultiTexCoord0;
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			gl_FragColor = gl_Color * texture2D(tex0, gl_TexCoord[0].xy);
		}
	]]
)

Shader.normal(4, "foggednotexture",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_Color;
		}
	]]
)

Shader.normal(4, "foggednotextureglsl",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_Color;
		}
	]]
)

----------------------------------------------------------------------
--
-- for filling the z-buffer only (i.e. multi-pass rendering, OQ)
--
----------------------------------------------------------------------

Shader.normal(4, "nocolor",
	[[
		void main() { gl_Position = ftransform(); } 
	]],
	[[
		void main() {}
	]]
)

Shader.normal(4, "nocolorglsl",
	[[
		void main() { gl_Position = ftransform(); } 
	]],
	[[
		void main() {}
	]]
)

--------------------------------------------------------
--
-- default lightmapped world shader.. does texcoord gen
--
-------------------------------------------------------

-- yay for cubescript-port hacks >.>
sworldargs = {}
gworldargs = {}

function worldshader(...)
	sworldargs = { ... }
	local stype = 4
	if string.find(sworldargs[1], "env") then stype = stype + 2 end
	Shader.normal(stype, sworldargs[1],
		[[
			#pragma CUBE2_fog
			<% if #sworldargs >= 5 then return sworldargs[5] end %>
			uniform vec4 texgenscroll;
			void main(void)
			{
				gl_Position = ftransform();
				gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + texgenscroll.xy;
				gl_TexCoord[1].xy = gl_MultiTexCoord1.xy * <%=lmcoordscale%>;

				<%=sworldargs[2]%>

				#pragma CUBE2_shadowmap
				#pragma CUBE2_dynlight
				#pragma CUBE2_water
			}
		]],
		[[
			<% if #sworldargs >= 5 then return sworldargs[5] end %>
			<% if #sworldargs >= 6 then return sworldargs[6] end %>
			uniform vec4 colorparams;
			uniform sampler2D diffusemap, lightmap;
			void main(void)
			{
				vec4 diffuse = texture2D(diffusemap, gl_TexCoord[0].xy);   
				vec4 lm = texture2D(lightmap, gl_TexCoord[1].xy);

				#pragma CUBE2_shadowmap lm
				#pragma CUBE2_dynlight lm

				<%=sworldargs[3]%>

				diffuse *= colorparams;
				<% if #sworldargs < 4 or sworldargs[4] == "" then return "gl_FragColor = diffuse * lm;" else return sworldargs[4] end %>

				#pragma CUBE2_water
			}
		]]
	)
end

function glareworldshader(...)
	gworldargs = { ... }
	Shader.variant(not string.find(gworldargs[1], "env") and 4 or 6, gworldargs[1], 4,
		[[
			#pragma CUBE2_fog
			<% if #gworldargs >= 4 then return gworldargs[4] end %>
			uniform vec4 texgenscroll;
			void main(void)
			{
				gl_Position = ftransform();
				gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + texgenscroll.xy;
				gl_TexCoord[1].xy = gl_MultiTexCoord1.xy * <%=lmcoordscale%>;

				<%=gworldargs[2]%>
			}
		]],
		[[
			<% if #gworldargs >= 4 then return gworldargs[4] end %>
			<% if #gworldargs >= 5 then return gworldargs[5] end %>
			uniform vec4 colorparams;
			uniform sampler2D diffusemap, lightmap;
			void main(void)
			{
				<%=gworldargs[3]%>
			}
		]]
	)
end

worldshader("stdworld", "", "")

Shader.defer(4, "decalworld",
	[[
		worldshader("decalworld", "",
			[=[
				vec4 diffuse2 = texture2D(decal, gl_TexCoord[0].xy);
				diffuse.rgb = mix(diffuse.rgb, diffuse2.rgb, diffuse2.a);
			]=], "", "", "uniform sampler2D decal;"
		)
	]]
)

Shader.defer(4, "glowworld",
	[[
		Shader.defUniformParam("glowcolor", 1, 1, 1) -- glow color
		worldshader("glowworld", "", "",
			[=[
				vec3 glow = texture2D(glowmap, gl_TexCoord[0].xy).rgb;
				glow *= glowcolor.rgb;
				gl_FragColor = diffuse*lm + vec4(glow, 0.0);
			]=], "", "uniform sampler2D glowmap;"
		)
		glareworldshader("glowworld", "",
			[=[
				vec3 glow = texture2D(glowmap, gl_TexCoord[0].xy).rgb;
				glow *= glowcolor.rgb;
				float k = max(glow.r, max(glow.g, glow.b)); 
				gl_FragColor.rgb = min(k*k*32.0, 1.0) * glow;
				#pragma CUBE2_variantoverride gl_FragColor.a = texture2D(lightmap, gl_TexCoord[1].xy).a; //
				gl_FragColor.a = colorparams.a;
			]=], "",
			[=[
				uniform sampler2D glowmap; 
				#pragma CUBE2_variant uniform sampler2D lightmap;
			]=]
		)
	]]
)

Shader.defer(4, "pulseworld",
	[[
		Shader.defUniformParam("pulsespeed", 1) -- pulsefrequency (Hz)
		worldshader("pulseworld",
			"pulse = abs(fract(millis.x * pulsespeed.x)*2.0 - 1.0);",
			[=[
				vec3 diffuse2 = texture2D(decal, gl_TexCoord[0].xy).rgb; 
				diffuse.rgb = mix(diffuse.rgb, diffuse2, pulse);
			]=], "",
			"uniform vec4 millis; varying float pulse;",
			"uniform sampler2D decal;"
		)
	]]
)

Shader.defer(4, "pulseglowworld",
	[[
		Shader.defUniformParam("glowcolor", 1, 1, 1) -- glow color
		Shader.defUniformParam("pulseglowspeed", 1) -- pulse frequency (Hz)
		Shader.defUniformParam("pulseglowcolor", 0, 0, 0) -- pulse glow color
		worldshader("pulseglowworld",
			[=[
				pulse = mix(glowcolor.rgb, pulseglowcolor.rgb, abs(fract(millis.x * pulseglowspeed.x)*2.0 - 1.0));
			]=], "",
			[=[
				vec3 glow = texture2D(glowmap, gl_TexCoord[0].xy).rgb;
				gl_FragColor = diffuse*lm + vec4(glow*pulse, 0.0);
			]=], "uniform vec4 millis; varying vec3 pulse;", "uniform sampler2D glowmap;"
		)
		glareworldshader("pulseglowworld",
			[=[
				pulse = mix(glowcolor.rgb, pulseglowcolor.rgb, abs(fract(millis.x * pulseglowspeed.x)*2.0 - 1.0));
			]=],
			[=[
				vec3 glow = texture2D(glowmap, gl_TexCoord[0].xy).rgb;
				glow *= pulse;
				float k = max(glow.r, max(glow.g, glow.b)); 
				gl_FragColor.rgb = min(k*k*32.0, 1.0) * glow;
				#pragma CUBE2_variantoverride gl_FragColor.a = texture2D(lightmap, gl_TexCoord[1].xy).a; //
				gl_FragColor.a = colorparams.a;
			]=], "uniform vec4 millis; varying vec3 pulse;",
			[=[
				uniform sampler2D glowmap; 
				#pragma CUBE2_variant uniform sampler2D lightmap;
			]=]
		)
	]]
)

Shader.normal(4, "fogworld",
	[[
		void main(void)
		{
			gl_Position = ftransform();
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_Fog.color;
		}
	]]
)

Shader.normal(4, "noglareworld",
	[[
		void main(void)
		{
			gl_Position = ftransform();
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = vec4(0.0);
		}
	]]
)

Shader.normal(4, "noglareblendworld",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0].xy = gl_MultiTexCoord1.xy * <%=lmcoordscale%>;
		}
	]],
	[[
		uniform sampler2D lightmap;
		void main(void)
		{
			gl_FragColor.rgb = vec3(0.0);
			gl_FragColor.a = texture2D(lightmap, gl_TexCoord[0].xy).a;
		}
	]]
)

Shader.normal(4, "noglarealphaworld",
	[[
		void main(void)
		{
			gl_Position = ftransform();
		}
	]],
	[[
		uniform vec4 colorparams;
		uniform sampler2D lightmap;
		void main(void)
		{
			gl_FragColor.rgb = vec3(0.0);
			gl_FragColor.a = colorparams.a;
		}
	]]
)

Shader.defer(6, "envworld",
	[[
		Shader.defUniformParam("envscale", 0.2, 0.2, 0.2) -- reflectivity
		worldshader("envworld",
			[=[
				normal = gl_Normal;
				camvec = camera.xyz - gl_Vertex.xyz; 
			]=],
			[=[
				vec3 reflect = textureCube(envmap, 2.0*normal*dot(camvec, normal) - camvec).rgb;
			]=],
			[=[
				diffuse *= lm;
				gl_FragColor.rgb = mix(diffuse.rgb, reflect, envscale.rgb);
				gl_FragColor.a = diffuse.a; 
			]=], "uniform vec4 camera; varying vec3 normal, camvec;", "uniform samplerCube envmap;"
		)

		Shader.defUniformParam("envscale", 0.2, 0.2, 0.2) -- reflectivity
		worldshader("envworldfast",
			[=[
				vec3 camvec = camera.xyz - gl_Vertex.xyz;
				rvec = 2.0*gl_Normal*dot(camvec, gl_Normal) - camvec;
			]=],
			[=[
				vec3 reflect = textureCube(envmap, rvec).rgb;
			]=],
			[=[
				diffuse *= lm;
				gl_FragColor.rgb = mix(diffuse.rgb, reflect, envscale.rgb);
				gl_FragColor.a = diffuse.a; 
			]=], "uniform vec4 camera; varying vec3 rvec;", "uniform samplerCube envmap;"
		)

		Shader.defUniformParam("envscale", 0.2, 0.2, 0.2) -- reflectivity
		worldshader("envworldalt", "", "")

		Shader.alt("envworld", "envworldalt")
		Shader.fast("envworld", "envworldfast", 2)
		Shader.fast("envworld", "envworldalt", 1)
	]]
)

Shader.normal(4, "depthfxworld",
	[[
		uniform vec4 depthscale, depthoffsets;
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = depthoffsets - (gl_ModelViewMatrix * gl_Vertex).z*depthscale;
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_TexCoord[0];
		}
	]]
)

Shader.normal(4, "depthfxsplitworld",
	[[
		uniform vec4 depthscale, depthoffsets;
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = depthoffsets - (gl_ModelViewMatrix * gl_Vertex).z*depthscale;
		}
	]],
	[[
		void main(void)
		{
			vec4 ranges = vec4(gl_TexCoord[0].x, fract(gl_TexCoord[0].yzw));
			ranges.xy -= ranges.yz*vec2(0.00390625, 0.00390625);
			gl_FragColor = ranges;
		}
	]]
)

-- bumptype:
--	e -> reserve envmap texture slot
--	o -> orthonormalize
--	t -> tangent space cam
--	r -> envmap reflection
--	R -> modulate envmap reflection with spec map
--	s -> spec
--	S -> spec map
--	p -> parallax
--	P -> steep parallax (7 steps)
--	g -> glow
--	G -> pulse glow
--	i -> glare intensity

function btopt(arg)
	return string.find(bumpvariantargs[2], arg) ~= nil
end

function bumpvariantshader(...)
	bumpvariantargs = { ... }
	local stype = btopt("e") and 7 or 5
	if not btopt("i") then
		if btopt("G") then
			Shader.defUniformParam("glowcolor", 1, 1, 1) -- glow color
			Shader.defUniformParam("pulseglowspeed", 1) -- pulse frequency (Hz)
			Shader.defUniformParam("pulseglowcolor", 0, 0, 0) -- pulse glow color
		elseif btopt("g") then
			Shader.defUniformParam("glowcolor", 1, 1, 1) -- glow color
		end

		if btopt("S") then
			Shader.defUniformParam("specscale", 6, 6, 6) -- spec map multiplier
		elseif btopt("s") then
			Shader.defUniformParam("specscale", 1, 1, 1) -- spec multiplier
		end

		if btopt("p") or btopt("P") then
			Shader.defUniformParam("parallaxscale", 0.06, -0.03) -- parallax scaling
		end

		if btopt("R") then
			Shader.defUniformParam("envscale", 1, 1, 1) -- reflectivity map multiplier
		elseif btopt("r") then
			Shader.defUniformParam("envscale", 0.2, 0.2, 0.2) -- reflectivity
		end
	elseif btopt("s") then
		stype = stype + 8
	end

	Shader.variant(stype, bumpvariantargs[1], btopt("i") and 4 or -1,
		[[
			#pragma CUBE2_fog
			uniform vec4 texgenscroll;
			<% if btopt("o") then return "uniform vec4 orienttangent, orientbinormal;" end %>
			<% if btopt("t") or btopt("r") then return "uniform vec4 camera; varying vec3 camvec;" end %>
			<% if btopt("G") then return "uniform vec4 millis; varying float pulse;" end %>
			<% if btopt("r") then return "varying mat3 world;" end %>
			void main(void)
			{
				gl_Position = ftransform();
				gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + texgenscroll.xy;
				// need to store these in Z/W to keep texcoords < 6, otherwise kills performance on Radeons
				// but slows lightmap access in fragment shader a bit, so avoid when possible
				<%
					if btopt("r") or EV.minimizetcusage ~= 0 then
						return [=[ gl_TexCoord[0].zw = gl_MultiTexCoord1.yx * ]=] .. lmcoordscale
					else
						return [=[ gl_TexCoord[1].xy = gl_MultiTexCoord1.xy * ]=] .. lmcoordscale
					end
				%>

				<%
					if btopt("o") then
						local r = {[=[
							vec4 tangent = gl_Color*2.0 - 1.0;
							vec3 binormal = cross(gl_Normal, tangent.xyz) * tangent.w;
						]=]}
						if btopt("t") then
							table.insert(r, [=[
								// trans eye vector into TS
								vec3 camobj = camera.xyz - gl_Vertex.xyz;
								camvec = vec3(dot(camobj, tangent.xyz), dot(camobj, binormal), dot(camobj, gl_Normal));
							]=])
						end
						if btopt("r") then
							if not btopt("t") then
								table.insert(r, [=[
									camvec = camera.xyz - gl_Vertex.xyz;
								]=])
							end
							table.insert(r, [=[
								// calculate tangent -> world transform
								world = mat3(tangent.xyz, binormal, gl_Normal);
							]=]
						end
						return table.concat(r, '\n')
					end
				%>

				<%
					if btopt("G") then
						return [=[
							pulse = abs(fract(millis.x*pulseglowspeed.x)*2.0 - 1.0);
						]=]
					end
				%>

				<%
					if not btopt("i") or btopt("s") then
						return "#pragma CUBE2_dynlight"
					end
				%>

				<%
					if not btopt("i") then
						return [=[
							#pragma CUBE2_shadowmap
							#pragma CUBE2_water
						]=]
					end
				%>
			}
		]],
		[[
			uniform vec4 colorparams;
			uniform sampler2D diffusemap, lmcolor, lmdir;
			<% if not btopt("i") or btopt("s") or btopt("p") or btopt("P") then return "uniform sampler2D normalmap;" end %>
			<% if btopt("t") or btopt("r") then return "varying vec3 camvec;" end %>
			<% if btopt("g") then return "uniform sampler2D glowmap;" end %>
			<% if btopt("G") then return "varying float pulse;" end %>
			<% if btopt("r") then return "uniform samplerCube envmap; varying mat3 world;" end %>
			<% if not btopt("i") or btopt("s") then return "uniform vec4 ambient;" end %>

			void main(void)
			{
				#define lmtc <% return (EV.minimizetcusage ~= 0 or btopt("r")) and "gl_TexCoord[0].wz" or "gl_TexCoord[1].xy" %>
				<%
					if not btopt("i") or btopt("s") then
						return [=[
							vec4 lmc = texture2D(lmcolor, lmtc);
							gl_FragColor.a = colorparams.a * lmc.a;
							vec3 lmlv = texture2D(lmdir, lmtc).rgb*2.0 - 1.0;
						]=]
					end
				%>

				<%
					if btopt("t") then return "vec3 camdir = normalize(camvec);" end
				%>

				<%
					if btopt("p") then
						return [=[
							float height = texture2D(normalmap, gl_TexCoord[0].xy).a;
							vec2 dtc = gl_TexCoord[0].xy + camdir.xy*(height*parallaxscale.x + parallaxscale.y);
						]=]
					end
				%>

				<%
					if btopt("P") then
						local ret = {}
						table.insert(ret, [=[
							const float step = -1.0/7.0;
							vec3 duv = vec3((step*parallaxscale.x/camdir.z)*camdir.xy, step);
							vec3 htc = vec3(gl_TexCoord[0].xy + duv.xy*parallaxscale.y, 1.0);
							vec4 height = texture2D(normalmap, htc.xy);
						]=])
						for i = 1, 7 do
							table.insert(ret, [=[
								htc += height.w < htc.z ? duv : vec(0.0);
								height = texture2D(normalmap, htc.xy);
							]=])
						end
						table.insert(ret, [=[
							#define dtc htc.xy
							#define bump height.xyz	
						]=])
						return table.concat(ret, '\n')
					end
				%>

				<% if btopt("p") or not btopt("P") then return "#define dtc gl_TexCoord[0].xy" end %>
				<% if not btopt("i") or btopt("S") then return "vec4 diffuse = texture2D(diffusemap, dtc);" end %>
				<% if not btopt("i") then return "diffuse.rgb *= colorparams.rgb;" end %>

				<%
					if not btopt("i") or btopt("s") then
						local r = {}
						if not btopt("P") then
							table.insert(r, [=[
								vec3 bump = texture2D(normalmap, dtc).rgb;
								bump = bump*2.0 - 1.0;
							]=])
						end
						table.insert(r, [=[
							bump = bump*2.0 - 1.0;
						]=])
						return table.concat(r, '\n')
					end
				%>

				<%
					if btopt("s") then
						local ret = {}
						table.insert(ret, [=[
							vec3 halfangle = normalize(camdir + lmlv);
							float spec = pow(clamp(dot(halfangle, bump), 0.0, 1.0), @(? (btopt "i") "128.0" "32.0"));
						]=])
						if btopt("i") then
							table.insert(ret, "spec = min(spec*64.0, 1.0);")
						end
						if btopt("S") then
							table.insert(ret, "spec *= diffuse.a;")
						end
						if btopt("i") then
							if btopt("S") then
								table.insert(ret, "diffuse.rgb = specscale.xyz*spec;")
							else
								table.insert(ret, "vec3 diffuse = specscale.xyz*spec;")
							end
						else
							table.insert(ret, "diffuse.rgb += specscale.xyz*spec;")
						end
						return table.concat(ret, '\n')
					end
				%>

				<%
					if not btopt("i") or btopt("s") then
						local ret = { "lmc.rgb = max(lmc.rgb*clamp(dot(lmlv, bump), 0.0, 1.0), ambient.xyz);" }
						if btopt("i") then
							table.insert(ret, "#pragma CUBE2_dynlight lmc")
							if btopt("g") then
								table.insert(ret, "diffuse.rgb = diffuse.rgb * lmc.rgb")
							else
								table.insert(ret, "gl_FragColor.rgb = diffuse.rgb * lmc.rgb")
							end
						else
							table.insert(ret, [=[
								#pragma CUBE2_shadowmap lmc
								#pragma CUBE2_dynlight lmc
							]=])
							if btopt("g") or btopt("r") then
								table.insert(ret, "diffuse.rgb = diffuse.rgb * lmc.rgb")
							else
								table.insert(ret, "gl_FragColor.rgb = diffuse.rgb * lmc.rgb")
							end
						end
						return table.concat(ret, '\n')
					end
				%>

				<%
					if btopt("r") then
						local ret = { "vec3 rvec;" }
						if btopt("t") then
							table.insert(ret, [=[
								vec3 rvects = 2.0*bump*dot(camvec, bump) - camvec;
								rvec = world * rvects;
							]=]
						else
							table.insert(ret, [=[
								vec3 bumpw = world * bump;
								rvec = 2.0*bumpw*dot(camvec, bumpw) - camvec;
							]=]
						end
						table.insert(ret, "vec3 reflect = textureCube(envmap, rvec).rgb;")
						if btopt("R") then
							table.insert(ret, "vec3 rmod = envscale.xyz*diffuse.a;")
						else
							table.insert(ret, "#define rmod envscale.xyz")
						end
						if btopt("g") then
							table.insert(ret, "diffuse.rgb = mix(diffuse.rgb, reflect, rmod);")
						else
							table.insert(ret, "gl_FragColor.rgb = mix(diffuse.rgb, reflect, rmod);")
						end
						return table.concat(ret, '\n')
					end
				%>

				<%
					if btopt("g") then
						local ret = { "vec3 glow = texture2D(glowmap, dtc).rgb;" }
						if btopt("G") then
							table.insert(ret, "vec3 pulsecol = mix(glowcolor.xyz, pulseglowcolor.xyz, pulse);")
						end
						if btopt("i") then
							if btopt("G") then
								table.insert(ret, "glow *= pulsecol")
							else
								table.insert(ret, "glow *= glowcolor.xyz")
							end
							table.insert(ret, [=[
								float k = max(glow.r, max(glow.g, glow.b));
								k = min(k*k*32.0, 1.0);
							]=])
							if btopt("s") then
								table.insert(ret, "gl_FragColor.rgb = glow*k + diffuse.rgb;")
							else
								table.insert(ret, [=[
									gl_FragColor.rgb = glow*k;
									#pragma CUBE2_variantoverride gl_FragColor.a = texture2D(lmcolor, lmtc).a; //
									gl_FragColor.a = colorparams.a;
								]=])
							end
						else
							if btopt("G") then
								table.insert(ret, "gl_FragColor.rgb = pulsecol + diffuse.rgb")
							else
								table.insert(ret, "gl_FragColor.rgb = glowcolor.xyz + diffuse.rgb")
							end
						end
						return table.concat(ret, '\n')
					end
				%>

				<%
					if not btopt("i") then
						return "#pragma CUBE2_water"
					end
				%>
			}
		]]
	)
end

bumpshaderargs = {}
function bumpshader (...)
	bumpshaderargs = { ... }
	Shader.defer(string.find(bumpshaderargs[2], "e") and 7 or 5, bumpshaderargs[1],
		string.format([[
			bumpvariantshader("%s", "%s")
			if btopt("g") or btopt("s") then
				bumpvariantshader("%s", "%s")
			end
		]], bumpshaderargs[1], bumpshaderargs[2], bumpshaderargs[1], string.gsub(bumpshaderargs[2], "i", "r"))
	)
end

bumpshader("bumpworld", "")
bumpshader("bumpspecworld", "ots")
Shader.fast("bumpspecworld", "bumpworld", 2)
Shader.alt("bumpspecworld", "bumpworld")
bumpshader("bumpspecmapworld", "otsS")
Shader.fast("bumpspecmapworld", "bumpworld", 2)
Shader.alt("bumpspecmapworld", "bumpworld")

bumpshader("bumpglowworld", "g")
bumpshader("bumpspecglowworld", "otsg")
Shader.alt("bumpspecglowworld", "bumpglowworld")
bumpshader("bumpspecmapglowworld", "otsSg")
Shader.fast("bumpspecmapglowworld", "bumpglowworld", 2)
Shader.alt("bumpspecmapglowworld", "bumpglowworld")

bumpshader("bumppulseglowworld", "gG")
bumpshader("bumpspecpulseglowworld", "otsgG")
Shader.alt("bumpspecpulseglowworld", "bumppulseglowworld")
bumpshader("bumpspecmappulseglowworld", "otsSgG")
Shader.fast("bumpspecmappulseglowworld", "bumppulseglowworld", 2)
Shader.alt("bumpspecmappulseglowworld", "bumppulseglowworld")

bumpshader("bumpparallaxworld", "pot")
Shader.fast("bumpparallaxworld", "bumpworld", 1)
Shader.alt("bumpparallaxworld", "bumpworld")
bumpshader("bumpspecparallaxworld", "pots")
Shader.fast("bumpspecparallaxworld", "bumpparallaxworld", 2)
Shader.fast("bumpspecparallaxworld", "bumpworld", 1)
Shader.alt("bumpspecparallaxworld", "bumpworld")
bumpshader("bumpspecmapparallaxworld", "potsS")
Shader.fast("bumpspecmapparallaxworld", "bumpparallaxworld", 2)
Shader.fast("bumpspecmapparallaxworld", "bumpworld", 1)
Shader.alt("bumpspecmapparallaxworld", "bumpworld")

bumpshader("bumpparallaxglowworld", "potg")
Shader.fast("bumpparallaxglowworld", "bumpglowworld", 1)
Shader.alt("bumpparallaxglowworld", "bumpglowworld")
bumpshader("bumpspecparallaxglowworld", "potsg")
Shader.fast("bumpspecparallaxglowworld", "bumpparallaxglowworld", 2)
Shader.fast("bumpspecparallaxglowworld", "bumpglowworld", 1)
Shader.alt("bumpspecparallaxglowworld", "bumpglowworld")
bumpshader("bumpspecmapparallaxglowworld", "potsSg")
Shader.fast("bumpspecmapparallaxglowworld", "bumpparallaxglowworld", 2)
Shader.fast("bumpspecmapparallaxglowworld", "bumpglowworld", 1)
Shader.alt("bumpspecmapparallaxglowworld", "bumpglowworld")

bumpshader("bumpparallaxpulseglowworld", "potgG")
Shader.fast("bumpparallaxpulseglowworld", "bumppulseglowworld", 1)
Shader.alt("bumpparallaxpulseglowworld", "bumppulseglowworld")
bumpshader("bumpspecparallaxpulseglowworld", "potsgG")
Shader.fast("bumpspecparallaxpulseglowworld", "bumpparallaxpulseglowworld", 2)
Shader.fast("bumpspecparallaxpulseglowworld", "bumppulseglowworld", 1)
Shader.alt("bumpspecparallaxpulseglowworld", "bumppulseglowworld")
bumpshader("bumpspecmapparallaxpulseglowworld", "potsSgG")
Shader.fast("bumpspecmapparallaxpulseglowworld", "bumpparallaxpulseglowworld", 2)
Shader.fast("bumpspecmapparallaxpulseglowworld", "bumppulseglowworld", 1)
Shader.alt("bumpspecmapparallaxpulseglowworld", "bumppulseglowworld")

bumpshader("bumpenvworldalt", "e")
bumpshader("bumpenvworld", "eor")
Shader.alt("bumpenvworld", "bumpenvworldalt")
Shader.fast("bumpenvworld", "bumpenvworldalt", 2)
bumpshader("bumpenvspecworld", "eotsr")
Shader.alt("bumpenvspecworld", "bumpenvworldalt")
Shader.fast("bumpenvspecworld", "bumpenvworldalt", 2)
bumpshader("bumpenvspecmapworld", "eotsSrR")
Shader.alt("bumpenvspecmapworld", "bumpenvworldalt")
Shader.fast("bumpenvspecmapworld", "bumpenvworldalt", 2)

bumpshader("bumpenvglowworldalt", "eg")
bumpshader("bumpenvglowworld", "eorg")
Shader.alt("bumpenvglowworld", "bumpenvglowworldalt")
Shader.fast("bumpenvglowworld", "bumpenvglowworldalt", 2)
bumpshader("bumpenvspecglowworld", "eotsrg")
Shader.alt("bumpenvspecglowworld", "bumpenvglowworldalt")
Shader.fast("bumpenvspecglowworld", "bumpenvglowworldalt", 2)
bumpshader("bumpenvspecmapglowworld", "eotsSrRg")
Shader.alt("bumpenvspecmapglowworld", "bumpenvglowworldalt")
Shader.fast("bumpenvspecmapglowworld", "bumpenvglowworldalt", 2)

bumpshader("bumpenvpulseglowworldalt", "egG")
bumpshader("bumpenvpulseglowworld", "eorgG")
Shader.alt("bumpenvpulseglowworld", "bumpenvpulseglowworldalt")
Shader.fast("bumpenvpulseglowworld", "bumpenvpulseglowworldalt", 2)
bumpshader("bumpenvspecpulseglowworld", "eotsrgG")
Shader.alt("bumpenvspecpulseglowworld", "bumpenvpulseglowworldalt")
Shader.fast("bumpenvspecpulseglowworld", "bumpenvpulseglowworldalt", 2)
bumpshader("bumpenvspecmappulseglowworld", "eotsSrRgG")
Shader.alt("bumpenvspecmappulseglowworld", "bumpenvpulseglowworldalt")
Shader.fast("bumpenvspecmappulseglowworld", "bumpenvpulseglowworldalt", 2)

bumpshader("bumpenvparallaxworldalt", "epot")
Shader.alt("bumpenvparallaxworldalt", "bumpenvworldalt")
bumpshader("bumpenvparallaxworld", "epotr")
Shader.alt("bumpenvparallaxworld", "bumpenvparallaxworldalt")
Shader.fast("bumpenvparallaxworld", "bumpenvparallaxworldalt", 2)
Shader.fast("bumpenvparallaxworld", "bumpenvworldalt", 1)
bumpshader("bumpenvspecparallaxworld", "epotsr")
Shader.alt("bumpenvspecparallaxworld", "bumpenvparallaxworldalt")
Shader.fast("bumpenvspecparallaxworld", "bumpenvparallaxworldalt", 2)
Shader.fast("bumpenvspecparallaxworld", "bumpenvworldalt", 1)
bumpshader("bumpenvspecmapparallaxworld", "epotsSrR")
Shader.alt("bumpenvspecmapparallaxworld", "bumpenvparallaxworldalt")
Shader.fast("bumpenvspecmapparallaxworld", "bumpenvparallaxworldalt", 2)
Shader.fast("bumpenvspecmapparallaxworld", "bumpenvworldalt", 1)

bumpshader("bumpenvparallaxglowworldalt", "epotg")
Shader.alt("bumpenvparallaxglowworldalt", "bumpenvglowworldalt")
bumpshader("bumpenvparallaxglowworld", "epotrg")
Shader.alt("bumpenvparallaxglowworld", "bumpenvparallaxglowworldalt")
Shader.fast("bumpenvparallaxglowworld", "bumpenvparallaxglowworldalt", 2)
Shader.fast("bumpenvparallaxglowworld", "bumpenvglowworldalt", 1)
bumpshader("bumpenvspecparallaxglowworld", "epotsrg")
Shader.alt("bumpenvspecparallaxglowworld", "bumpenvparallaxglowworldalt")
Shader.fast("bumpenvspecparallaxglowworld", "bumpenvparallaxglowworldalt", 2)
Shader.fast("bumpenvspecparallaxglowworld", "bumpenvglowworldalt", 1)
bumpshader("bumpenvspecmapparallaxglowworld", "epotsSrRg")
Shader.alt("bumpenvspecmapparallaxglowworld", "bumpenvparallaxglowworldalt")
Shader.fast("bumpenvspecmapparallaxglowworld", "bumpenvparallaxglowworldalt", 2)
Shader.fast("bumpenvspecmapparallaxglowworld", "bumpenvglowworldalt", 1)

bumpshader("bumpenvparallaxpulseglowworldalt", "epotgG")
Shader.alt("bumpenvparallaxpulseglowworldalt", "bumpenvpulseglowworldalt")
bumpshader("bumpenvparallaxpulseglowworld", "epotrgG")
Shader.alt("bumpenvparallaxpulseglowworld", "bumpenvparallaxpulseglowpulseglowworldalt")
Shader.fast("bumpenvparallaxpulseglowworld", "bumpenvparallaxpulseglowpulseglowworldalt", 2)
Shader.fast("bumpenvparallaxpulseglowworld", "bumpenvpulseglowworldalt", 1)
bumpshader("bumpenvspecparallaxpulseglowworld", "epotsrgG")
Shader.alt("bumpenvspecparallaxpulseglowworld", "bumpenvparallaxpulseglowworldalt")
Shader.fast("bumpenvspecparallaxpulseglowworld", "bumpenvparallaxpulseglowworldalt", 2)
Shader.fast("bumpenvspecparallaxpulseglowworld", "bumpenvpulseglowworldalt", 1)
bumpshader("bumpenvspecmapparallaxpulseglowworld", "epotsSrRgG")
Shader.alt("bumpenvspecmapparallaxpulseglowworld", "bumpenvparallaxpulseglowworldalt")
Shader.fast("bumpenvspecmapparallaxpulseglowworld", "bumpenvparallaxpulseglowworldalt", 2)
Shader.fast("bumpenvspecmapparallaxpulseglowworld", "bumpenvpulseglowworldalt", 1)

--bumpshader("steepworld", "Pot")

------------------------------------------------
--
-- phong lighting model shader
--
------------------------------------------------

-- skeletal animation for matrices and dual quaternions

skelanimdefs = [[
	<%
		if EV.useubo ~= 0 then
			return [=[
				#ifdef GL_ARB_uniform_buffer_object
				#extension GL_ARB_uniform_buffer_object : enable
				#elif defined(GL_ARB_compatibility)
					#version 140
					#extension GL_ARB_compatibility : enable
				#endif
			]=]
		end
	%>
	<%
		if EV.usebue ~= 0 then
			return "#extension GL_EXT_bindable_uniform : enable"
		end
	%>
	#pragma CUBE2_attrib vweights 6
	#pragma CUBE2_attrib vbones 7
	attribute vec4 vweights; 
	attribute vec4 vbones;
	#pragma CUBE2_uniform animdata AnimData 0 16
	<%
		if EV.useubo ~= 0 then
			return string.format([=[
				#if defined(GL_ARB_uniform_buffer_object) || __VERSION__ >= 140
					layout(std140) uniform AnimData
					{
						vec4 animdata[%i];
					};
				#else
			]=], math.min( ( EV.maxvsuniforms - EV.reservevpparams ), 256) - 10)
		end
	%>
	<%
		if EV.usebue ~= 0 then
			return [=[
				#ifdef GL_EXT_bindable_uniform
					bindable
				#endif
			]=]
		end
	%>

	uniform vec4 animdata[<% return ( math.min( ( EV.maxvsuniforms - EV.reservevpparams ), 256) - 10 ) %>];
	<% if EV.useubo ~= 0 then return "#endif" end %>
]]

skelanimfragdefs = [[
<%
	if EV.ati_ubo_bug ~= 0 then
		if EV.useubo ~= 0 then
			return string.format([=[
				#ifdef GL_ARB_uniform_buffer_object
					#extension GL_ARB_uniform_buffer_object : enable
				#elif defined(GL_ARB_compatibility)
					#version 140
					#extension GL_ARB_compatibility : enable
				#endif
				#if defined(GL_ARB_uniform_buffer_object) || __VERSION__ >= 140
					layout(std140) uniform AnimData
					{
						vec4 animdata[%i];
					};
				#endif
			]=], math.min( ( EV.maxvsuniforms - EV.reservevpparams ), 256) - 10)
		else
			return string.format([=[
				#ifdef GL_EXT_bindable_uniform
					#extension GL_EXT_bindable_uniform : enable
					bindable uniform vec4 animdata[%i];
				#endif
			]=], math.min( ( EV.maxvsuniforms - EV.reservevpparams ), 256) - 10)
		end
	end
%>
]]

skelmatanimargs = {}
skelmatanim = [[
	int index = int(vbones.x);
	<%
		if skelmatanimargs[1] == 1 then
			return [=[
				vec4 mx = animdata[index];
				vec4 my = animdata[index+1];
				vec4 mz = animdata[index+2];
			]=]
		else
			return [=[
				vec4 mx = animdata[index] * vweights.x;
				vec4 my = animdata[index+1] * vweights.x;
				vec4 mz = animdata[index+2] * vweights.x;
				index = int(vbones.y);
				mx += animdata[index] * vweights.y;
				my += animdata[index+1] * vweights.y;
				mz += animdata[index+2] * vweights.y;
			]=]
		end
	%>
	<%
		if skelmatanimargs[1] >= 3 then
			return [=[
				index = int(vbones.z);
				mx += animdata[index] * vweights.z;
				my += animdata[index+1] * vweights.z;
				mz += animdata[index+2] * vweights.z;
			]=]
		end
	%>
	<%
		if skelmatanimargs[1] >= 4 then
			return [=[
				index = int(vbones.w);
				mx += animdata[index] * vweights.w;
				my += animdata[index+1] * vweights.w;
				mz += animdata[index+2] * vweights.w;
			]=]
		end
	%>

	vec4 opos = vec4(dot(mx, gl_Vertex), dot(my, gl_Vertex), dot(mz, gl_Vertex), gl_Vertex.w);

	<%
		if skelmatanimargs[2] then
			return "vec3 onormal = vec3(dot(mx.xyz, gl_Normal), dot(my.xyz, gl_Normal), dot(mz.xyz, gl_Normal));"
		end
	%>

	<%
		if skelmatanimargs[3] then
			return "vec3 otangent = vec3(dot(mx.xyz, vtangent.xyz), dot(my.xyz, vtangent.xyz), dot(mz.xyz, vtangent.xyz));"
		end
	%>
]]

skelquatanimargs = {}
skelquatanim = [[
	int index = int(vbones.x);
	<%
		if skelquatanimargs[1] == 1 then
			return [=[
				vec4 dqreal = animdata[index];
				vec4 dqdual = animdata[index+1];
			]=]
		else
			local ret = {[=[
				vec4 dqreal = animdata[index] * vweights.x;
				vec4 dqdual = animdata[index+1] * vweights.x;
				index = int(vbones.y);
				dqreal += animdata[index] * vweights.y;
				dqdual += animdata[index+1] * vweights.y;
			]=]}
			if skelquatanimargs[1] >= 3 then
				table.insert(ret, [=[
					index = int(vbones.z);
					dqreal += animdata[index] * vweights.z;
					dqdual += animdata[index+1] * vweights.z;
				]=])
			end
			if skelquatanimargs[1] >= 4 then
				table.insert(ret, [=[
					index = int(vbones.w);
					dqreal += animdata[index] * vweights.w;
					dqdual += animdata[index+1] * vweights.w;
				]=])
			end
			table.insert(ret, [=[
				float len = length(dqreal);
				dqreal /= len;
				dqdual /= len;
			]=])
			return table.concat(ret, '\n')
		end
	%>

	vec4 opos = vec4((cross(dqreal.xyz, cross(dqreal.xyz, gl_Vertex.xyz) + gl_Vertex.xyz*dqreal.w + dqdual.xyz) + dqdual.xyz*dqreal.w - dqreal.xyz*dqdual.w)*2.0 + gl_Vertex.xyz, gl_Vertex.w);

	<%
		if skelquatanimargs[2] then
			return "vec3 onormal = cross(dqreal.xyz, cross(dqreal.xyz, gl_Normal) + gl_Normal*dqreal.w)*2.0 + gl_Normal;"
		end
	%>

	<%
		if skelquatanimargs[3] then
			return "vec3 otangent = cross(dqreal.xyz, cross(dqreal.xyz, vtangent.xyz) + vtangent.xyz*dqreal.w)*2.0 + vtangent.xyz;"
		end
	%>
]]

-- model shadowmapping

smcvsargs = {}
shadowmapcastervertexshader = [[
	<%
		local ret = {}
		if #smcvsargs >= 2 then table.insert(ret, smcvsargs[1]) end
		table.insert(ret, "uniform vec4 shadowintensity;")
		if #smcvsargs >= 2 then
			table.insert(ret, string.format([=[
				void main(void)
				{
					%s
					gl_Position = gl_ModelViewProjectionMatrix * opos;
			]=], tostring(smcvsargs[2])))
		else
			table.insert(ret, [=[
				void main(void)
				{
					gl_Position = ftransform();
			]=])
		end
		table.insert(ret, [=[
				gl_TexCoord[0] = vec4(1.0 - gl_Position.z, 1.0, 0.0, shadowintensity.x);
			}
		]=])
		return table.concat(ret, '\n')
	%>
]]

Shader.normal(4, "shadowmapcaster", shadowmapcastervertexshader, [[
	void main(void)
	{
		gl_FragColor = gl_TexCoord[0];
	}
]])

for i = 1, 4 do
	skelmatanimargs = { i + 1, false, false }
	skelquatanimargs = { i + 1, false, false }
	smcvsargs = { template(skelanimdefs), template(skelmatanim) }
	Shader.variant(4, "shadowmapcaster", 0, template(shadowmapcastervertexshader), "")
	smcvsargs = { template(skelanimdefs), template(skelquatanim) }
	Shader.variant(4, "shadowmapcaster", 1, template(shadowmapcastervertexshader), "")
end

Shader.normal(4, "shadowmapreceiver",
	[[
		uniform vec4 shadowmapbias;
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = vec4(0.0, 0.0, shadowmapbias.y - gl_Position.z, 0.0); 
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_TexCoord[0];
		}
	]]
)

-- model stencil shadows

ntmvsargs = {}
notexturemodelvertexshader = [[
	<%
		if #ntmvsargs >= 2 then
			return string.format([=[
				%s
				#pragma CUBE2_fog opos
				void main(void)
				{
					%s
					gl_Position = gl_ModelViewProjectionMatrix * opos;
			]=], tostring(ntmvsargs[1]), tostring(ntmvsargs[2]))
		else
			return [=[
				#pragma CUBE2_fog
				void main(void)
				{
					gl_Position = ftransform();
			]=]
		end
	%>
					gl_FrontColor = gl_Color;
				}
]]

Shader.normal(4, "notexturemodel", notexturemodelvertexshader,
	[[
		void main(void)
		{
			gl_FragColor = gl_Color;
		}
	]]
)

for i = 1, 4 do
	skelmatanimargs = { i + 1, false, false }
	skelquatanimargs = { i + 1, false, false }
	ntmvsargs = { template(skelanimdefs), template(skelmatanim) }
	Shader.variant(4, "notexturemodel", 0, template(notexturemodelvertexshader), "")
	ntmvsargs = { template(skelanimdefs), template(skelquatanim) }
	Shader.variant(4, "notexturemodel", 1, template(notexturemodelvertexshader), "")
end

-- mdltype:
--	e -> envmap
--	n -> normalmap
--	s -> spec
--	m -> masks
--	B -> matrix skeletal animation
--	b -> dual-quat skeletal animation
--	i -> glare intensity

function mdlopt(arg)
	return string.find(modelvfargs[1], arg) ~= nil
end

modelvfargs = {}
modelvertexshader = [[
	<% if mdlopt("b") or mdlopt("B") then return template(skelanimdefs) end %>
	#pragma CUBE2_fog opos
	<%
		if mdlopt("n") then
			return [=[
				#pragma CUBE2_attrib vtangent 1
				attribute vec4 vtangent;
			]=]
		end
	%>
	uniform vec4 camera, lightdir, lightscale, texscroll;
	<%
		if mdlopt("n") then
			if mdlopt("e") then
				return [=[
					varying vec3 camvec;
					varying mat3 world;
				]=]
			else
				return "varying vec3 lightvec, halfangle;"
			end
		else
			local r = {}
			if mdlopt("s") then
				table.insert(r, "varying vec3 nvec, halfangle;")
			end
			if mdlopt("e") then
				table.insert(r, [=[
					uniform vec4 envmapscale;
					varying vec3 rvec;
					varying float rmod;
				]=])
			end
			return table.concat(r, '\n')
		end
	%>
	void main(void)
	{
		<% if mdlopt("B") then skelmatanimargs = { modelvfargs[2], 1, mdlopt("n") } return template(skelmatanim) end %>
		<% if mdlopt("b") then skelquatanimargs = { modelvfargs[2], 1, mdlopt("n") } return template(skelquatanim) end %>
		<%
			if mdlopt("b") or mdlopt("B") then
				return "gl_Position = gl_ModelViewProjectionMatrix * opos;"
			else
				return [=[
					gl_Position = ftransform();
					#define opos gl_Vertex
					#define onormal gl_Normal
					#define otangent vtangent.xyz
				]=]
			end
		%>

		<%
			if mdlopt("n") or mdlopt("s") or mdlopt("i") then
				return "gl_FrontColor = gl_Color;"
			end
		%>
		gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + texscroll.yz;

		<%
			if mdlopt("e") or mdlopt("s") then
				return "vec3 camdir = normalize(camera.xyz - opos.xyz);"
			end
		%>

		<%
			if mdlopt("n") then
				if mdlopt("e") then
					return [=[
						camvec = mat3(gl_TextureMatrix[0][0].xyz, gl_TextureMatrix[0][1].xyz, gl_TextureMatrix[0][2].xyz) * camdir;
						// composition of tangent -> object and object -> world transforms
						//   becomes tangent -> world
						vec3 wnormal = mat3(gl_TextureMatrix[0][0].xyz, gl_TextureMatrix[0][1].xyz, gl_TextureMatrix[0][2].xyz) * onormal;
						vec3 wtangent = mat3(gl_TextureMatrix[0][0].xyz, gl_TextureMatrix[0][1].xyz, gl_TextureMatrix[0][2].xyz) * otangent;
						world = mat3(wtangent, cross(wnormal, wtangent) * vtangent.w, wnormal);
					]=]
				else
					local r = {[=[
						vec3 obitangent = cross(onormal, otangent) * vtangent.w;
						lightvec = vec3(dot(lightdir.xyz, otangent), dot(lightdir.xyz, obitangent), dot(lightdir.xyz, onormal));
					]=]}
					if mdlopt("s") then
						table.insert(r, [=[
							vec3 halfdir = lightdir.xyz + camdir; 
							halfangle = vec3(dot(halfdir, otangent), dot(halfdir, obitangent), dot(halfdir, onormal));
						]=])
					end
					return table.concat(r, '\n')
				end
			else
				local r = {}
				if mdlopt("s") then
					table.insert(r, [=[
						nvec = onormal; 
						halfangle = lightdir.xyz + camdir;
					]=])
				elseif not mdlopt("i") then
					table.insert(r, "gl_FrontColor = vec4(gl_Color.rgb*max(dot(onormal, lightdir.xyz) + 0.5, lightscale.y), gl_Color.a);")
				end
				if mdlopt("e") then
					table.insert(r, [=[
						float invfresnel = dot(camdir, onormal);
						rvec = mat3(gl_TextureMatrix[0][0].xyz, gl_TextureMatrix[0][1].xyz, gl_TextureMatrix[0][2].xyz) * (2.0*invfresnel*onormal - camdir);
						rmod = envmapscale.x*max(invfresnel, 0.0) + envmapscale.y;	
					]=])
				end
				return table.concat(r, '\n')
			end	
		%>
	}
]]

modelfragmentshader = [[
	<% if mdlopt("b") or mdlopt("B") then return template(skelanimfragdefs) end %>
	<%
		if mdlopt("n") then
			if mdlopt("e") then
				return [=[
					#define lightvec lightdirworld.xyz
					uniform vec4 lightdirworld, envmapscale;
					varying vec3 camvec;
					varying mat3 world;
				]=]
			else
				return "varying vec3 lightvec, halfangle;"
			end
		else
			local r = {}
			if mdlopt("s") then
				table.insert(r, [=[
					#define lightvec lightdir.xyz
					uniform vec4 lightdir;
					varying vec3 nvec, halfangle;
				]=])
			end
			if mdlopt("e") then
				table.insert(r, [=[
					varying vec3 rvec;
					varying float rmod;
				]=])
			end
			return table.concat(r, '\n')
		end
	%>
	<% if mdlopt("s") or mdlopt("m") or (mdlopt("n") and not mdlopt("i")) then return "uniform vec4 lightscale;" end %>
	<% if mdlopt("i") and (mdlopt("s") or mdlopt("m")) then return "uniform vec4 glarescale;" end %>
	uniform sampler2D tex0;
	<% if mdlopt("m") then return "uniform sampler2D tex1;" end %>
	<% if mdlopt("e") then return "uniform samplerCube tex2;" end %>
	<% if mdlopt("n") then return "uniform sampler2D tex3;" end %>
	void main(void)
	{
		vec4 light = texture2D(tex0, gl_TexCoord[0].xy);
		<%
			if mdlopt("m") then
				return [=[
					vec3 masks = texture2D(tex1, gl_TexCoord[0].xy).rgb;
					vec3 glow = light.rgb * lightscale.z;
				]=]
			end
		%>

		<%
			if mdlopt("n") then
				local r = { "vec3 normal = normalize(texture2D(tex3, gl_TexCoord[0].xy).rgb - 0.5);" }
				if mdlopt("e") then
					table.insert(r, "normal = world * normal;")
				end
				return table.concat(r, '\n')
			end
		%>

		<%
			if mdlopt("s") then
				local r = {}
				if mdlopt("n") then
					if mdlopt("e") then
						table.insert(r, "vec3 halfangle = lightvec + camvec;")
					end
				else
					table.insert(r, "vec3 normal = normalize(nvec);")
				end
				table.insert(r, "float spec = lightscale.x * pow(clamp(dot(normalize(halfangle), normal), 0.0, 1.0), @(? (mdlopt "i") "256.0" "128.0"));")
				if mdlopt("m") then
					table.insert(r, "spec *= masks.r; // specmap in red channel")
				end
				return table.concat(r, '\n')
			end
		%>

		<%
			if mdlopt("i") then
				if mdlopt("s") then
					local r = { "spec *= glarescale.x;" }
					if mdlopt("m") then
						table.insert(r, "light.rgb = spec * gl_Color.rgb;")
					else
						table.insert(r, "gl_FragColor.rgb = spec * gl_Color.rgb;")
					end
					return table.concat(r, '\n')
				else
					if not mdlopt("m") then return "gl_FragColor.rgb = vec3(0.0);" end
				end
			else
				local r = {}
				if mdlopt("s") or mdlopt("n") then
					table.insert(r, "light.rgb *= max(dot(normal, lightvec) + 0.5, lightscale.y);")
				end
				if mdlopt("s") then
					table.insert(r, "light.rgb += spec;")
				end
				if mdlopt("m") then
					table.insert(r, "light.rgb *= gl_Color.rgb;")
				else
					table.insert(r, "gl_FragColor = light * gl_Color;")
				end
				return table.concat(r, '\n')
			end
		%>

		<%
			if mdlopt("m") then
				if mdlopt("e") then
					local r = { "light.rgb = mix(light.rgb, glow, masks.g); // glow mask in green channel" }
					if mdlopt("n") then
						table.insert(r, [=[
							vec3 camn = normalize(camvec);
							float invfresnel = dot(camn, normal);
							vec3 rvec = 2.0*invfresnel*normal - camn;
							float rmod = envmapscale.x*max(invfresnel, 0.0) + envmapscale.y;
						]=])
					end
					table.insert(r, [=[
						vec3 reflect = textureCube(tex2, rvec).rgb; 
						gl_FragColor.rgb = mix(light.rgb, reflect, rmod*masks.b); // envmap mask in blue channel
					]=])
					return table.concat(r, '\n')
				elseif mdlopt("i") then
					local r = { "float k = min(masks.g*masks.g*glarescale.y, 1.0); // glow mask in green channel" }
					if mdlopt("s") then
						table.insert(r, "gl_FragColor.rgb = glow*k + light.rgb")
					else
						table.insert(r, "gl_FragColor.rgb = glow*k")
					end
					return table.concat(r, '\n')
				else
					return "gl_FragColor.rgb = mix(light.rgb, glow, masks.g); // glow mask in green channel"
				end
			end
		%>

		<%
			if mdlopt("i") or mdlopt("m") then
				return "gl_FragColor.a = light.a * gl_Color.a;"
			end
		%>
	}
]]

function modelanimshader (...)
	local args = { ... }
	fraganimshader =  args[2] > 0 and args[2]
	reuseanimshader = fraganimshader
	if EV.ati_ubo_bug ~= 0 then
		reuseanimshader = string.format("%i , %i", args[2], tonumber(args[2] > 0))
		if args[4] == 1 then
			modelvfargs = { "bB" .. args[3] }
			fraganimshader = template(modelfragmentshader)
		else
			fraganimshader = reuseanimshader
		end
	end
	modelvfargs = { "B" .. args[3], args[4] }
	Shader.variant(4, args[1], args[2], template(modelvertexshader), fraganimshader)
	modelvfargs = { "b" .. args[3], args[4] }
	Shader.variant(4, args[1], args[2] + 1, template(modelvertexshader), reuseanimshader)
end

modelshaderargs = {}
function modelshader (...)
	modelshaderargs = { ... }
	Shader.defer(4, modelshaderargs[1],
		[[
			basemodeltype = modelshaderargs[2]
			modelvfargs = { basemodeltype }
			Shader.normal(4, modelshaderargs[1], template(modelvertexshader), template(modelfragmentshader))
			for i = 1, 4 do
				modelanimshader(modelshaderargs[1], 0, basemodeltype, i)
			end
			glaremodeltype = string.gsub(basemodeltype .. "i", "e", "")
			if not string.find(glaremodeltype, "s") then glaremodeltype = string.gsub(glaremodeltype, "n", "") end
			modelvfargs = { glaremodeltype }
			Shader.variant(4, modelshaderargs[1], 2, template(modelvertexshader), template(modelfragmentshader))
			for i = 1, 4 do
				modelanimshader(modelshaderargs[1], 2, glaremodeltype, i)
			end
		]]
	)
end
	

------------------------------------------------
--
--, gourad, lighting, model, shader:, cheaper,, non-specular, version, for, vegetation, etc., gets, used, when, spec==0
--
------------------------------------------------

modelshader("nospecmodel", "")
modelshader("masksnospecmodel", "m")
modelshader("envmapnospecmodel", "me")
Shader.alt("envmapnospecmodel", "masksnospecmodel")

modelshader("bumpnospecmodel", "n")
modelshader("bumpmasksnospecmodel", "nm")
modelshader("bumpenvmapnospecmodel", "nme")
Shader.alt("bumpenvmapnospecmodel", "bumpmasksnospecmodel")

------------------------------------------------
--
--, phong, lighting, model, shader
--
------------------------------------------------

modelshader("stdmodel", "s")
Shader.fast("stdmodel", "nospecmodel", 1)
modelshader("masksmodel", "sm")
Shader.fast("masksmodel", "masksnospecmodel", 1)
modelshader("envmapmodel", "sme")
Shader.alt("envmapmodel", "masksmodel")
Shader.fast("envmapmodel", "envmapnospecmodel", 1)

modelshader("bumpmodel", "ns")
Shader.fast("bumpmodel", "bumpnospecmodel", 1)
modelshader("bumpmasksmodel", "nsm")
Shader.fast("bumpmasksmodel", "bumpmasksnospecmodel", 1)
modelshader("bumpenvmapmodel", "nsme")
Shader.alt("bumpenvmapmodel", "bumpmasksmodel")
Shader.fast("bumpenvmapmodel", "bumpenvmapnospecmodel", 1)

------------------------------------------------
--
-- separable blur with up to 7 taps
--
------------------------------------------------

blurargs = {}
function blurshader(...)
	blurargs = { ... }
	Shader.normal(4, blurargs[1],
		[[
			uniform vec4 offsets;
			void main(void)
			{
				gl_Position = gl_Vertex;
				gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
				vec2 tc1 = gl_MultiTexCoord0.xy + offsets.xy;
				vec2 tc2 = gl_MultiTexCoord0.xy - offsets.xy;
				gl_TexCoord[1].xy = tc1;
				gl_TexCoord[2].xy = tc2;
				<%
					for i = 1, math.min(blurargs[2], 2) do
						local a = tostring(blurargs[3])
						local b = {"z", "w"}
						return string.format([=[
							tc1.%s += offsets.%s;
							tc2.%s -= offsets.%s;
							gl_TexCoord[%i].xy = tc1;
							gl_TexCoord[%i].xy = tc2;
						]=], a, b[i], a, b[i], i*2 + 2, i*2 + 3)
					end
				%>
			}
		]],
		[[
			<%
				if blurargs[4] == "2DRect" then
					return "#extension GL_ARB_texture_rectangle : enable"
				end
			%>
			uniform vec4 weights, weights2, offset4, offset5, offset6, offset7;
			uniform <% return "sampler" .. blurargs[4] %> tex0;
			void main(void)
			{
				#define texval(coords) <% return "texture" .. blurargs[4] %>(tex0, (coords))
				vec4 val = texval(gl_TexCoord[0].xy) * weights.x;
				<%
					local a = { "y", "z", "w" }
					local b = { "x", "y", "z", "w" }
					local c = { "offset4", "offset5", "offset6", "offset7" }
					local ret = {}
					for i = 1, blurargs[2] do
						if i < 4 then
							table.insert(ret, string.format("val += weights.%s * (texval(gl_TexCoord[%i].xy) + texval(gl_TexCoord[%i].xy));", a[i], i * 2, i*2 + 1))
						else
							table.insert(ret, string.format([=[
								val += weights2.%s * (texval(gl_TexCoord[0].xy + %s.xy) + texval(gl_TexCoord[0].xy - %s.xy));
							]=], b[i - 3], c[i - 3], c[i - 3]))
						end
					end
					return table.concat(ret, '\n')
				%>
				gl_FragColor = val;
			}
		]]
	)
end

for i = 1, 7 do
	blurshader(string.format("blurx%i", i), i, "x", "2D")
	blurshader(string.format("blury%i", i), i, "y", "2D")
	if i > 0 then
		Shader.alt(string.format("blurx%i", i), string.format("blurx%i", i - 1))
		Shader.alt(string.format("blury%i", i), string.format("blury%i", i - 1))
	end
	if EV.usetexrect ~= 0 then
		blurshader(string.format("blurx%irect", i), i, "x", "2DRect")
		blurshader(string.format("blury%irect", i), i, "y", "2DRect")
		if i > 0 then
			Shader.alt(string.format("blurx%irect", i), string.format("blurx%irect", i - 1))
			Shader.alt(string.format("blury%irect", i), string.format("blury%irect", i - 1))
		end
	end
end

------------------------------------------------
--
-- full screen shaders: 
--
------------------------------------------------

fsvs = [[
    void main(void)
    {
        gl_Position = gl_Vertex;   // woohoo, no mvp :) 
        gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
]]

fsps = [[
    #extension GL_ARB_texture_rectangle : enable
    uniform sampler2DRect tex0; 
    void main(void)
    {
        vec4 sample = texture2DRect(tex0, gl_TexCoord[0].xy);
]]

setup4corners = [[
    gl_TexCoord[1].xy = gl_MultiTexCoord0.xy + vec2(-1.5, -1.5);
    gl_TexCoord[2].xy = gl_MultiTexCoord0.xy + vec2( 1.5, -1.5);
    gl_TexCoord[3].xy = gl_MultiTexCoord0.xy + vec2(-1.5,  1.5);
    gl_TexCoord[4].xy = gl_MultiTexCoord0.xy + vec2( 1.5,  1.5);
]]

sample4corners = [[
    vec4 s00 = texture2DRect(tex0, gl_TexCoord[1].xy);
    vec4 s02 = texture2DRect(tex0, gl_TexCoord[2].xy);
    vec4 s20 = texture2DRect(tex0, gl_TexCoord[3].xy);
    vec4 s22 = texture2DRect(tex0, gl_TexCoord[4].xy);
]]

-- some simple ones that just do an effect on the RGB value...

lazyshader(4, "invert", "<%=fsvs%> }", "<%=fsps%> gl_FragColor = 1.0 - sample; }")
lazyshader(4, "gbr",    "<%=fsvs%> }", "<%=fsps%> gl_FragColor = sample.yzxw; }")
lazyshader(4, "bw",     "<%=fsvs%> }", "<%=fsps%> gl_FragColor = vec4(dot(sample.xyz, vec3(0.333))); }")

-- sobel

lazyshader(4, "sobel", "<%=fsvs%> <%=setup4corners%> }",
	[[
		<%=fsps%>
		<%=sample4corners%>
		vec4 t = s00 + s20 - s02 - s22;
		vec4 u = s00 + s02 - s20 - s22;
		gl_FragColor = sample + t*t + u*u;
	}
	]]
)

-- rotoscope

lazyshader(4, "rotoscope",
	[[
		uniform vec4 params;
		void main(void)
		{
			gl_Position = gl_Vertex;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;

			// stuff two sets of texture coordinates into each one to get around hardware attribute limits
			gl_TexCoord[1] = vec4(-1.0, -1.0,  1.0, 0.0)*params.x + gl_MultiTexCoord0.xyyx;
			gl_TexCoord[2] = vec4(-1.0,  0.0, -1.0, 1.0)*params.x + gl_MultiTexCoord0.xyyx;
			gl_TexCoord[3] = vec4(-1.0,  1.0,  0.0, 1.0)*params.x + gl_MultiTexCoord0.xyyx;
			gl_TexCoord[4] = vec4( 0.0, -1.0,  1.0, 1.0)*params.x + gl_MultiTexCoord0.xyyx;
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0; 
		void main(void)
		{
			#define t11 gl_TexCoord[0]
			#define t00_12 gl_TexCoord[1]
			#define t01_20 gl_TexCoord[2]
			#define t02_21 gl_TexCoord[3]
			#define t10_22 gl_TexCoord[4]
			vec4 c00 = texture2DRect(tex0, t00_12.xy);
			vec4 c01 = texture2DRect(tex0, t01_20.xy);
			vec4 c02 = texture2DRect(tex0, t02_21.xy);
			vec4 c10 = texture2DRect(tex0, t10_22.xy);
			vec4 c11 = texture2DRect(tex0, t11.xy);
			vec4 c12 = texture2DRect(tex0, t00_12.wz);
			vec4 c20 = texture2DRect(tex0, t01_20.wz);
			vec4 c21 = texture2DRect(tex0, t02_21.wz);
			vec4 c22 = texture2DRect(tex0, t10_22.wz);

			vec4 diag1 = c00 - c22;
			vec4 diag2 = c02 - c20;
			vec4 xedge = (c01 - c21)*2.0 + diag1 + diag2;
			vec4 yedge = (c10 - c12)*2.0 + diag1 - diag2;
			xedge *= xedge;
			yedge *= yedge;

			vec4 xyedge = xedge + yedge;
			float sobel = step(max(xyedge.x, max(xyedge.y, xyedge.z)), 0.1);

			float hue = dot(c11.xyz, vec3(1.0));
			c11 /= hue;
			vec3 cc = step(vec3(0.2, 0.8, 1.5), vec3(hue));
			c11 *= dot(cc, vec3(0.5, 0.5, 1.5)); 
		
			gl_FragColor = c11 * max(cc.z, sobel);
		}
	]]
)

blur3args = {}
function blur3shader(...)
	blur3args = { ... }
	lazyshader(4, blur3args[1],
		[[
			void main(void)
			{
				gl_Position = gl_Vertex;
				gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + vec2(<% return (blur3args[2]) and -0.5 or 0.0 %>, <% return (blur3args[3]) and -0.5 or 0.0 %>);
				gl_TexCoord[1].xy = gl_MultiTexCoord0.xy + vec2(<% return (blur3args[2]) and 0.5 or 0.0 %>, <% return (blur3args[3]) and 0.5 or 0.0 %>);
			}
		]],
		[[
			#extension GL_ARB_texture_rectangle : enable
			uniform sampler2DRect tex0; 
			void main(void)
			{
				gl_FragColor = 0.5*(texture2DRect(tex0, gl_TexCoord[0].xy) + texture2DRect(tex0, gl_TexCoord[1].xy));
			}
		]]
	)
end

blur3shader("hblur3", 1, 0)
blur3shader("vblur3", 0, 1)

blur5args = {}
function blur5shader(...)
	blur5args = { ... }
	lazyshader(4, blur5args[1],
		[[
			<%=fsvs%>
				gl_TexCoord[1].xy = gl_MultiTexCoord0.xy + vec2(<% return (blur3args[2]) and -1.333 or 0.0 %>, <% return (blur3args[3]) and -1.333 or 0.0 %>);
				gl_TexCoord[2].xy = gl_MultiTexCoord0.xy + vec2(<% return (blur3args[2]) and 1.333 or 0.0 %>, <% return (blur3args[3]) and 1.333 or 0.0 %>);
			}
		]],
		[[
			#extension GL_ARB_texture_rectangle : enable
			uniform sampler2DRect tex0; 
			void main(void)
			{
				gl_FragColor = 0.4*texture2DRect(tex0, gl_TexCoord[0].xy) + 0.3*(texture2DRect(tex0, gl_TexCoord[1].xy) + texture2DRect(tex0, gl_TexCoord[2].xy));
			}
		]]
	)
end

blur5shader("hblur5", 1, 0)
blur5shader("vblur5", 0, 1)

function bloom(...)
	PostFX.clear()
	local args = { ... }
	if #args >= 1 then
		setupbloom(6, args[1])
	end
end

function rotoscope(...)
	PostFX.clear()
	local args = { ... }
	if #args >= 1 then
		PostFX.add("rotoscope", 0, 0, 0, args[1])
	end
	if #args >= 2 then
		if args[2] == 1 then
			PostFX.add("hblur3")
			PostFX.add("vblur3")
		end
		if args[2] == 2 then
			PostFX.add("hblur5")
			PostFX.add("vblur5")
		end
	end
end

-- bloom-ish

Shader.normal(4, "glare",
	[[
		void main(void)
		{
			gl_Position = gl_Vertex;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		uniform vec4 glarescale;
		uniform sampler2D tex0; 
		void main(void)
		{
			gl_FragColor = texture2D(tex0, gl_TexCoord[0].xy) * glarescale;
		}
	]]
)

lazyshader(4, "bloom_scale", "<%=fsvs%> <%=setup4corners%> }",
	[[
		<%=fsps%>
		<%=sample4corners%>
			gl_FragColor = 0.2 * (s02 + s00 + s22 + s20 + sample);
		}
	]]
)

lazyshader(4, "bloom_init", "<%=fsvs%> }",
	[[
		<%=fsps%>
			float t = max(sample.r, max(sample.g, sample.b));
			gl_FragColor = t*t*sample;
		}
	]]
)

bloomsargs = {}
function bloomshader(...)
	bloomsargs = { ... }
	Shader.defer(4, bloomsargs[1],
		[[
			Shader.force("bloom_scale")
			Shader.force("bloom_init")
			Shader.normal(4, bloomsargs[1],
				[=[
					void main(void)
					{
						gl_Position = gl_Vertex;
						gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
						vec2 tc = gl_MultiTexCoord0.xy;
						<%
							local ret = {}
							for i = 1, bloomsargs[2] do
								table.insert(ret, string.format([==[
									tc *= 0.5;
									gl_TexCoord[%i].xy = tc;
								]==], i))
							end
							return table.concat(ret, '\n')
						%>
					}
				]=],
				[=[
					#extension GL_ARB_texture_rectangle : enable
					uniform vec4 params;
					uniform sampler2DRect tex0<% local ret = {}; for i = 1, bloomsargs[2] do table.insert(ret, string.format(", tex%i", i)) end return table.concat(ret) %>; 
					void main(void)
					{
						vec4 sample = texture2DRect(tex0, gl_TexCoord[0].xy);
						<%
							local ret = {}
							for i = 1, bloomsargs[2] do
								table.insert(ret, (i > 1 and "bloom += " or "vec4 bloom = ") .. string.format("texture2DRect(tex%i, gl_TexCoord[%i].xy);", i, i))
							end
							return table.concat(ret, '\n')
						%>
						gl_FragColor = bloom*params.x + sample;
					}
				]=]
			)
		]]
	)
end

bloomshader("bloom1", 1)
bloomshader("bloom2", 2)
bloomshader("bloom3", 3)
bloomshader("bloom4", 4)
bloomshader("bloom5", 5)
bloomshader("bloom6", 6)

function setupbloom(n, inp)
	PostFX.add("bloom_init", 1, 1, "+0")
	local tc = { 0 }
	for i = 1, n do
		PostFX.add("bloom_scale", i + 1, i + 1, "+" .. i)
		table.insert(tc, i)
	end
	PostFX.add("bloom" .. n, 0, 0, table.concat(tc, ' '), inp)
end

function bloom(...)
	PostFX.clear()
	local args = { ... }
	if #args >= 1 then
		setupbloom(6, args[1])
	end
end

------------------------------------------------
--
-- miscellaneous effect shaders: 
--
------------------------------------------------

-- wobbles the vertices of an explosion sphere
-- and generates all texcoords 
-- and blends the edge color
-- and modulates the texture

expargs = {}
function explosionshader(...)
	expargs = { ... }
	Shader.normal(4, expargs[1],
		[[
			#pragma CUBE2_fog
			uniform vec4 center, animstate;
			<% if string.find(expargs[1], "3d") then return "uniform vec4 texgenS, texgenT;" end %>
			<% if string.find(expargs[1], "soft") then return "uniform vec4 depthfxparams, depthfxview;" end %>
			void main(void)
			{
				vec4 wobble = vec4(gl_Vertex.xyz*(1.0 + 0.5*abs(fract(dot(gl_Vertex.xyz, center.xyz) + animstate.w*0.002) - 0.5)), gl_Vertex.w);
				<%
					if string.find(expargs[1], "soft") then
						return [=[
							vec4 projtc = gl_ModelViewProjectionMatrix * wobble;
							gl_Position = projtc;

							projtc.z = depthfxparams.y - (gl_ModelViewMatrix * wobble).z*depthfxparams.x;
							projtc.xy = (projtc.xy + projtc.w)*depthfxview.xy;
							gl_TexCoord[3] = projtc;
						]=]
					else
						return "gl_Position = gl_ModelViewProjectionMatrix * wobble;"
					end
				%>

				gl_FrontColor = gl_Color;
		
				<%=expargs[2]%>
			} 
		]],
		[[
			<%
				if string.find(expargs[1], "rect") then
					return [=[
						#extension GL_ARB_texture_rectangle : enable
						uniform sampler2DRect tex2;
					]=]
				else
					return "uniform sampler2D tex2;"
				end
			%>
			uniform sampler2D tex0, tex1;
			<% if string.find(expargs[1], "soft") then return "uniform vec4 depthfxparams;" end %>
			<% if string.find(expargs[1], "soft8") then return "uniform vec4 depthfxselect;" end %>
			void main(void)
			{
				vec2 dtc = gl_TexCoord[0].xy + texture2D(tex0, <%=expargs[3]%>.xy).xy*0.1; // use color texture as noise to distort texcoords
				vec4 diffuse = texture2D(tex0, dtc);
				vec4 blend = texture2D(tex1, gl_TexCoord[1].xy); // get blend factors from modulation texture
				<%
					if string.find(expargs[1], "glare") then
						return [=[
							float k = blend.a*blend.a;
							diffuse.rgb *= k*8.0;
							diffuse.a *= k;
							diffuse.b += k*k;
						]=]
					else
						return [=[
							diffuse *= blend.a*4.0; // dup alpha into RGB channels + intensify and over saturate
							diffuse.b += 0.5 - blend.a*0.5; // blue tint 
						]=]
					end
				%>

				<%
					if string.find(expargs[1], "soft") then
						local ret = { string.format([=[
							gl_FragColor.rgb = diffuse.rgb * gl_Color.rgb;

							#define depthvals texture%sProj(tex2, gl_TexCoord[3])
						]=], string.find(expargs[1], "rect") and "2DRect" or "2D") }
						if string.find(expargs[1], "soft8") then
							table.insert(ret, "float depth = dot(depthvals, depthfxselect);")
						else
							table.insert(ret, "float depth = depthvals.x*depthfxparams.z;")
						end
						table.insert(ret, "gl_FragColor.a = diffuse.a * max(clamp(depth - gl_TexCoord[3].z, 0.0, 1.0) * gl_Color.a, depthfxparams.w);")
						return table.concat(ret, '\n')
					else
						return "gl_FragColor = diffuse * gl_Color;"
					end
				%>
			}
		]]
	)
end

for i = 1, (EV.usetexrect ~= 0 and 6 or 4) do
	local list = { "", "glare", "soft", "soft8", "softrect", "soft8rect" }
	explosionshader("explosion2d" .. list[i],
		[[
			// blow up the tex coords
			float dtc = 1.768 - animstate.x*1.414; // -2, 2.5; -> -2*sqrt(0.5), 2.5*sqrt(0.5);
			dtc *= dtc;
			gl_TexCoord[0].xy = animstate.w*0.0004 + dtc*gl_Vertex.xy;
			gl_TexCoord[1].xy = gl_Vertex.xy*0.5 + 0.5; // using wobble makes it look too spherical at a distance
		]], "gl_TexCoord[1]"
	)
	explosionshader("explosion3d" .. list[i],
		[[
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
			vec2 texgen = vec2(dot(texgenS, gl_Vertex), dot(texgenT, gl_Vertex)); 
			gl_TexCoord[1].xy = texgen;
			gl_TexCoord[2].xy = texgen - animstate.w*0.0005;
		]], "gl_TexCoord[2]"
	)
end

partargs = {}
function particleshader(...)
	partargs = { ... }
	Shader.normal(4, partargs[1],
		[[
			#pragma CUBE2_fog
			uniform vec4 colorscale;
			<% if string.find(partargs[1], "soft") then return "uniform vec4 depthfxparams, depthfxview;" end %>
			void main(void)
			{
				gl_Position = ftransform();
				gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
				gl_TexCoord[1] = gl_Color * colorscale; 

				<%
					if string.find(partargs[1], "soft") then
						return [=[
							vec4 projtc = gl_ModelViewProjectionMatrix * gl_Vertex;
							projtc.xy = (projtc.xy + projtc.w) * depthfxview.xy;
							gl_TexCoord[2] = projtc;

							vec2 offset = gl_MultiTexCoord0.xy*2.82842712474619 - 1.4142135623731;
							gl_TexCoord[3].xyz = vec3(offset, 1.0);
							gl_TexCoord[4].xyz = vec3(offset, depthfxparams.y - (gl_ModelViewMatrix * gl_Vertex).z*depthfxparams.x);
						]=]
					end
				%>
			}
		]],
		[[
			<%
				if string.find(partargs[1], "soft") then
					if string.find(partargs[1], "rect") then
						return [=[
							#extension GL_ARB_texture_rectangle : enable
							uniform sampler2DRect tex2;
						]=]
					else
						return "uniform sampler2D tex2;"
					end
				end
			%>
			uniform sampler2D tex0;
			<% if string.find(partargs[1], "soft") then return "uniform vec4 depthfxparams;" end %>
			<% if string.find(partargs[1], "soft8") then return "uniform vec4 depthfxselect;" end %>
			void main(void)
			{
				vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);

				<%
					if string.find(partargs[1], "soft") then
						local ret = { string.format([=[
							#define depthvals texture%sProj(tex2, gl_TexCoord[2])
						]=], string.find(partargs[1], "rect") and "2DRect" or "2D") }

						if string.find(partargs[1], "soft8") then
							table.insert(ret, "float depth = dot(depthvals, depthfxselect);")
						else
							table.insert(ret, "float depth = depthvals.x*depthfxparams.z;")
						end
						table.insert(ret, "diffuse.a *= clamp(depth - dot(gl_TexCoord[3].xyz, gl_TexCoord[4].xyz), 0.0, 1.0);")
						return table.concat(ret, '\n')
					end
				%>

				gl_FragColor = diffuse * gl_TexCoord[1];
			}
		]]
	)
end

for i = 1, (EV.usetexrect ~= 0 and 5 or 3) do
	local list = { "", "soft", "soft8", "softrect", "soft8rect" }
	particleshader("particle" .. list[i])
end

Shader.normal(4, "particlenotexture",
	[[
		#pragma CUBE2_fog
		uniform vec4 colorscale;
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0] = gl_Color * colorscale;
		} 
	]],
	[[
		void main(void)
		{
			gl_FragColor = gl_TexCoord[0];
		}
	]]
)

Shader.normal(4, "blendbrush",
	[[
		uniform vec4 texgenS, texgenT;
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = vec2(dot(texgenS, gl_Vertex), dot(texgenT, gl_Vertex));
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			gl_FragColor = texture2D(tex0, gl_TexCoord[0].xy) * gl_Color;
		}
	]]
)

lazyshader(4, "moviergb",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0;
		void main(void)
		{
			gl_FragColor = texture2DRect(tex0, gl_TexCoord[0].xy);
		}
	]]
)

lazyshader(4, "movieyuv",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0;
		void main(void)
		{
			vec4 sample = texture2DRect(tex0, gl_TexCoord[0].xy);
			gl_FragColor = vec4(dot(sample, vec4(0.500, -0.419, -0.081, 0.500)),
								dot(sample, vec4(-0.169, -0.331, 0.500, 0.500)),
								dot(sample.rgb, vec3(0.299, 0.587, 0.114)),
								sample.a);
		}
	]]
)

lazyshader(4, "moviey",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + vec2(-1.5, 0.0);
			gl_TexCoord[1].xy = gl_MultiTexCoord0.xy + vec2(-0.5, 0.0);
			gl_TexCoord[2].xy = gl_MultiTexCoord0.xy + vec2( 0.5, 0.0);
			gl_TexCoord[3].xy = gl_MultiTexCoord0.xy + vec2( 1.5, 0.0);
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0;
		void main(void)
		{
			vec3 sample1 = texture2DRect(tex0, gl_TexCoord[0].xy).rgb;
			vec3 sample2 = texture2DRect(tex0, gl_TexCoord[1].xy).rgb;
			vec3 sample3 = texture2DRect(tex0, gl_TexCoord[2].xy).rgb;
			vec3 sample4 = texture2DRect(tex0, gl_TexCoord[3].xy).rgb;
			gl_FragColor = vec4(dot(sample3, vec3(0.299, 0.587, 0.114)),
								dot(sample2, vec3(0.299, 0.587, 0.114)),
								dot(sample1, vec3(0.299, 0.587, 0.114)),
								dot(sample4, vec3(0.299, 0.587, 0.114)));
		}
	]]
)

lazyshader(4, "movieu",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + vec2(-3.0, 0.0);
			gl_TexCoord[1].xy = gl_MultiTexCoord0.xy + vec2(-1.0, 0.0);
			gl_TexCoord[2].xy = gl_MultiTexCoord0.xy + vec2( 1.0, 0.0);
			gl_TexCoord[3].xy = gl_MultiTexCoord0.xy + vec2( 3.0, 0.0);
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0;
		void main(void)
		{
			vec4 sample1 = texture2DRect(tex0, gl_TexCoord[0].xy);
			vec4 sample2 = texture2DRect(tex0, gl_TexCoord[1].xy);
			vec4 sample3 = texture2DRect(tex0, gl_TexCoord[2].xy);
			vec4 sample4 = texture2DRect(tex0, gl_TexCoord[3].xy);
			gl_FragColor = vec4(dot(sample3, vec4(-0.169, -0.331, 0.500, 0.500)),
								dot(sample2, vec4(-0.169, -0.331, 0.500, 0.500)),
							dot(sample1, vec4(-0.169, -0.331, 0.500, 0.500)),
									dot(sample4, vec4(-0.169, -0.331, 0.500, 0.500)));
		}
	]]
)

lazyshader(4, "moviev",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy + vec2(-3.0, 0.0);
			gl_TexCoord[1].xy = gl_MultiTexCoord0.xy + vec2(-1.0, 0.0);
			gl_TexCoord[2].xy = gl_MultiTexCoord0.xy + vec2( 1.0, 0.0);
			gl_TexCoord[3].xy = gl_MultiTexCoord0.xy + vec2( 3.0, 0.0);
		}
	]],
	[[
		#extension GL_ARB_texture_rectangle : enable
		uniform sampler2DRect tex0;
		void main(void)
		{
			vec4 sample1 = texture2DRect(tex0, gl_TexCoord[0].xy);
			vec4 sample2 = texture2DRect(tex0, gl_TexCoord[1].xy);
			vec4 sample3 = texture2DRect(tex0, gl_TexCoord[2].xy);
			vec4 sample4 = texture2DRect(tex0, gl_TexCoord[3].xy);
			gl_FragColor = vec4(dot(sample3, vec4(0.500, -0.419, -0.081, 0.500)),
								dot(sample2, vec4(0.500, -0.419, -0.081, 0.500)),
								dot(sample1, vec4(0.500, -0.419, -0.081, 0.500)),
								dot(sample4, vec4(0.500, -0.419, -0.081, 0.500)));
		}
	]]
)

---------------------------------------------------
--
-- reflective/refractive water shaders:
--
---------------------------------------------------

watershaderargs = {}
function watershader(...)
	watershaderargs = { ... }
	spec = watershaderargs[2]
	rgbfog = watershaderargs[3]
	distort = watershaderargs[4]
	combine = watershaderargs[5]
	lazyshader(4, watershaderargs[1],
		[[
			uniform vec4 camera, millis, waterheight;
			<% if spec then return "uniform vec4 lightpos; varying vec3 lightdir;" end %>
			varying vec3 camdir;
			void main(void)
			{
				gl_Position = ftransform();
				gl_FrontColor = gl_Color;
				gl_TexCoord[0] = gl_TextureMatrix[0] * gl_Vertex;
				<%
					if string.find(watershaderargs[1], "underwater") then
						return "gl_TexCoord[0].z = waterheight.x - gl_Vertex.z;"
					else
						return "gl_TexCoord[0].z = gl_Vertex.z - waterheight.x;"
					end
				%>
				vec2 tc = gl_MultiTexCoord0.xy * 0.1;
				gl_TexCoord[1].xy = tc + millis.x*0.04;
				gl_TexCoord[2].xy = tc - millis.x*0.02;
				camdir = camera.xyz - gl_Vertex.xyz;
				<% if spec then return "lightdir = lightpos.xyz - gl_Vertex.xyz;" end %>
			}
		]],
		[[
			<%
				if rgbfog then
					return "#pragma CUBE2_fog"
				else
					return "#pragma CUBE2_fogrgba vec4(0.0, 0.0, 0.0, 1.0)"
				end
			%>
			uniform vec4 depth;
			<% if spec then return "uniform vec4 lightcolor, lightradius; varying vec3 lightdir;" end %>
			varying vec3 camdir;
			<%
				if string.find(watershaderargs[1], "env") then
					return "uniform samplerCube tex0;"
				else
					return "uniform sampler2D tex0;"
				end
			%>
			uniform sampler2D tex1, tex2, tex3;
			void main(void)
			{
				vec3 camvec = normalize(camdir);
				<%
					if spec then
						return [=[
							vec3 lightvec = normalize(lightdir);
							vec3 halfangle = normalize(camvec + lightvec);
						]=]
					end
				%>
                
				vec2 dudv = texture2D(tex2, gl_TexCoord[1].xy).xy*2.0 - 1.0;

				<%=distort%>

				<%
					if spec then
						return [=[
							float spec = pow(clamp(dot(halfangle, bump), 0.0, 1.0), 96.0);
							vec3 light = lightcolor.xyz * (1.0 - clamp(length(lightdir)/lightradius.x, 0.0, 1.0));
						]=]
					end
				%>
            
				<%=combine%>
			}
		]]
	)
end

reflectivity = "invfresnel = invfresnel*0.5 + 0.5;"

watershader("waterglare", true, true,
	[[
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		gl_FragColor = vec4(light*spec*spec*32.0, 0.0);
	]]
)

lazyshader(4, "waterglarefast",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
		}
	]],
	[[
		void main(void)
		{
			gl_FragColor = vec4(0.0);
		}
	]]
)

Shader.fast("waterglare", "waterglarefast", 2)
Shader.alt("waterglare", "waterglarefast")


lazyshader(4, "underwater",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
		}
	]],
	[[
		#pragma CUBE2_fogrgba vec4(0.0, 0.0, 0.0, 1.0)
		uniform vec4 depth;
		void main(void)
		{    
			gl_FragColor.rgb = 0.8*depth.x*gl_Color.rgb;
			gl_FragColor.a = 0.5*depth.y; 
		}
	]]
)

watershader("underwaterrefract", false, true,
	[[
		dudv = texture2D(tex2, gl_TexCoord[2].xy + 0.025*dudv).xy*2.0 - 1.0;
		gl_FragColor = texture2D(tex3, gl_TexCoord[0].xy/gl_TexCoord[0].w + 0.01*dudv);
	]], ""
)

watershader("underwaterrefractfast", false, true,
	[[
		gl_FragColor = texture2DProj(tex3, gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0));
	]], ""
)

Shader.fast("underwaterrefract", "underwaterrefractfast", 2)
Shader.alt("underwaterrefract", "underwaterrefractfast")

watershader("underwaterfade", false, true,
	[[
		dudv = texture2D(tex2, gl_TexCoord[2].xy + 0.025*dudv).xy*2.0 - 1.0;

		vec2 projtc = gl_TexCoord[0].xy/gl_TexCoord[0].w;
		float fade = gl_TexCoord[0].z + 4.0*texture2D(tex3, projtc).a;
		gl_FragColor.a = fade * clamp(gl_FragCoord.z, 0.0, 1.0);
		gl_FragColor.rgb = texture2D(tex3, projtc + 0.01*dudv).rgb; 
	]], ""
)

watershader("underwaterfadefast", false, true,
	[[
		gl_FragColor.rgb = texture2DProj(tex3, gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0)).rgb;
		gl_FragColor.a = gl_TexCoord[0].z + 4.0*texture2DProj(tex3, gl_TexCoord[0]).a;
	]], ""
)

Shader.fast("underwaterfade", "underwaterfadefast", 2)
Shader.alt("underwaterfade", "underwaterfadefast")

watershader("water", true, false,
	[[
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor.rgb = gl_Color.rgb*depth.x*mix(0.6, 1.0, invfresnel) + spec*light;
		gl_FragColor.a = invfresnel*depth.y;
	]]
)

watershader("waterfast", true, false,
	[[
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor.rgb = gl_Color.rgb*depth.x*mix(0.6, 1.0, invfresnel);
		gl_FragColor.a = invfresnel*depth.y;
	]]
)

Shader.fast("water", "waterfast", 1)
Shader.alt("water", "waterfast")

watershader("waterreflect", true, false,
	[[
		vec3 reflect = texture2DProj(tex0, gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0)).rgb;
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, gl_Color.rgb*depth.x, invfresnel) + spec*light;
		gl_FragColor.a = invfresnel*depth.y;
	]]
)

watershader("waterreflectfast", false, false,
	[[
		vec3 reflect = texture2DProj(tex0, gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0)).rgb;
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, gl_Color.rgb*depth.x, invfresnel) + spec*light;
		gl_FragColor.a = invfresnel*depth.y;
	]]
)

Shader.fast("waterreflect", "waterreflectfast", 2)
Shader.alt("waterreflect", "waterreflectfast")

watershader("waterrefract", true, true,
	[[
		vec2 dtc = gl_TexCoord[2].xy + 0.025*dudv;
		vec3 bump = texture2D(tex1, dtc).rgb*2.0 - 1.0;
		dudv = texture2D(tex2, dtc).xy*2.0 - 1.0;

		vec2 rtc = gl_TexCoord[0].xy/gl_TexCoord[0].w + 0.01*dudv;
		vec3 reflect = texture2D(tex0, rtc).rgb;
		vec3 refract = texture2D(tex3, rtc).rgb;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor = vec4(mix(reflect, refract, invfresnel) + spec*light, 0.0);
	]]
)

watershader("waterrefractfast", false, true,
	[[
		vec4 rtc = gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0);
		vec3 reflect = texture2DProj(tex0, rtc).rgb;
		vec3 refract = texture2DProj(tex3, rtc).rgb;
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor = vec4(mix(reflect, refract, invfresnel), 0.0);
	]]
)

Shader.fast("waterrefract", "waterrefractfast", 2)
Shader.alt("waterrefract", "waterrefractfast")

watershader("waterfade", true, true,
	[[
		vec2 dtc = gl_TexCoord[2].xy + 0.025*dudv;
		vec3 bump = texture2D(tex1, dtc).rgb*2.0 - 1.0;
		dudv = texture2D(tex2, dtc).xy*2.0 - 1.0;

		vec2 projtc = gl_TexCoord[0].xy/gl_TexCoord[0].w;
		vec2 rtc = projtc + 0.01*dudv;
		vec3 reflect = texture2D(tex0, rtc).rgb;
		vec3 refract = texture2D(tex3, rtc).rgb;
		float fade = gl_TexCoord[0].z + 4.0*texture2D(tex3, projtc).a;
		gl_FragColor.a = fade * clamp(gl_FragCoord.z, 0.0, 1.0);
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, refract, invfresnel) + spec*light;
	]]
)

watershader("waterfadefast", false, true,
	[[
		vec4 rtc = gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0);
		vec3 reflect = texture2DProj(tex0, rtc).rgb;
		vec3 refract = texture2DProj(tex3, rtc).rgb;
		gl_FragColor.a = gl_TexCoord[0].z + 4.0*texture2DProj(tex3, gl_TexCoord[0]).a;
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
	]],
	[[
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0);
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, refract, invfresnel);
	]]
)

Shader.fast("waterfade", "waterfadefast", 2)
Shader.alt("waterfade", "waterrefract")

watershader("waterenv", true, false,
	[[
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0); 
		vec3 reflect = textureCube(tex0, camvec - 2.0*invfresnel*bump).rgb;
	]],
	[[
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, gl_Color.rgb*depth.x, invfresnel) + spec*light;
		gl_FragColor.a = invfresnel*depth.y; 
	]]
)

watershader("waterenvfast", false, false,
	[[
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0); 
		vec3 reflect = textureCube(tex0, camvec - 2.0*invfresnel*bump).rgb;
	]],
	[[
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, gl_Color.rgb*depth.x, invfresnel);
		gl_FragColor.a = invfresnel*depth.y; 
	]]
)

Shader.fast("waterenv", "waterenvfast", 2)
Shader.alt("waterenv", "waterenvfast")

watershader("waterenvrefract", true, true,
	[[
		vec2 dtc = gl_TexCoord[2].xy + 0.025*dudv;
		vec3 bump = texture2D(tex1, dtc).rgb*2.0 - 1.0;
		dudv = texture2D(tex2, dtc).xy*2.0 - 1.0;

		vec3 refract = texture2D(tex3, gl_TexCoord[0].xy/gl_TexCoord[0].w + 0.01*dudv).rgb;
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0); 
		vec3 reflect = textureCube(tex0, camvec - 2.0*invfresnel*bump).rgb;
	]],
	[[
		<%=reflectivity%>
		gl_FragColor = vec4(mix(reflect, refract, invfresnel) + spec*light, 0.0);
	]]
)

watershader("waterenvrefractfast", false, true,
	[[
		vec3 refract = texture2DProj(tex3, gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0)).rgb;
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0); 
		vec3 reflect = textureCube(tex0, camvec - 2.0*invfresnel*bump).rgb;
	]],
	[[
		<%=reflectivity%>
		gl_FragColor = vec4(mix(reflect, refract, invfresnel), 0.0);
	]]
)

Shader.fast("waterenvrefract", "waterenvrefractfast", 2)
Shader.alt("waterenvrefract", "waterenvrefractfast")

watershader("waterenvfade", true, true,
	[[
		vec2 dtc = gl_TexCoord[2].xy + 0.025*dudv;
		vec3 bump = texture2D(tex1, dtc).rgb*2.0 - 1.0;
		dudv = texture2D(tex2, dtc).xy*2.0 - 1.0;

		vec2 projtc = gl_TexCoord[0].xy/gl_TexCoord[0].w;
		vec3 refract = texture2D(tex3, projtc + 0.01*dudv).rgb;
		float fade = gl_TexCoord[0].z + 4.0*texture2D(tex3, projtc).a;
		gl_FragColor.a = fade * clamp(gl_FragCoord.z, 0.0, 1.0);

		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0); 
		vec3 reflect = textureCube(tex0, camvec - 2.0*invfresnel*bump).rgb;
	]],
	[[
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, refract, invfresnel) + spec*light;
	]]
)

watershader("waterenvfadefast", false, true,
	[[
		vec3 refract = texture2DProj(tex3, gl_TexCoord[0] + vec4(0.4*dudv, 0.0, 0.0)).rgb;
		gl_FragColor.a = gl_TexCoord[0].z + 4.0*texture2DProj(tex3, gl_TexCoord[0]).a;
		vec3 bump = texture2D(tex1, gl_TexCoord[2].xy + 0.025*dudv).rgb*2.0 - 1.0;
		float invfresnel = clamp(dot(camvec, bump), 0.0, 1.0); 
		vec3 reflect = textureCube(tex0, camvec - 2.0*invfresnel*bump).rgb;
	]],
	[[
		<%=reflectivity%>
		gl_FragColor.rgb = mix(reflect, refract, invfresnel);
	]]
)

Shader.fast("waterenvfade", "waterenvfadefast", 2)
Shader.alt("waterenvfade", "waterenvrefract")

causticargs = {}
function causticshader (...)
	causticargs = { ... }
	lazyshader(4, causticargs[1],
		[[
			#pragma CUBE2_fog
			uniform vec4 texgenS, texgenT;
			void main(void)
			{
				gl_Position = ftransform();
				gl_TexCoord[0].xy = vec2(dot(texgenS.xyz, gl_Vertex.xyz), dot(texgenT.xyz, gl_Vertex.xyz)); 
			}
		]],
		[[
			uniform vec4 frameoffset;
			uniform sampler2D tex0, tex1;
			void main(void)
			{
				<%=causticargs[2]%>
			}
		]]
	)
end

causticshader("caustic",
	[[
		gl_FragColor = frameoffset.x*texture2D(tex0, gl_TexCoord[0].xy) + frameoffset.y*texture2D(tex1, gl_TexCoord[0].xy);
	]]
)

causticshader("causticfast",
	[[
		gl_FragColor = frameoffset.z*texture2D(tex0, gl_TexCoord[0].xy);
	]]
)

Shader.fast("caustic", "causticfast", 2)

lazyshader(4, "lava",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			gl_FragColor = gl_Color * texture2D(tex0, gl_TexCoord[0].xy) * 2.0; 
		}
	]]
)

lazyshader(4, "lavaglare",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color*2.0 - 1.0;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			vec4 glow = texture2D(tex0, gl_TexCoord[0].xy) * gl_Color;
			float k = max(glow.r, max(glow.g, glow.b));
			gl_FragColor = glow*k*k*32.0;
		}
	]]
)

lazyshader(4, "waterfallrefract",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
			gl_TexCoord[1] = gl_TextureMatrix[0] * gl_Vertex; 
		}
	]],
	[[
		uniform vec4 dudvoffset;
		uniform sampler2D tex0, tex2, tex4;
		void main(void)
		{
			vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);
			vec2 dudv = texture2D(tex2, gl_TexCoord[0].xy + 0.2*diffuse.xy + dudvoffset.xy).xy; 
			vec4 refract = texture2DProj(tex4, gl_TexCoord[1] + vec4(4.0*dudv, 0.0, 0.0));
			gl_FragColor = mix(refract, gl_Color, diffuse);
		}
	]]
)

lazyshader(4, "waterfallenvrefract",
	[[
		#pragma CUBE2_fog
		uniform vec4 camera;
		varying vec3 camdir;
		varying mat3 world; 
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
			gl_TexCoord[1] = gl_TextureMatrix[0] * gl_Vertex;
			camdir = camera.xyz - gl_Vertex.xyz;
			vec3 absnorm = abs(gl_Normal);
			world = mat3(absnorm.yzx, -absnorm.zxy, gl_Normal);
		}
	]],
	[[
		uniform vec4 dudvoffset;
		uniform sampler2D tex0, tex1, tex2, tex4;
		uniform samplerCube tex3;
		varying vec3 camdir;
		varying mat3 world; 
		void main(void)
		{
			vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);
			vec2 dudv = texture2D(tex2, gl_TexCoord[0].xy + 0.2*diffuse.xy + dudvoffset.xy).xy; 
			vec3 normal = world * (texture2D(tex1, gl_TexCoord[0].xy + 0.1*dudv).rgb*2.0 - 1.0);
			vec4 refract = texture2DProj(tex4, gl_TexCoord[1] + vec4(4.0*dudv, 0.0, 0.0));
			vec3 camvec = normalize(camdir);
			float invfresnel = dot(normal, camvec);
			vec4 reflect = textureCube(tex3, 2.0*invfresnel*normal - camvec);
			gl_FragColor = mix(mix(reflect, refract, 1.0 - 0.4*step(0.0, invfresnel)), gl_Color, diffuse); 
		}
	]]
)
Shader.alt("waterfallenvrefract", "waterfallrefract")

lazyshader(4, "waterfallenv",
	[[
		#pragma CUBE2_fog
		uniform vec4 camera;
		varying vec3 camdir;
		varying mat3 world; 
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
			camdir = camera.xyz - gl_Vertex.xyz;
			vec3 absnorm = abs(gl_Normal);
			world = mat3(absnorm.yzx, -absnorm.zxy, gl_Normal);
		}
	]],
	[[
		uniform vec4 dudvoffset;
		uniform sampler2D tex0, tex1, tex2;
		uniform samplerCube tex3;
		varying vec3 camdir;
		varying mat3 world; 
		void main(void)
		{
			vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);
			vec2 dudv = texture2D(tex2, gl_TexCoord[0].xy + 0.2*diffuse.xy + dudvoffset.xy).xy; 
			vec3 normal = world * (texture2D(tex1, gl_TexCoord[0].xy + 0.1*dudv).rgb*2.0 - 1.0);
			vec3 camvec = normalize(camdir);
			vec4 reflect = textureCube(tex3, 2.0*dot(normal, camvec)*normal - camvec);
			gl_FragColor.rgb = mix(reflect.rgb, gl_Color.rgb, diffuse.rgb);
			gl_FragColor.a = 0.25 + 0.75*diffuse.r;    
		}
	]]
)

lazyshader(4, "glass",
	[[
		uniform vec4 camera;
		varying vec3 rvec, camdir, normal;
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			rvec = gl_MultiTexCoord0.xyz;
			camdir = camera.xyz - gl_Vertex.xyz;
			normal = gl_Normal;
		}
	]],
	[[
		#pragma CUBE2_fogrgba vec4(0.0, 0.0, 0.0, 1.0)
		uniform samplerCube tex0;
		varying vec3 rvec, camdir, normal;
		void main(void)
		{
			vec3 camvec = normalize(camdir);
			vec3 reflect = textureCube(tex0, rvec).rgb;
   
			float invfresnel = max(dot(camvec, normal), 0.70); 
			gl_FragColor.rgb = mix(reflect, gl_Color.rgb*0.05, invfresnel);
			gl_FragColor.a = invfresnel * 0.95;
    }
	]]
)

lazyshader(4, "glassfast",
	[[
		varying vec3 rvec;
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			rvec = gl_MultiTexCoord0.xyz;
		}
	]],
	[[
		#pragma CUBE2_fogrgba vec4(0.0, 0.0, 0.0, 1.0)
		uniform samplerCube tex0;
		varying vec3 rvec;
		void main(void)
		{
			vec3 reflect = textureCube(tex0, rvec).rgb;
			const float invfresnel = 0.75;
			gl_FragColor.rgb = mix(reflect, gl_Color.rgb*0.05, invfresnel);
			gl_FragColor.a = invfresnel * 0.95; 
		}
	]]
)

Shader.fast("glass", "glassfast", 2)
Shader.alt("glass", "glassfast")

lazyshader(4, "grass",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
			gl_TexCoord[1].xy = gl_MultiTexCoord1.xy;
		}
	]],
	[[
		uniform sampler2D tex0, tex1;
		void main(void)
		{
			vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);
			vec4 lm = texture2D(tex1, gl_TexCoord[1].xy);
			diffuse.rgb *= 2.0;
			gl_FragColor = diffuse * lm * gl_Color;
		}
	]]
)

Shader.normal(4, "overbrightdecal",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);
			gl_FragColor = mix(gl_Color, diffuse, gl_Color.a);
		}
	]]
)

Shader.normal(4, "saturatedecal",
	[[
		#pragma CUBE2_fog
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			vec4 diffuse = texture2D(tex0, gl_TexCoord[0].xy);
			diffuse.rgb *= 2.0;
			gl_FragColor = diffuse * gl_Color;
		}
	]]
)

Shader.normal(4, "skyboxglare",
	[[
		void main(void)
		{
			gl_Position = ftransform();
			gl_FrontColor = gl_Color;
			gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
		}
	]],
	[[
		uniform sampler2D tex0;
		void main(void)
		{
			vec4 glare = texture2D(tex0, gl_TexCoord[0].xy) * gl_Color;
			gl_FragColor.rgb = vec3(dot(glare.rgb, vec3(10.56, 10.88, 10.56)) - 30.4);
			gl_FragColor.a = glare.a;
		}
	]]
)
