Config = {}
Config.DebugZone = false

Config.Time = 6 -- Czas jazdy windą w sekundach
Config.FloorList = "ContextMenu" -- "ContextMenu" / "Target"

Config.Elevators = {
    ["FBI MIASTO"] = {
        [1] = {
            coords = vec3(144.0261, -688.8868, 33.1282),
            heading = 253.0055,
            size = vector3(2.7, 2.5, 2.5),
            title = 'Garaż',
            description = 'Garaż, czego chcesz więcej lol1',
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [2] = {
            coords = vec3(136.4803, -760.8372, 45.7520),
            heading = 160.4754,
            size = vector3(2.7, 4.2, 2.5),
            title = 'Parter',
            description = 'Recepcja i ten no własnie',
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [3] = {
            coords = vec3(136.4199, -760.9966, 242.1519),
            heading = 159.5535,
            size = vector3(2.7, 4.2, 2.5),
            title = 'Piętro 49',
            description = 'Piętro lorowe z biurami i takim śmiesznym securityroom', 
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [4] = {
            coords = vec3(154.8781, -756.5134, 258.1512),
            heading = 162.9674,
            size = vector3(2.7, 2.5, 2.5),
            title = 'Piętro 52',
            description = 'Hall z biurami i konferencyjnym', 
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [5] = {
            coords = vec3(131.7390, -750.9234, 271.0681),
            heading = 246.2194,
            size = vector3(2.7, 2.5, 2.5),
            title = 'Piętro 57',
            description = 'Biura, drukareczka (nie działająca) i szatnia', 
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [6] = {
            coords = vec3(153.8916, -755.1053, 277.8846),
            heading = 76.4795,
            size = vector3(2.7, 2.5, 2.5),
            title = 'Piętro 62',
            description = 'Zbrojownia, dowody, cwele i przesłuchaniówki', 
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [7] = {
            coords = vec3(143.7448, -735.9039, 283.7675),
            heading = 254.2840,
            size = vector3(2.7, 2.5, 2.5),
            title = 'Piętro 69',
            description = 'Biuro GEN-S-INSP Conndoma Harrinsona, dispatchroom, konferencyjny', 
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
        [8] = {
            coords = vec3(130.1694, -747.2864, 287.9232),
            heading = 252.2927,
            size = vector3(2.7, 4.2, 2.5),
            title = 'Dach',
            description = 'Helipad, miejsce dla samobójców', 
            icon = '',
            job = { 'police', 'fbi', 'bcso', 'lssd' },
        },
    },
    ["PillBox"] = {
        [1] = {
            coords = vec3(332.4044, -595.7250, 43.2841),
            heading = 74.8333,
            size = vector3(2.0, 2.0, 2.0),
            title = 'Parter 1',
            description = 'Garaż, czego chcesz więcej lol1', 
            icon = 'check',
            job = 'none',
        },
        [2] = {
            coords = vec3(327.1483, -603.8960, 43.2841),
            heading = 333.5215,
            size = vector3(2.0, 2.0, 2.0),
            title = 'Parter 2',
            description = 'Garaż, czego chcesz więcej lol2', 
            icon = 'check',
            job = 'none',
        },
    },
}
