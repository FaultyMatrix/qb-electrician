Config = Config or {}

Config.ShowBlip = true -- Sets whether the blip shows up for the Job Location or not

Config.JobPrice = math.random(240, 290) -- Amount made per job completed. Note: This isn't the final amount as there is scripted bonuses for payments as well.

Config.PaymentTax = 15 -- Amount taken away from players as Tax (as a percentage - Default - 15%)

Config.Locations = {
    ["job"] = {
        label = "Electrician Job",
        coords = vector4(931.99, -1807.77, 30.71, 265.65),
    },
    ["vehicle"] = {
        label = "Work Vehicles",
        coords = vector4(935.39, -1793.54, 30.7, 266.25),        
    },
    ["payslip"] = {
        label = "Payslip",
        coords = vector4(930.3, -1807.6, 31.38, 81.81),
    },
    ["jobset1"] = {
        [1] = {
            name = "Job Site 1",
            coords = vector4(379.74, -908.3, 29.42, 181.92),
        },
        [2] = {
            name = "Job Site 2",
            coords = vector4(622.8, -418.54, 24.7, 86.59),
        },
        [3] = {
            name = "Job Site 3",
            coords = vector4(320.33, -316.04, 51.13, 71.02),
        },
        [4] = {
            name = "Job Site 4",
            coords = vector4(393.24, -225.1, 56.18, 241.93),
        },
        [5] = {
            name = "Job Site 5",
            coords = vector4(551.22, -153.35, 57.04, 92.58),
        },
    },
    ["jobset2"] = {
        [1] = {
            name = "Job Site 1",
            coords = vector4(903.02, -166.91, 74.08, 58.21),
        },
        [2] = {
            name = "Job Site 2",
            coords = vector4(979.83, -235.15, 69.14, 113.1),
        },
        [3] = {
            name = "Job Site 3",
            coords = vector4(1148.2, -310.51, 69.03, 10.55),
        },
        [4] = {
            name = "Job Site 4",
            coords = vector4(1142.24, -795.23, 57.59, 264.28),
        },
        [5] = {
            name = "Job Site 5",
            coords = vector4(33.36, -726.57, 31.64, 75.64),
        },
    },
    ["jobset3"] = {
        [1] = {
            name = "Job Site 1",
            coords = vector4(-35.75, -722.49, 33.0, 346.1),
        },
        [2] = {
            name = "Job Site 2",
            coords = vector4(-356.72, -641.5, 31.81, 0.96),
        },
        [3] = {
            name = "Job Site 3",
            coords = vector4(-992.1, -716.33, 21.66, 92.2),
        },
        [4] = {
            name = "Job Site 4",
            coords = vector4(-1367.31, -649.59, 28.6, 312.46),
        },
        [5] = {
            name = "Job Site 5",
            coords = vector4(-1462.46, -684.64, 26.47, 140.51),
        },
    },
    ["jobset4"] = {
        [1] = {
            name = "Job Site 1",
            coords = vector4(-1533.93, -692.02, 28.79, 231.33),
        },
        [2] = {
            name = "Job Site 2",
            coords = vector4(-1586.83, -924.87, 9.55, 231.95),
        },
        [3] = {
            name = "Job Site 3",
            coords = vector4(-1328.54, -1136.79, 4.32, 95.64),
        },
        [4] = {
            name = "Job Site 4",
            coords = vector4(-1324.6, -1255.69, 4.61, 112.56),
        },
        [5] = {
            name = "Job Site 5",
            coords = vector4(-1148.85, -1380.75, 5.08, 121.18),
        },
    },
    ["jobset5"] = {
        [1] = {
            name = "Job Site 1",
            coords = vector4(-973.92, -1562.85, 5.04, 201.55),
        },
        [2] = {
            name = "Job Site 2",
            coords = vector4(-417.61, 185.68, 80.77, 0.26),
        },
        [3] = {
            name = "Job Site 3",
            coords = vector4(-423.81, 285.86, 83.23, 86.28),
        },
        [4] = {
            name = "Job Site 4",
            coords = vector4(-621.25, 323.54, 82.26, 83.19),
        },
        [5] = {
            name = "Job Site 5",
            coords = vector4(-941.21, 321.92, 71.35, 95.0),
        },
    }
}

Config.JobVehicles = {
    [1] = 'bison3',
    [2] = "burrito",
}