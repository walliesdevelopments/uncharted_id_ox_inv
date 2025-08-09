# Uncharted ID - License & ID Card System

A comprehensive FiveM script for QBCore that provides realistic license and ID card display functionality with animations and proximity-based viewing.

## Features

- **Multiple License Types**: Driver License, Motorbike License, Truck License, Firearms License, and ID Card
- **Realistic Animations**: Players perform a paper-showing animation when displaying licenses
- **Proximity Display**: Licenses are automatically shown to nearby players within a 10-meter radius
- **Authentic Designs**: Victoria, Australia-styled license cards with proper formatting
- **Photo Integration**: Supports mugshot integration via MugShotBase64 export
- **Address System**: Pulls player address data from QBCore metadata or housing systems
- **Interactive UI**: Clean, responsive HTML/CSS interface positioned on the right side of screen

## License Types Supported

1. **Driver License** (`vic_driver_license`) - Standard car driving license
2. **Motorbike License** (`vic_motorbike_license`) - Motorcycle endorsement
3. **Truck License** (`vic_truck_license`) - Heavy vehicle license
4. **Firearms License** (`vic_weaponlicense`) - Weapons permit
5. **ID Card** (`vic_id_card`) - Proof of age/identification card

## Installation

1. Place the `uncharted_id` folder in your `reacource` directory
2. Get Mugshotbase
3. Add `ensure uncharted_id` to your `server.cfg`
4. Add the license items to your QBCore shared items:

```lua
-- Add to qb-core/shared/items.lua
['vic_driver_license'] = {
    ['name'] = 'vic_driver_license',
    ['label'] = 'Driver License',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'driver_license.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A valid driver license'
},
['vic_motorbike_license'] = {
    ['name'] = 'vic_motorbike_license',
    ['label'] = 'Motorbike License',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'motorbike_license.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A valid motorbike license'
},
['vic_truck_license'] = {
    ['name'] = 'vic_truck_license',
    ['label'] = 'Truck License',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'truck_license.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A valid truck license'
},
['vic_weaponlicense'] = {
    ['name'] = 'vic_weaponlicense',
    ['label'] = 'Firearms License',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'weapon_license.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A valid firearms license'
},
['vic_id_card'] = {
    ['name'] = 'vic_id_card',
    ['label'] = 'ID Card',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'id_card.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A valid identification card'
}
```

## Dependencies

- **QBCore Framework** - Required for core functionality
- **MugShotBase64** (Optional) - For live photo capture functionality

## Usage

### For Players

1. **Using Items**: Right-click any license item in inventory and select "Use"
2. **Animation**: Character will perform a paper-showing animation
3. **Viewing**: License appears on the right side of the screen for nearby players
4. **Closing**: Press `R`, `ESC`, or `Backspace` to close the license display

### Commands

- `/showlicense [type]` - Manually show a license (default: driver)
  - Types: `driver`, `motorbike`, `truck`, `firearms`, `id-card`
- `/closelicense` - Manually close license display

### For Developers

#### Server Events

```lua
-- Show license to nearby players
TriggerServerEvent('license:server:showLicense', coords, { type = "driver" })
```

#### Client Events

```lua
-- Trigger license usage
TriggerEvent('uncharted_id:client:useDriverLicense')
TriggerEvent('uncharted_id:client:useMotorbikeLicense')
TriggerEvent('uncharted_id:client:useTruckLicense')
TriggerEvent('uncharted_id:client:useFirearmsLicense')
TriggerEvent('uncharted_id:client:useIdCard')

-- Display license to player
TriggerEvent('license:client:displayLicense', playerName, licenseType)
```

## Configuration

### Address System

The script automatically pulls address information from:
1. `PlayerData.metadata.address`
2. `PlayerData.charinfo.address`
3. Fallback to default Victoria address

### Photo Integration

Photos are handled through multiple methods:
1. **MugShotBase64** - Live mugshot capture (recommended)
2. **Database Photos** - Stored player photos
3. **Default URLs** - Fallback photo system

## File Structure

```
uncharted_id/
├── client/
│   └── main.lua          # Client-side logic and UI handling
├── server/
│   └── main.lua          # Server-side item registration and events
├── html/
│   ├── index.html        # License display templates
│   ├── sytle.css         # License styling and animations
│   └── script.js         # Frontend JavaScript logic
└── README.md             # This file
```

## Customization

### Adding New License Types

1. **Server Side**: Add new useable item in `server/main.lua`
2. **Client Side**: Add corresponding client event in `client/main.lua`
3. **Frontend**: Add HTML template and CSS styling in `html/` folder
4. **JavaScript**: Add display function in `script.js`

### Styling

Modify `html/sytle.css` to customize:
- License card colors and gradients
- Font styles and sizes
- Animation effects
- Positioning and layout

### Animation

Change the animation in `client/main.lua`:
```lua
local animDict = "paper_1_rcm_alt1-8"
local animName = "player_one_dual-8"
```

## Troubleshooting

### Common Issues

1. **License not showing**: Check console for JavaScript errors
2. **Animation not playing**: Ensure animation dictionary is valid
3. **Photos not loading**: Verify MugShotBase64 export exists
4. **Address showing default**: Check QBCore player metadata structure

### Debug Mode

Enable debug prints by uncommenting console logs in the server-side script to track license display events.

## Support & Credits

- **Framework**: QBCore
- **Design**: Victoria, Australia license styling
- **Animation**: GTA V native animations
- **Photo System**: MugShotBase64 integration

## License

This script is provided as-is for FiveM roleplay servers. Modify and distribute according to your server's needs.

## Changelog

### Version 1.0
- Initial release with 5 license types
- Proximity-based display system
- Animation integration
- Photo support via MugShotBase64
- Address system integration

