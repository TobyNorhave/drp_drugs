DRPDrugs = {}
----------------------------------------------------------------------------------------------------------------------------------
----- NEEDS TO BE HERE!!
----------------------------------------------------------------------------------------------------------------------------------
DRPDrugs.Locations = {} -- DON'T TOUCH
DRPDrugs.Productions = {} -- DON'T TOUCH
DRPDrugs.SellLocations = {} -- DON'T TOUCH

----------------------------------------------------------------------------------------------------------------------------------
----- Set the values as you like.
----------------------------------------------------------------------------------------------------------------------------------
DRPDrugs.AmountYouGet = 1 -- This is the amount you get when you pick/produce the drug.
DRPDrugs.AmountToProduceOne = 2 -- This is the amount it takes to produce one drug.
DRPDrugs.TimeToPickProduceSell = 2500 -- This is the time it takes to Pick, Produce, And sell in msec.

----------------------------------------------------------------------------------------------------------------------------------
----- Set drug locations. Remember to set blips accordingly in `client.lua`. And add item to Inventory!!
----------------------------------------------------------------------------------------------------------------------------------
DRPDrugs.Locations = { -- { x= , y= , z= , type= "TYPE_OF_DRUG"} 
    {x=363.41296386718, y=6483.2626953125, z=29.18021774292, type = "Cokeleaf"},
    {x=363.45565795898, y=6481.7270507812, z=29.317653656006, type = "Cokeleaf"},
    {x=363.45098876954, y=6480.03515625, z=29.46580696106, type = "Cokeleaf"},
    {x=363.58731079102, y=6478.5180664062, z=29.609004974366, type = "Cokeleaf"},
    {x=364.00079345704, y=6477.322265625, z=29.772424697876, type = "Cokeleaf"},
    {x=363.79132080078, y=6475.7475585938, z=30.022640228272, type = "Cokeleaf"},

    {x=356.82869262695, y=6476.0708007813, z=29.729650497437, type = "Cokeleaf"},
    {x=357.08402709961, y=6483.562109375, z=29.795503616333, type = "Cokeleaf"},
    {x=357.08298950195, y=6482.2177734375, z=29.625259399414, type = "Cokeleaf"},
    {x=356.98886108398, y=6480.2297851563, z=29.7177318573, type = "Cokeleaf"},
    {x=357.07041625977, y=6477.6000976563, z=29.625217437744, type = "Cokeleaf"},
    {x=357.06697387695, y=6478.7061523438, z=29.54514503479, type = "Cokeleaf"}
}

----------------------------------------------------------------------------------------------------------------------------------
----- Set production sites. Remember to set blips accordingly in `client.lua`.
----------------------------------------------------------------------------------------------------------------------------------
DRPDrugs.Productions = { -- { x= , y= , z= , type= "TYPEOFDRUG", use= "USED_TO_PRODUCE_DRUG"}
    {x = 1391.89, y =3605.6, z =38.94, type = "Coke", use = "Cokeleaf"}
}

----------------------------------------------------------------------------------------------------------------------------------
----- Set peds for drug dealing. Remember to set blips accordingly in `client.lua`. (If you will)
----------------------------------------------------------------------------------------------------------------------------------
DRPDrugs.SellLocations = { -- { x= , y= , z= , type= "TYPEOFDRUG", price = PRICE_PR_DRUG}
    {x =-1645.5, y =-986.61, z = 7.33, type = "Coke", price = 120},
    -- h = 4.18, model= "a_m_m_og_boss_01", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01",
    --{ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", type = "Coke", price = 120, coords={-1645.63,-971.08,7.69,3.45}}
}