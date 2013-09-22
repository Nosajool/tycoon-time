%By : Jason Loo
%Loo_Major Project
%Date Started: Ocotber 29, 2012
%Version 2.2
%Last edit: December 20, 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%.____                        _____              __               __________                   __               __
%|    |    ____   ____       /     \ _____      |__| ___________  \______   \_______  ____    |__| ____   _____/  |_
%|    |   /  _ \ /  _ \     /  \ /  \\__  \     |  |/  _ \_  __ \  |     ___/\_  __ \/  _ \   |  |/ __ \_/ ___\   __\
%|    |__(  <_> |  <_> )   /    Y    \/ __ \_   |  (  <_> )  | \/  |    |     |  | \(  <_> )  |  \  ___/\  \___|  |
%|_______ \____/ \____/____\____|__  (____  /\__|  |\____/|__|     |____|     |__|   \____/\__|  |\___  >\___  >__|
%        \/          /_____/       \/     \/\______|                                      \______|    \/     \/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Introduction

%Welcome to my Major Project.
%This will be similar to my random program but
%it won't be random. However, there will be automatic
%cash in. With 7 different kinds of cash (the types of gems)
%Advertising
%Hire Workers
%View Factory Upgrades
%Sell Stuff
%Inflation after x amount of time
%different worker roles
%higher exectutives
%economics 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note To Self
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Declaration of VARIABLES
var main : int := Window.Open ("graphics:1100;700,position:center;center,title:Loo_MajorProject,offscreenonly")
var endTime : real := 0
var x, y, z, choice : int := 0
var numGems, gemRate : array 1 .. 7 of int
var startTime : array 1 .. 7 of real
var factoryUpgrade : array 1 .. 7, 1 .. 10 of boolean %10 is the upgrade level
var factoryCost : array 1 .. 7, 1 .. 10 of int
var font1 : int := Font.New ("Arial:25")
var font2 : int := Font.New ("Arial:10")
var hireWorker : array 1 .. 3 of int
var hireWorkerStats : array 1 .. 3, 1 .. 4 of int
for i : 1 .. 3
    hireWorker (i) := 0
    for j : 1 .. 4
	hireWorkerStats (i, j) := 0
    end for
end for
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Window.SetActive (main)

function enoughMoney (upgradeGems, upgradeCost : int) : boolean
    if upgradeGems >= upgradeCost then
	result true
    else
	result false
    end if
end enoughMoney
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%Functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure BackToMenu
    if x > maxx - 100 and x < maxx and y > 0 and y < 50 then
	drawfillbox (maxx - 100, 0, maxx, 50, black)
	drawfillbox (maxx - 100 + 1, 0 + 1, maxx - 1, 50 - 1, yellow)
	Font.Draw ("Menu", maxx - 95, 10, font1, black)
	if z = 1 then
	    choice := 0
	end if
    else
	drawfillbox (maxx - 100, 0, maxx, 50, black)
	drawfillbox (maxx - 100 + 1, 0 + 1, maxx - 1, 50 - 1, brightred)
	Font.Draw ("Menu", maxx - 95, 10, font1, black)
    end if
end BackToMenu

procedure DrawUpgradeBoxes
    for i : 1 .. 7
	for j : 1 .. 10
	    var boxx : int := 8 + (100 * i)
	    var boxy : int := 200 + (j * 40)
	    var boxh : int := 30
	    if x > boxx and x < boxx + boxh and y > boxy and y < boxy + boxh and factoryUpgrade (i, j) = false then
		drawfillbox (boxx, boxy, boxx + boxh, boxy + boxh, black)
		drawfillbox (boxx + 1, boxy + 1, boxx + boxh - 1, boxy + boxh - 1, yellow)
		if z = 1 then
		    if i = 1 then
			if enoughMoney (numGems (i), factoryCost (i, j)) then
			    factoryUpgrade (i, j) := true
			    Font.Draw ("TRUE", 800, 400, font1, black)
			    numGems (i) := numGems (i) - factoryCost (i, j)
			else
			    Font.Draw ("FALSE", 800, 400, font1, black)
			end if
		    else
			if enoughMoney (numGems (i - 1), factoryCost (i, j)) then
			    factoryUpgrade (i, j) := true
			    Font.Draw ("TRUE", 800, 400, font1, black)
			    numGems (i - 1) := numGems (i - 1) - factoryCost (i, j)
			else
			    Font.Draw ("FALSE", 800, 400, font1, black)
			end if
		    end if
		end if
	    else
		if factoryUpgrade (i, j) = true then
		    drawfillbox (boxx, boxy, boxx + boxh, boxy + boxh, black)
		    drawfillbox (boxx + 1, boxy + 1, boxx + boxh - 1, boxy + boxh - 1, brightgreen)
		else
		    drawfillbox (boxx, boxy, boxx + boxh, boxy + boxh, black)
		end if
	    end if

	    %drawfillbox (8 + (100 * i), 200 + (j * 20), 8 + (100 * i) + 10, 200 + (j * 20) + 10, black)
	end for
    end for
    %Testing purposes
    Font.Draw (realstr (endTime / 1000, 0), 100, 100, font1, black)
    Font.Draw (realstr (startTime (1) / 1000, 0), 500, 100, font1, black)

end DrawUpgradeBoxes

%%%%%%%%%%%%%%BackGroundGem STUFF%%%%%%%%%%%%%%%%%%%%%55
procedure GemTimers
    for i : 1 .. 7
	%Check to see if current time minus starttime is greater than gem rate
	if endTime - startTime (i) > gemRate (i) then
	    startTime (i) := Time.Elapsed
	    %If so, +=1
	    numGems (i) += 1
	end if
    end for
end GemTimers

procedure CurrentGemRates
    for i : 1 .. 7
	if gemRate (i) > 1000000 then
	    Font.Draw ("N/A", 0 + (100 * i), 165, font1, red)
	else
	    Font.Draw (intstr (round ((gemRate (i)))), 0 + (100 * i), 165, font1, red)
	end if
    end for
end CurrentGemRates

procedure FactoryCosts
    for i : 1 .. 7
	for j : 1 .. 10
	    factoryCost (i, j) := 2 ** j
	end for
    end for
end FactoryCosts


procedure CheckGemRate
    for i : 1 .. 7
	for j : 1 .. 10
	    if factoryUpgrade (i, j) = true then
		gemRate (i) := round (3000 / j)
	    end if
	end for
    end for
end CheckGemRate


procedure ResetFactoryUpgrades
    %Set all Factory upgrades to false
    for i : 1 .. 7
	for j : 1 .. 10
	    factoryUpgrade (i, j) := false
	end for
    end for
    factoryUpgrade (1, 1) := true

end ResetFactoryUpgrades

procedure ResetStartGems
    %Set starting number of gems to 0.
    for i : 1 .. 7
	numGems (i) := 0
	gemRate (i) := 999999999
	startTime (i) := Time.Elapsed
    end for
end ResetStartGems

procedure CurrentGemTotals
    GemTimers
    CheckGemRate
    for i : 1 .. 7
	Font.Draw (intstr (numGems (i)), 0 + (100 * i), 650, font1, blue)
    end for
end CurrentGemTotals


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%MENU STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




procedure MainMenu
    if x > 100 and x < 450 and y > 400 and y < 500 then
	drawfillbox (100, 400, 450, 500, black)
	drawfillbox (100 + 1, 400 + 1, 450 - 1, 500 - 1, yellow)
	Font.Draw ("Hire Workers", 110, 430, font1, black)
	if z = 1 then
	    choice := 2
	end if
    else
	drawfillbox (100, 200, 450, 300, black)
	drawfillbox (100 + 1, 400 + 1, 450 - 1, 500 - 1, brightblue)
	Font.Draw ("Hire Workers", 110, 430, font1, black)
    end if
    if x > 100 and x < 450 and y > 200 and y < 300 then
	drawfillbox (100, 200, 450, 300, black)
	drawfillbox (100 + 1, 200 + 1, 450 - 1, 300 - 1, yellow)
	Font.Draw ("View Factory Upgrades", 110, 230, font1, black)
	if z = 1 then
	    choice := 1
	end if
    else
	drawfillbox (100, 200, 450, 300, black)
	drawfillbox (100 + 1, 200 + 1, 450 - 1, 300 - 1, brightblue)
	Font.Draw ("View Factory Upgrades", 110, 230, font1, black)
    end if
end MainMenu

procedure FactoryMenu
    %Draw the upgrade boxes
    DrawUpgradeBoxes
    %Checks to see if true
    CurrentGemRates
    CurrentGemTotals
    BackToMenu
end FactoryMenu

procedure HireWorkerMenu
    if x > 250 and x < 650 and y > 150 and y < 300 then
	drawfillbox (250, 150, 650, 300, black)
	drawfillbox (250 + 1, 150 + 1, 650 - 1, 300 - 1, yellow)
	Font.Draw ("View Applications", 275, 200, font1, black)
	if z = 1 then
	    delay (250)
	    for i : 1 .. 3
		hireWorker (i) := Rand.Int (1, 60)
		for j : 1 .. 4
		    hireWorkerStats (i, j) := Rand.Int (1, 100)
		end for
	    end for
	end if
    else
	drawfillbox (250, 150, 650, 300, black)
	drawfillbox (250 + 1, 150 + 1, 650 - 1, 300 - 1, 77)
	Font.Draw ("View Applications", 275, 200, font1, black)
    end if
    for i : 1 .. 3
	if hireWorker (i) not= 0 then
	    Pic.ScreenLoad ("pics/workers/" + intstr (hireWorker (i)) + ".bmp", i * 200, 500, picMerge)
	end if
	for j : 1 .. 4
	    if hireWorkerStats (i, j) not= 0 then
		Font.Draw ("Intelligence: ", i * 200 - 60, 500 - 20, font2, black)
		Font.Draw ("Strength: ", i * 200 - 60, 500 - 35, font2, black)
		Font.Draw ("Stamina: ", i * 200 - 60, 500 - 50, font2, black)
		Font.Draw ("Luck: ", i * 200 - 60, 500 - 65, font2, black)
		%Font.Draw ("Overall: ", i * 200 - 60, 500 - 65, font2, black)
		Font.Draw (intstr (hireWorkerStats (i, j)), i * 200 + 50, 500 - 5 - 15 * j, font2, black)
	    end if
	end for
	if x > i * 200 - 65 and x < i * 200 + 80 and y > 500 - 130 and y < 500 - 80 then
	    drawfillbox (i * 200 - 65, 500 - 130, i * 200 + 80, 500 - 80, black)
	    drawfillbox (i * 200 - 65 + 1, 500 - 130 + 1, i * 200 + 80 - 1, 500 - 80 - 1, yellow)
	    Font.Draw ("HIRE ME", i * 200 - 65 + 5, 500 - 120, font1, black)
	else
	    drawfillbox (i * 200 - 65, 500 - 130, i * 200 + 80, 500 - 80, black)
	    drawfillbox (i * 200 - 65 + 1, 500 - 130 + 1, i * 200 + 80 - 1, 500 - 80 - 1, 82)
	    Font.Draw ("HIRE ME", i * 200 - 65 + 5, 500 - 120, font1, black)
	end if
    end for
    CurrentGemTotals
    BackToMenu
    View.Update
end HireWorkerMenu

%CODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ResetFactoryUpgrades
ResetStartGems
FactoryCosts

loop
    cls
    %Current Time
    endTime := Time.Elapsed

    %mousewhere
    mousewhere (x, y, z)

    %Check timers for gems
    GemTimers

    %Gem Rate stuff
    CheckGemRate


    %Menus
    if choice = 0 then
	MainMenu
    elsif choice = 1 then
	FactoryMenu
    elsif choice = 2 then
	HireWorkerMenu
    end if
    CurrentGemTotals
    View.Update
end loop
