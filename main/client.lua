ESX = exports.es_extended.getSharedObject()

Citizen.CreateThread(function()
    if Config.FloorList == "ContextMenu" then
        createContextMenu()
    elseif Config.FloorList == "Target" then
        createTarget()
    else
        print('Błędna konfiguracja skryptu')
    end
end)

function IsPlayerInZone(playerPed, floor)
    local playerCoords = GetEntityCoords(playerPed)
        
    local zone = {
        coords = floor.coords,
        size = floor.size,
        heading = floor.heading
    }

    local tolerance = 2.0 

    local boxMin = vector3(zone.coords.x - (zone.size.x / 2) - tolerance, zone.coords.y - (zone.size.y / 2) - tolerance, zone.coords.z - tolerance)
    local boxMax = vector3(zone.coords.x + (zone.size.x / 2) + tolerance, zone.coords.y + (zone.size.y / 2) + tolerance, zone.coords.z + zone.size.z + tolerance)

    return playerCoords.x >= boxMin.x and playerCoords.x <= boxMax.x and
           playerCoords.y >= boxMin.y and playerCoords.y <= boxMax.y and
           playerCoords.z >= boxMin.z and playerCoords.z <= boxMax.z
end

function createContextMenu()
    local function openContextMenu(building, floors)
        local floorOptions = {}
        
        local playerPed = PlayerPedId()

        for i = 1, #floors do
            local floor = floors[i] 

            local isCurrentFloor = IsPlayerInZone(playerPed, floor)

            table.insert(floorOptions, {
                title = floor.title,
                description = floor.description,
                icon = floor.icon ~= "" and floor.icon or nil,
                onSelect = function()
                    local playerPed = PlayerPedId() 
                    local requiredJob = floor.job
                    if requiredJob ~= 'none' and not IsPlayerAllowedToAccess(requiredJob) then
                        lib.notify({
                            description = 'Nie masz uprawnień do wybrania tego piętra',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                    color = '#909296'
                                }
                            },
                            type = 'error'
                        })
                        return
                    end
                    selectingfloord(floor)
                end,
                disabled = isCurrentFloor 
            })
        end
        
        lib.registerContext({
            id = 'elevator_menu',
            title = building, 
            options = floorOptions,
        })
    
        lib.showContext('elevator_menu')
    end
    
    for building, floors in pairs(Config.Elevators) do
        for _, floor in pairs(floors) do
            local zoneParameters = {
                coords = floor.coords,
                name = 'elevator_' .. building .. '_' .. floor.title,
                size = floor.size, 
                rotation = floor.heading,
                debug = Config.DebugZone, 
                options = {
                    {
                        label = "Skorzystaj z windy",
                        icon = "fa-solid fa-elevator",
                        onSelect = function()
                            openContextMenu(building, floors)
                        end,
                        distance = 2,
                    }
                },
            }

            exports.ox_target:addBoxZone(zoneParameters)
        end
    end
end

function createTarget()
    for buildingName, floors in pairs(Config.Elevators) do
        local floorNumbers = {}
        for floorNumber in pairs(floors) do
            table.insert(floorNumbers, floorNumber)
        end
        
        table.sort(floorNumbers)

        for _, floorNumber in ipairs(floorNumbers) do
            local floorData = floors[floorNumber]

            local options = {}
            
            for _, targetFloorNumber in ipairs(floorNumbers) do
                local targetFloorData = floors[targetFloorNumber]
                
                table.insert(options, {
                    icon = "fa-solid fa-elevator",
                    label = targetFloorData.title,
                    distance = 2,
                    onSelect = function()
                        local playerPed = PlayerPedId()
                        local isCurrentFloor = IsPlayerInZone(playerPed, targetFloorData)
                        if isCurrentFloor then
                            lib.notify({
                                description = 'Znajdujesz się na wybranym piętrze',
                                style = {
                                    backgroundColor = '#141517',
                                    color = '#C1C2C5',
                                    ['.description'] = {
                                      color = '#909296'
                                    }
                                },
                                type = 'error'
                            })
                            return
                        else
                            local playerPed = PlayerPedId() 
                            local requiredJob = targetFloorData.job
                            if requiredJob ~= 'none' and not IsPlayerAllowedToAccess(requiredJob) then
                                lib.notify({
                                    description = 'Nie masz uprawnień do wybrania tego piętra',
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#C1C2C5',
                                        ['.description'] = {
                                          color = '#909296'
                                        }
                                    },
                                    type = 'error'
                                })
                                return
                            end
                            selectingfloord(targetFloorData)
                        end
                    end, 
                })
            end
            
            exports.ox_target:addBoxZone({
                coords = floorData.coords, 
                size = floorData.size, 
                rotation = floorData.heading, 
                debug = Config.DebugZone,
                name = buildingName .. "_floor_" .. floorNumber, 
                options = options, 
            })
        end
    end
end

local cameraActive = false
local elevatorActive = false

function selectingfloord(targetFloorData)
    if elevatorActive then
        lib.notify({
            description = 'Poczekaj chwilę przed wybraniem następnego piętra',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            type = 'error'
        })
        return
    end

    local playerPed = PlayerPedId() 
    local playerCoords = GetEntityCoords(playerPed)
    local currentFloor = GetCurrentFloor(playerCoords)

    elevatorActive = true

    SetEntityHeading(playerPed, currentFloor.heading + 180)
    playAnim(PlayerPedId(), 'anim@apt_trans@buzzer', 'buzz_short', 3500, 50)

    Citizen.Wait(3000)

    DoScreenFadeOut(500)
    Citizen.Wait(500)

    SetEntityCoords(playerPed, currentFloor.coords.x, currentFloor.coords.y, currentFloor.coords.z - 1, false, false, false, true)
    SetEntityHeading(playerPed, currentFloor.heading)
    FreezeEntityPosition(playerPed, true) 
    SetEntityCollision(playerPed, false, false)
    playAnim(PlayerPedId(), 'missbigscore2aig_3', 'wait_for_van_c', -1, false)
    Citizen.Wait(500)
    DoScreenFadeIn(500)

    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local pedCoords = GetEntityCoords(playerPed)
    local pedHeading = GetEntityHeading(playerPed)

    local distance = 2.0 
    local height = 1.0 
    local forward = vector3(math.sin(math.rad(pedHeading)), -math.cos(math.rad(pedHeading)), 0.0)
    local cameraCoords = pedCoords + forward * -distance + vector3(0.0, 0.0, height)

    SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    PointCamAtEntity(camera, playerPed, vector3(0.0, 0.0, 0.5), true)
    SetCamFov(camera, 25.0) 

    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, true)
    SendNUIMessage({action = 'playSound'})

    cameraActive = true
    Citizen.CreateThread(function()
        while cameraActive do
            Citizen.Wait(0)
            DisableControlAction(0, 30, true) -- W lewo
            DisableControlAction(0, 31, true) -- W prawo
            DisableControlAction(0, 32, true) -- Do przodu
            DisableControlAction(0, 33, true) -- Do tyłu
            DisableControlAction(0, 44, true) -- Skok
            DisableControlAction(0, 21, true) -- Bieg
        end
    end)

    local timee = Config.Time * 1000
    lib.progressBar({
        duration = timee,
        label = 'Jedziesz windą',
        useWhileDead = false,
        canCancel = false
    })

    DoScreenFadeOut(500)
    Citizen.Wait(500)

    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(camera, false)
    SendNUIMessage({action = 'stopSound'})

    cameraActive = false
    FreezeEntityPosition(playerPed, false)
    SetEntityCollision(playerPed, true, true)
    ClearPedTasksImmediately(playerPed)
    SetEntityCoords(playerPed, targetFloorData.coords.x, targetFloorData.coords.y, targetFloorData.coords.z - 1, false, false, false, true)
    SetEntityHeading(playerPed, targetFloorData.heading)
    Citizen.Wait(600)
    elevatorActive = false
    DoScreenFadeIn(600)
end

function GetCurrentFloor(playerCoords)
    for elevatorName, elevatorFloors in pairs(Config.Elevators) do
        for floorIndex, floor in pairs(elevatorFloors) do
            local zoneName = "elevator_" .. elevatorName .. "_" .. floorIndex
            if IsPlayerInZone(PlayerPedId(), floor) then
                return floor
            end
        end
    end
    return nil
end

function IsPlayerAllowedToAccess(job)
    local playerData = ESX.GetPlayerData() 
    if type(job) == 'table' then
        for _, allowedJob in ipairs(job) do
            if allowedJob == playerData.job.name then
                return true
            end
        end
    elseif job == playerData.job.name then
        return true
    end
    return false
end

function playAnim(ped, animDict, animName, duration, emoteMoving, playbackRate)
    local movingType = 49
    if (emoteMoving == false) then 
        movingType = 0
    elseif (emoteMoving == 50) then
        movingType = 50
    end
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do 
        Citizen.Wait(100) 
    end

    TaskPlayAnim(ped, animDict, animName, 2.0, 2.0, duration, movingType, playbackRate or 0, false, false, false)
    RemoveAnimDict(animDict)
end

-- Posyłanie ludzi windą
RegisterNetEvent('mks:elevator:selectfloor', function(floor, player)
    lib.notify({
        description = 'Zostałeś wysłany na ' .. floor.title .. ' przez [' .. player .. ']',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
    })
    selectingfloord(floor)
end)

Citizen.CreateThread(function()
    if Config.WhitelistJob then
        local playerOptions = {
            {
                name = 'sendelevator',   
                icon = "fa-solid fa-elevator",
                label = "Poślij gracza windą",
                distance = 2.5,
                canInteract = function(entity)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local currentFloor = GetCurrentFloor(playerCoords)
                    local player = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    local isDead = Player(player).state.dead
                    local isHandcuff = Player(player).state.IsHandcuffed or Player(player).state.IsRoped
                    local target = isDead or isHandcuff
                    if target and currentFloor then
                        return true
                    end
                    return false
                end,
                onSelect = function(data)   
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local currentFloor = GetCurrentFloor(playerCoords)
                    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                    sendPlayer(currentFloor, target)
                end
            },
        }
        exports.ox_target:addGlobalPlayer(playerOptions)
    end
end)

function sendPlayer(currentFloor, target)
    local buildingName = nil

    for building, floors in pairs(Config.Elevators) do
        for _, floor in pairs(floors) do
            if floor.title == currentFloor.title then
                buildingName = building
                break
            end
        end
        if buildingName then break end
    end

    if not buildingName then
        print("Budynek nie znaleziony dla piętra: " .. currentFloor.title)
        return
    end

    local options = {}
    local building = Config.Elevators[buildingName]

    for floorIndex = 1, #building do
        local floor = building[floorIndex]
        if floor then 
            table.insert(options, {
                title = floor.title,
                description = floor.description,
                icon = floor.icon ~= "" and floor.icon or nil,
                onSelect = function()
                    local playerPed = PlayerPedId() 
                    local requiredJob = floor.job
                    if requiredJob ~= 'none' and not IsPlayerAllowedToAccess(requiredJob) then
                        lib.notify({
                            description = 'Nie masz uprawnień do wybrania tego piętra',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                    color = '#909296'
                                }
                            },
                            type = 'error'
                        })
                        return
                    end
                    if lib.progressBar({
                        duration = 2500,
                        label = 'Wysyłanie gracza [' .. target .. '] windą',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = 'mini@repair',
                            clip = 'fixing_a_ped'
                        },
                    }) 
                    then
                        lib.notify({
                            description = 'Wysłałeś gracza [' .. target .. '] na piętro ' .. floor.title,
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                color = '#909296'
                                }
                            },
                        })
                        TriggerServerEvent('mks:elevator:sendplayer', target, floor)
                    end
                end,
            })
        end
    end

    lib.registerContext({
        id = 'sendplayer_menu',
        title = buildingName,
        options = options,
    })

    lib.showContext('sendplayer_menu')
end