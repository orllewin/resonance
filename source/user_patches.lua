import "string_utils"

class('UserPatches').extends()

function UserPatches:init()
		UserPatches.super.init(self)
		
end

function UserPatches:patchesMenu()
	
	local userPatches = {
		{
			name = "User patches:::",
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
