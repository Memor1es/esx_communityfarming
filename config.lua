Config                            = {} -- leave this alone

Config.lockerRoom = {x = 2932.03, y = 4624.34, z = 48.72} -- change position of locker room marker and blip
Config.selectVehicle = {x = 2932.36, y = 4618.44, z = 48.72, spawnX = 2921.78, spawnY = 4632.62, spawnZ = 48.55, spawnHeading = 307.97} -- change position of vehicle spawn marker and where the vehicle will spawn
Config.deleteVehicle = {x = 2921.63, y = 4624.09, z = 48.55} -- change position of vehicle delete marker

-- add, remove and modify farms to your pleasing, change the name, map blip location, each corner location (should be roughly a square shape), and the number of crops in each row
Config.farms = {
    {name = "Grapeseed 1", mapX = 2055.99, mapY = 4927.36, mapZ = 40.96, corner1 = {x = 2096.66, y = 4917.54, z = 40.97}, corner2 = {x = 2068.26, y = 4888.88, z = 40.97}, corner3 = {x = 2045.56, y = 4968.12, z = 40.97}, corner4 = {x = 2017.38, y = 4939.46, z = 40.97}, cropsPerRow = 15},
}

Config.wheatSell = {x = 2886.65, y = 4385.71, z = 50.66, price = 1000} -- change the location of the wheat selling point map blip and marker, also change the sell price for wheat

-- change the male and female uniforms
Config.Uniforms = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 42,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 11,
        ['pants_1'] = 0,   ['pants_2'] = 0,
        ['shoes_1'] = 51,   ['shoes_2'] = 0,
        ['chain_1'] = 0,  ['chain_2'] = 0
    },
    female = {
        ['tshirt_1'] = 2,   ['tshirt_2'] = 0,
        ['torso_1'] = 86,  ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 9,
        ['pants_1'] = 25,   ['pants_2'] = 0,
        ['shoes_1'] = 9,   ['shoes_2'] = 2,
        ['chain_1'] = 0,    ['chain_2'] = 0
    }
}