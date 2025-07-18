# Inventory System Documentation

## Overview
The inventory system has been successfully implemented in GodotOS with the following features:

## Scene Structure
The main scene now includes the required hierarchy:
```
MainScene.tscn
├── Stream (Control)
    ├── inventory (Control) [InventoryManager script]
    │   ├── Background (Panel) [Styled with dark theme]
    │   ├── InventoryLabel (Label) 
    │   └── GridContainer (8 columns for inventory items)
    ├── Table (Control) [Table script, drop_target group]
    │   ├── Background (Panel) [Wood-like styling]
    │   ├── DropZone (Control)
    │   └── Label 
    └── SimpleShop (Control) [Shop for purchasing items]
        └── VBoxContainer
            ├── ItemLabel
            └── PurchaseButton
```

## Components Created

### 1. FoodItem (Base Component)
- **Location**: `Scenes/Inventory/FoodItem.tscn` + `FoodItem.gd`
- **Purpose**: Base food item class with texture, name, and description
- **Features**: 
  - Configurable item properties
  - Image display with label
  - Data storage methods

### 2. InventoryItem (Draggable Component)
- **Location**: `Scenes/Inventory/InventoryItem.tscn` + `InventoryItem.gd`
- **Purpose**: Draggable inventory items that only show images (no labels)
- **Features**:
  - Mouse hover highlighting
  - Drag and drop functionality using `_gui_input`
  - Visual drag preview
  - Semi-transparent while dragging
  - Signal emission on drop

### 3. InventoryManager (System Controller)
- **Location**: `Scenes/Inventory/InventoryManager.gd`
- **Purpose**: Manages the inventory grid and item operations
- **Features**:
  - Grid-based layout (8 columns)
  - Item addition/removal
  - Drag and drop handling
  - Table placement detection
  - Smooth item repositioning with tweens
  - Auto-populated test items

### 4. Table (Drop Target)
- **Location**: `Scenes/Inventory/Table.tscn` + `Table.gd`
- **Purpose**: Surface for placing dragged inventory items
- **Features**:
  - Drop zone detection
  - Item placement tracking
  - Visual feedback
  - Group-based targeting (`drop_target`)

### 5. SimpleShop (Item Source)
- **Location**: `Scenes/Inventory/SimpleShop.tscn` + `SimpleShop.gd`
- **Purpose**: Allows purchasing items to add to inventory
- **Features**:
  - Cycling through available items
  - Purchase button integration
  - Connected to inventory via signals

## Drag and Drop System

### How it Works:
1. **Start Drag**: Mouse button down on InventoryItem
   - Creates drag preview
   - Makes original semi-transparent
   - Tracks mouse movement via `_input`

2. **During Drag**: Mouse movement updates position
   - Item follows mouse cursor
   - Preview shows what's being dragged

3. **End Drag**: Mouse button release
   - Checks for valid drop targets (tables)
   - Falls back to inventory repositioning
   - Smooth animation return if invalid drop

### Drop Target Priority:
1. **Table**: Items dropped on table are removed from inventory
2. **Inventory Grid**: Items repositioned within inventory
3. **Outside**: Items return to original position with animation

## Visual Styling

### Inventory Panel:
- Dark semi-transparent background
- Rounded corners with border
- Grid layout with proper spacing

### Table:
- Wood-like brown color scheme
- Bordered appearance
- Clear drop zone indication

### Items:
- Hover highlighting
- Smooth transitions
- Visual feedback during interactions

## Integration Points

### Main Scene Connection:
```gdscript
# In MainScene _ready():
var shop = $Stream/SimpleShop
var inventory = $Stream/inventory

if shop and inventory:
    shop.item_purchased.connect(inventory.add_item)
```

### Signal Flow:
```
Shop.item_purchased → InventoryManager.add_item → InventoryItem.item_dropped → Table.accept_item_drop
```

## Testing & Demo
- Test items automatically populate the inventory on startup
- Shop allows purchasing additional items
- Drag items from inventory to table to see placement system
- Items can be reordered within the inventory grid

## Future Enhancements
1. Item stacking system
2. Item tooltips showing descriptions
3. Save/load inventory state
4. More complex item interactions
5. Multiple table types
6. Item combination system