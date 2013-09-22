%By : Jason Loo
%Loo_Major Project
%Date Started: Ocotber 29, 2012
%Version 1.2
%Last edit: December 13, 2012

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note To Self
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Declaration of VARIABLES
var main : int := Window.Open ("graphics:1100;700,position:center;center,title:Loo_MajorProject,offscreenonly")
var endTime : real := 0
var x, y, z : int := 0
var numGems, gemRate : array 1 .. 7 of int
var startTime : array 1 .. 7 of real
var factoryUpgrade : array 1 .. 7, 1 .. 10 of boolean %10 is the upgrade level
var factoryCost : array 1 .. 7, 1 .. 10 of int
var font1 : int := Font.New ("Arial:25")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Window.SetActive (main)

function enoughMoney (upgradeGems, upgradeCost : int) : boolean
    if upgradeGems >= upgradeCost then
	result true
    else
	result false
    end if
end enoughMoney

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
			    numGems(i):=numGems(i)-factoryCost(i,j)
			else
			    Font.Draw ("FALSE", 800, 400, font1, black)
			end if
		    else
			if enoughMoney (numGems (i - 1), factoryCost (i, j)) then
			    factoryUpgrade (i, j) := true
			    Font.Draw ("TRUE", 800, 400, font1, black)
			    numGems(i-1):=numGems(i-1)-factoryCost(i,j)
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
end DrawUpgradeBoxes

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

    %Checks to see if true
    CurrentGemRates

    %Draw the upgrade boxes
    DrawUpgradeBoxes

    %Testing purposes
    Font.Draw (realstr (endTime / 1000, 0), 100, 100, font1, black)
    Font.Draw (realstr (startTime (1) / 1000, 0), 500, 100, font1, black)
    for i : 1 .. 7
	Font.Draw (intstr (numGems (i)), 0 + (100 * i), 650, font1, blue)
    end for
    View.Update
end loop
