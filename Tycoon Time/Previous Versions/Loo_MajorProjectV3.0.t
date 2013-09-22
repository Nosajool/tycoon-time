%By : Jason Loo
%Loo_Major Project
%Date Started: Ocotber 29, 2012
%Version 3.0
%Last edit: December 31, 2012

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
%Workers can be trained and upgraded

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note To Self
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Declaration of VARIABLES
var main : int := Window.Open ("graphics:1100;700,position:center;center,title:Loo_MajorProject,offscreenonly")
var endTime : real := 0
var x, y, z, choice, f1 : int := 0
var numGems, gemRate : array 1 .. 7 of int
var startTime : array 1 .. 7 of real
var factoryUpgrade : array 1 .. 7, 1 .. 10 of boolean %10 is the upgrade level
var factoryCost : array 1 .. 7, 1 .. 10 of int
var font1 : int := Font.New ("Arial:25")
var font2 : int := Font.New ("Arial:10")
var font3 : int := Font.New ("Arial:15")
var hireWorker : array 1 .. 3 of int
var hireWorkerStats : array 1 .. 3, 1 .. 4 of int
var workerStats : array 1 .. 5, 1 .. 4 of int
var workerPic : array 1 .. 5 of int


var currentApplicant, currentApplicantJob : int := 0
var currentApplicantStats : array 1 .. 4 of int
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

%%%%%%%%%%%%%%BackGround STUFF%%%%%%%%%%%%%%%%%%%%%55
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

procedure CurrentWorkers
    var x1, x2, y1, y2, amount : int
    x1 := 900
    y1 := 670
    x2 := 1000
    amount := 50
    Font.Draw ("Miner", x1, y1, font3, black)
    Font.Draw ("Manager", x1, y1 - amount, font3, black)
    Font.Draw ("Engineer", x1, y1 - 2 * amount, font3, black)
    Font.Draw ("Marketer", x1, y1 - 3 * amount, font3, black)
    Font.Draw ("Salesman", x1, y1 - 4 * amount, font3, black)
    for i : 1 .. 5
	Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (i)) + ".bmp", x2, y1 - amount * i + 25, picMerge)
    end for
end CurrentWorkers


%%%%%%%%%%%%%%SAVE GAME%
procedure SaveTheGame
    open : f1, "savefile", write
    for i : 1 .. 5
	write : f1, workerPic (i)
	for j : 1 .. 4
	    write : f1, workerStats (i, j)
	end for
    end for
    for i : 1 .. 7
	write : f1, numGems (i)
    end for
    close : f1
end SaveTheGame
procedure SaveGame
    var x1, x2, y1, y2 : int
    x1 := 700
    x2 := 890
    y1 := 5
    y2 := 40
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Save Game", x1 + 10, y1 + 5, font1, black)
	if z = 1 then
	    SaveTheGame
	    Font.Draw ("Game Saved", x1 + 20, y1 - 30, font3, black)
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	Font.Draw ("Save Game", x1 + 10, y1 + 5, font1, black)

    end if
end SaveGame

%%%%%%%%%%%%%%%%%%%%%%
procedure Background
    CurrentGemTotals
    CurrentWorkers
    BackToMenu
    SaveGame
end Background


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%HIRE WORKER STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure HireWorker
    workerPic (currentApplicantJob) := currentApplicant
    for m : 1 .. 4
	workerStats (currentApplicantJob, m) := currentApplicantStats (m)
    end for
end HireWorker

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%MENU STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




procedure MainMenu
    var x1, x2, y1, y2 : int

    %HIRE WORKERS
    x1 := 100
    x2 := 450

    y1 := 500
    y2 := 600
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Hire Workers", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 2
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("Hire Workers", x1 + 10, y1 + 30, font1, black)
    end if

    %VIEW FACTORY UPGRADES
    y1 := 350
    y2 := 450
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("View Factory Upgrades", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 1
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("View Factory Upgrades", x1 + 10, y1 + 30, font1, black)
    end if

    %VIEW WORKERS
    y1 := 200
    y2 := 300
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("View Workers", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 3
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("View Workers", x1 + 10, y1 + 30, font1, black)
    end if

    %Workshop
    y1 := 50
    y2 := 150
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("View Workshop", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 4
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("View Workshop", x1 + 10, y1 + 30, font1, black)
    end if
    %SECOND COLUMN

    x1 := 500
    x2 := 850

    %PLACEHOLDER 5
    y1 := 500
    y2 := 600
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Placeholder5", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 5
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("Placeholder5", x1 + 10, y1 + 30, font1, black)
    end if

    %Placeholder6
    y1 := 350
    y2 := 450
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Placeholder6", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 6
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("Placeholder6", x1 + 10, y1 + 30, font1, black)
    end if

    %Placeholder 7
    y1 := 200
    y2 := 300
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Placeholder 7", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 7
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("Placeholder 7", x1 + 10, y1 + 30, font1, black)
    end if

    %Placeholder 8
    y1 := 50
    y2 := 150
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Placeholder 8", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 8
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Font.Draw ("Placeholder 8", x1 + 10, y1 + 30, font1, black)
    end if


end MainMenu

procedure FactoryMenu
    %Draw the upgrade boxes
    DrawUpgradeBoxes
    %Checks to see if true
    CurrentGemRates
    Background
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
	for j : 1 .. 4
	    if hireWorkerStats (i, j) not= 0 then
		if x > i * 200 - 65 and x < i * 200 + 80 and y > 500 - 130 and y < 500 - 80 then
		    drawfillbox (i * 200 - 65, 500 - 130, i * 200 + 80, 500 - 80, black)
		    drawfillbox (i * 200 - 65 + 1, 500 - 130 + 1, i * 200 + 80 - 1, 500 - 80 - 1, yellow)
		    Font.Draw ("HIRE ME", i * 200 - 65 + 5, 500 - 120, font1, black)
		    if z = 1 then
			currentApplicant := hireWorker (i)
			currentApplicantJob := 0
			for m : 1 .. 4
			    currentApplicantStats (m) := hireWorkerStats (i, m)
			end for
		    end if
		else
		    drawfillbox (i * 200 - 65, 500 - 130, i * 200 + 80, 500 - 80, black)
		    drawfillbox (i * 200 - 65 + 1, 500 - 130 + 1, i * 200 + 80 - 1, 500 - 80 - 1, 82)
		    Font.Draw ("HIRE ME", i * 200 - 65 + 5, 500 - 120, font1, black)
		end if
	    end if
	end for
    end for
    %Current Applicant After you click hire
    if currentApplicant not= 0 then
	var x1, x2, y1, y2 : int
	x1 := 775
	x2 := x1 + 50
	y1 := 300
	y2 := y1 + 50
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	Pic.ScreenLoad ("pics/workers/" + intstr (currentApplicant) + ".bmp", x1, y1, picMerge)

	x1 := 890
	x2 := 980
	y1 := 110
	y2 := 150
	%Confirm button
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	    Font.Draw ("Confirm", x1 + 10, y1 + 10, font3, black)
	    if z = 1 then
		if currentApplicantJob = 0 then
		    Font.Draw ("Please select a job title", x1, y1 - 30, font3, black)
		else
		    HireWorker
		    currentApplicantJob := 0
		    currentApplicant := 0
		end if
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	    Font.Draw ("Confirm", x1 + 10, y1 + 10, font3, black)
	end if
	%Cancel Button
	x1 := 1000
	x2 := 1090
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	    Font.Draw ("Cancel", x1 + 10, y1 + 10, font3, black)
	    if z = 1 then
		currentApplicant := 0
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	    Font.Draw ("Cancel", x1 + 10, y1 + 10, font3, black)
	end if
	x1 := 730
	y1 := 280
	Font.Draw ("Intelligence: ", x1, y1 - 15, font2, black)
	Font.Draw ("Strength: ", x1, y1 - 30, font2, black)
	Font.Draw ("Stamina: ", x1, y1 - 45, font2, black)
	Font.Draw ("Luck: ", x1, y1 - 60, font2, black)
	x1 := 850
	for i : 1 .. 4
	    Font.Draw (intstr (currentApplicantStats (i)), x1, y1 - 15 * i, font2, black)
	end for
	x1 := 930
	y1 := 320
	Font.Draw ("Job Title", x1, y1, font1, black)
	x1 := 900
	x2 := 1070


	%Miner
	y1 := 280
	y2 := 305
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	    if z = 1 then
		currentApplicantJob := 1
	    end if
	end if
	if currentApplicantJob = 1 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	end if
	Font.Draw ("Miner", x1 + 5, y1 + 5, font3, black)

	%Manager
	y1 := 250
	y2 := 275
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	    if z = 1 then
		currentApplicantJob := 2
	    end if
	end if
	if currentApplicantJob = 2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	end if
	Font.Draw ("Manager", x1 + 5, y1 + 5, font3, black)

	%Engineer
	y1 := 220
	y2 := 245
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	    if z = 1 then
		currentApplicantJob := 3
	    end if
	end if
	if currentApplicantJob = 3 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	end if
	Font.Draw ("Engineer", x1 + 5, y1 + 5, font3, black)

	%Marketer
	y1 := 190
	y2 := 215
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	    if z = 1 then
		currentApplicantJob := 4
	    end if
	end if
	if currentApplicantJob = 4 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	end if
	Font.Draw ("Marketer", x1 + 5, y1 + 5, font3, black)

	%Salesman
	y1 := 160
	y2 := 185
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	    if z = 1 then
		currentApplicantJob := 5
	    end if
	end if
	if currentApplicantJob = 5 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	end if
	Font.Draw ("Salesman", x1 + 5, y1 + 5, font3, black)

    end if
    Background

    View.Update
end HireWorkerMenu

procedure ViewWorkerMenu
    var x1, x2, y1, y2, amount : int
    x1 := -100
    y1 := 550
    amount := 150
    Font.Draw ("Miner", x1 + 1 * amount, y1, font1, black)
    Font.Draw ("Manager", x1 + 2 * amount, y1, font1, black)
    Font.Draw ("Engineer", x1 + 3 * amount, y1, font1, black)
    Font.Draw ("Marketer", x1 + 4 * amount, y1, font1, black)
    Font.Draw ("Salesman", x1 + 5 * amount, y1, font1, black)
    for i : 1 .. 6
	drawline (x1 + i * amount - 5, 0, x1 + i * amount - 5, maxy - 100, black)
    end for
    drawline (x1 + amount - 5, maxy - 100, x1 + 6 * amount - 5, maxy - 100, black)
    x1 := 100
    y1 := 475
    for i : 1 .. 5
	Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (i)) + ".bmp", x1 + i * amount - amount, y1, picMerge)
	for j : 1 .. 4
	    Font.Draw ("Intelligence: ", x1 + i * amount - amount - 50, y1 - 15, font2, black)
	    Font.Draw ("Strength: ", x1 + i * amount - amount - 50, y1 - 30, font2, black)
	    Font.Draw ("Stamina: ", x1 + i * amount - amount - 50, y1 - 45, font2, black)
	    Font.Draw ("Luck: ", x1 + i * amount - amount - 50, y1 - 60, font2, black)
	    Font.Draw (intstr (workerStats (i, j)), x1 + i * amount - amount + 70, y1 - 15 * j, font2, black)
	end for
    end for
    Background
    View.Update
end ViewWorkerMenu

procedure WorkshopMenu
    Background
    View.Update
end WorkshopMenu

%CODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var selection:int
loop
    mousewhere (x, y, z)
    var x1, x2, y1, y2 : int
    selection := 0
    x1 := 200
    x2 := 400

    y1 := 200
    y2 := 300
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Load Game", x1 + 5, y1 + 5, font1, black)
	if z = 1 then
	    selection := 2
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	Font.Draw ("Load Game", x1 + 5, y1 + 5, font1, black)
    end if
    y1 := 400
    y2 := 500
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("New Game", x1 + 5, y1 + 5, font1, black)
	if z = 1 then
	    selection := 1
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	Font.Draw ("New Game", x1 + 5, y1 + 5, font1, black)
    end if
    View.Update
    exit when selection not= 0
end loop

%%%%%%%%%%%%%%NEW GAME
if selection = 1 then
    ResetFactoryUpgrades
    ResetStartGems
    for i : 1 .. 3
	hireWorker (i) := 0
	for j : 1 .. 4
	    hireWorkerStats (i, j) := 0
	end for
    end for


    for i : 1 .. 5
	workerPic (i) := 0
	for j : 1 .. 4
	    workerStats (i, j) := 0
	end for
    end for
end if

if selection=2 then

end if


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
    elsif choice = 3 then
	ViewWorkerMenu
    elsif choice = 4 then
	WorkshopMenu
    end if
    Background
    View.Update
end loop
