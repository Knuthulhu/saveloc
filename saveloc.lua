local PLAYER = FindMetaTable( "Player" )

--[[
		This function needs to be modified to work with your gamemode!
		If for example you're using Flow surf you need to change "if ply.Practice then" to "if ply.Style == _C.Style.Practice then"
--]]
function PLAYER:CanLoadLoc()
	if self.Practice then return true end

	return false
end

hook.Add( "PlayerInitialSpawn", "FullLoadSetup", function( ply )
	ply.Savelocs = {}	
end )

function SaveLocSave( ply, cmd, args )
    local id = #ply.Savelocs + 1
    
    if #args > 0 then
        local pos = Vector( args[ 1 ], args[ 2 ], args[ 3 ] )
		local ang = Angle( args[ 4 ], args[ 5 ], args[ 6 ] )
		local vel = Vector( args[ 7 ], args[ 8 ], args[ 9 ] )

		ply.Savelocs[ id ] = {
			Pos = pos,
			Ang = ang,
			Vel = vel
		}
        
        ply:ChatPrint( "Saved custom location to id #" .. id )
    else
        ply.Savelocs[ id ] = {
			Pos = ply:GetPos(),
			Ang = ply:EyeAngles(),
			Vel = ply:GetVelocity()
		}
        
        ply:ChatPrint( "Saved location to id #" .. id )
        ply:ChatPrint( "To recreate this location, use this concommand:\nsm_saveloc " .. tostring( ply:GetPos() ) .. " " .. tostring( ply:EyeAngles() ) .. " " .. tostring( ply:GetVelocity() ) )
    end
    
    ply.LastLoadedLoc = id
end
concommand.Add( "sm_saveloc", SaveLocSave )

function SaveLocLoad( ply, cmd, args )
    if not ply:CanLoadLoc() then return ply:ChatPrint( "You need to be in practice mode to use this command!" ) end

    local id = ( #args > 0 and tonumber( args[ 1 ] ) or ply.LastLoadedLoc )
    if not id then
		for i = 1, #ply.Savelocs do
			if ply.Savelocs[ i ].Pos then
				id = i
			end
		end
	end

    if ply.Savelocs[ id ] and ply.Savelocs[ id ].Pos then
		ply:SetPos( ply.Savelocs[ id ].Pos )
		ply:SetEyeAngles( ply.Savelocs[ id ].Ang )
		ply:SetLocalVelocity( ply.Savelocs[ id ].Vel )

		ply.LastLoadedLoc = id
	else
		ply:ChatPrint( "The saveloc you specified doesn't exist!" )
	end
end
concommand.Add( "sm_loadloc", SaveLocLoad )

function SaveLocPrev( ply, cmd, args )
	if not ply:CanLoadLoc() then return ply:ChatPrint( "You need to be in practice mode to use this command!" ) end

	local id = ply.LastLoadedLoc
	if not id then return ply:ChatPrint( "No locations saved!" ) end

	local min = 1
	if min == id then return ply:ChatPrint( "Already on first locaion!" ) end

	id = id - 1

	SaveLocLoad( ply, nil, { id } )
end
concommand.Add( "sm_prevloc", SaveLocPrev )

function SaveLocNext( ply, cmd, args )
	if not ply:CanLoadLoc() then return ply:ChatPrint( "You need to be in practice mode to use this command!" ) end

	local id = ply.LastLoadedLoc
	if not id then return ply:ChatPrint( "No locations saved!" ) end

	local max = #ply.Savelocs
	if max == id then return ply:ChatPrint( "Already on latest locaion!" ) end

	id = id + 1

	SaveLocLoad( ply, nil, { id } )
end
concommand.Add( "sm_nextloc", SaveLocNext )

function SaveLocLast( ply, cmd, args )
	if not ply:CanLoadLoc() then return ply:ChatPrint( "You need to be in practice mode to use this command!" ) end

	local id = #ply.Savelocs

	SaveLocLoad( ply, nil, { id } )
end
concommand.Add( "sm_lastloc", SaveLocLast )

function SaveLocFirst( ply, cmd, args )
	if not ply:CanLoadLoc() then return ply:ChatPrint( "You need to be in practice mode to use this command!" ) end

	local id = 1

	SaveLocLoad( ply, nil, { id } )
end
concommand.Add( "sm_firstloc", SaveLocFirst )

function SaveLocDelCur( ply, cmd, args )
	local id = ply.LastLoadedLoc

	if not id then id = #ply.Savelocs end

	ply.Savelocs[ id ] = nil

	ply.LastLoadedLoc = ply.LastLoadedLoc - 1

	ply:ChatPrint( "Current location have been removed!" )
end
concommand.Add( "sm_delcurloc", SaveLocDelCur )

function SaveLocDelAll( ply, cmd, args )
	ply.Savelocs = {}
	ply:ChatPrint( "All locations have been removed!" )
end
concommand.Add( "sm_delallloc", SaveLocDelAll )
