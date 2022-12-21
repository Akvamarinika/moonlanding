Menu = {}
Menu.__index = Menu

function Menu:create(menuitems, exitItem, index, menuWidth, rowSize)
    local menu = {}
    setmetatable(menu, Menu)
    menu.index = 1 or index
    menu.menuWidth = menuWidth
    menu.rowSize = rowSize
    menu.items = menuitems or {}
    menu.changeSoundItem = nil
    menu.confirmSound = nil
    --menu.m = menuitems or {index = 1, items = {},  changeSoundItem = nil, confirmSound = nil, cancelSound = nil}
    return menu
end

function Menu:next()
    if self.index < #self.items then 
        self.index = self.index + 1
        SoundManager.playSound(self.changeSoundItem)
    end
end

function Menu:prev()
    if self.index > 1 then 
        self.index = self.index - 1
        SoundManager.playSound(self.changeSoundItem)
    end
end

function Menu:confirm()
    SoundManager.PlaySound(self.confirmSound)
    self.items[self.index].callback()
end


MenuItem = {}
MenuItem.__index = MenuItem

function MenuItem:create(name, translation, callback)
    local menuItem = {}
    setmetatable(menuItem, MenuItem)
    menuItem.name = name or "item"
    menuItem.translation = translation or "item"
    menuItem.callback = function () 
        
    end
end