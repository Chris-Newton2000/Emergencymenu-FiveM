-- you can change the name of the menu, the first one (YARP Menu is the head) but the 2nd one (YARP Community Departments Menu) is the description
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("YARP Menu", "~b~YARP Community Departments Menu~b~")
_menuPool:Add(mainMenu)

-- Used in "first menu" do not change it to true!!!
bool = false

-- this menu is a checkbox item
-- you can change the text in the "Do u like this server" to ex. are you good?
function FirstItem(menu)
    local checkbox = NativeUI.CreateCheckboxItem("Do u like this server?", bool, "Toogle this")
    menu:AddItem(checkbox)
    menu.OnCheckboxChange = function(sender, item, checked_)
        if item == checkbox then
            bool = checked_
            notify(tostring(bool))
            
        end
    end
end
-- on the 22nd line on the end you can change from heal to ex. heal me
-- you can change the notify from 30 to example: You got healed by our doctor :)
function SecondItem(menu)
    local click = NativeUI.CreateItem("~g~Heal", "~g~Heal Yourself")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender ,item, index)
        if item == click then
            SetEntityHealth(PlayerPedId(), 200)
            notify("~g~Player Healed Succesfully.")

        end
    end
end


--used in third item, loadout of community officers
-- on 63th line you can change the notify to ex. EMS Loadout given, you can do this on 57th line too!
--weapons (configurable, look on https://vespura.com/fivem/weapons/stats/ to get weapons name)
weapons = {
    "weapon_sniperrifle",
    "weapon_assaultrifle",
    "weapon_bzgas",
    "weapon_bullpuprifle",
    "weapon_combatpistol",
    "weapon_fireextinguisher",
    "weapon_flashlight",
    "weapon_knife",
    "weapon_marksmanrifle",
    "weapon_pistol",
    "weapon_pistol50",
    "weapon_pumpshotgun",
    "weapon_smg",
    "weapon_stungun"
}
function ThirdItem(menu)
    local gunList = NativeUI.CreateListItem("Get CO Loadout", weapons, 1)
    menu:AddItem(gunList)
    menu.OnListSelect = function(sender,item,index)
        if item == gunList then
            local selectedGun = item:IndexToItem(index)
            giveWeapon(selectedGun)
            notify("Community Officer Loadout given succesfully~b~".. selectedGun)
   
        end
    end
end
-- used in fourth item
-- if u want to use it as Community Paramedic Menu or something like this you can change the name of car at 71th line and on 71th
-- on 76th line you have the name of the car that you can change ex. from pcop to ambulance
seats = {-1,0,1,2}
function FourthItem(menu)
    local submenu = _menuPool:AddSubMenu(menu, "~b~ CO Car")
    local carItem = NativeUI.CreateItem("Spawn Car", "Spawn CO Car")
    carItem.Activated = function(sender, item)
        if item == carItem then
            spawnCar("pcop")
            notify("spawned a community officer car")
        end
    end
    local seat = NativeUI.CreateSliderItem("Change Seat", seats, 1)
    submenu.OnSliderChange = function {sender, item, index}
        if item == seat then
            vehSeat = item:IndexToItem(index)
            local pedsCar = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetPedIntoVehicle(PlayerPedId(), pedsCar, vehSeat)
    submenu:AddItem(carItem)
    submenu:AddItem(seat)
end

firstItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
FourthItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPress(1,51) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)



function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function giveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)
    
    --[[ SetEntityAsMissionEntity(vehicle, true, true) ]]
end