import "string_utils"

class('UserPatches').extends()

function UserPatches:init()
		UserPatches.super.init(self)
		
end

function UserPatches:patchesMenu()
	
	local userPatches = {
		{
			name = "User patches:",
			type = "category_title"
		}
	}
	local files = playdate.file.listFiles()
	local count = 1
	for f = 1,#files,1 do
		local file = files[f]
		if endswith(file, ".res.json") then
			local userPatch = playdate.datastore.read(replace(file, ".json", ""))
			userPatch.file = file
			table.insert(userPatches, userPatch)
		end
	end
	
	return userPatches
end

function UserPatches:patches()
	
	local userPatches = {}
	local files = playdate.file.listFiles()
	print("looking for user patches")
	local count = 1
	for f = 1,#files,1 do
		local file = files[f]
		if endswith(file, ".res.json") then
			print("found user patch: " .. file)
			local userPatch = playdate.datastore.read(replace(file, ".json", ""))
			userPatch.file = file
			userPatches[count] = userPatch
			count += 1
		end
	end
	
	print("user patch count: " .. #userPatches)
	return userPatches
end