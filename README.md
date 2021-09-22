# Metadata car keys using linden_inventory
 *Big thanks to Bazsi#7565 for helping me with metadata*

•» shared/items.lua
```lua
['carkeys'] = {
	label = "Klice od auta",
	weight = 0,
	stack = false,
	close = true,
	client = {
		consume = 0,
		usetime = 500,
		event = 'ice_metakeys:OpenCloseCar'
	}
}
```

•» server/player.lua
```lua
elseif item:find('carkeys') then
	count = 1
	if next(metadata) == nil then
		metadata = {}
		metadata.type = 'Čisté klíče od auta'
		metadata.description = 'Použij /carkey pro vytvoření klíče pro tvé auto'
	end
```