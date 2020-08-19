# esx_communityfarming
Community farming resource for ESX servers on FiveM

This job is made for groups of people to work on the same farm simultaniously to work towards a similar goal.

(This is my first FiveM resource, it may be unoptimized or written poorly but I'm happy with the result)

### Features
- Configuration options to change map blip, marker locations, uniforms and prices
- Easily modify, add and remove your own farms in the config file to setup as many farms as you like as big or small as you like (note: more farms and bigger sizes may cause performance loss)
- Crops sync across players making it easy for groups of players to work on the same field at the same time

### Download & Installation
1. Download the [latest version](https://github.com/xXJamieXx/esx_communityfarming/releases/latest) and extract it to a folder called `esx_communityfarming` in your resources folder (probably `resources/[esx]`)
2. Import `esx_communityfarming.sql` into your database
3. Add `ensure esx_communityfarming` into your server.cfg file

### Possible Future Plans
- Add multiple configurable crop types
- Add multiple configurable vehicle types and trailer types
- Take user suggestions and possibly add them
- Fix any bugs or exploits and make optimizations where needed

### Known Caveats
- The more crops that have been planted, the slower they will grow because it is iterating over more items in the table

### License
Copyright (C) 2020 xXJamie_Xx

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the license, or (at your discretion) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
