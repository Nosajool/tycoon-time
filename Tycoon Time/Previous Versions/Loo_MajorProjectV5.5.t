%By : Jason Loo
%Loo_Major Project
%Date Started: Ocotber 29, 2012
%Version 5.5
%Last edit: January 23, 2013

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
%However, there will be automatic
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

%Version 1.0---Basic Timer
%Version 1.1--- Factory Grid
%Version 1.2---Factory Grid shrunk to 10 from 20 Highlighting done

%Version 2.0---Basic menu done, factory upgrades actually work
%Version 2.1---Hire Worker format done and randomizing workers
%Version 2.2---Looks basically the same but has the menu in corner
%Version 2.3---Hire Worker has current applicant


%Version 3.0---Hire Worker works and you can now have a squad of 5 workers
%Version 3.1----New Game and Load Game is done with working save files
%Version 3.2----All gem pictures are working. Somewhat laggy once everything is upgraded
%Version 3.3----Workshop takes recipes from textfile to make costs, Learned from DWITE contest
%Version 3.4----Fixed Workshop bugs. Added arrows and quantity boxes. Added some item pics.
%Version 3.5----Fixed workshop arrow keys and allowed quantity of items to be changed.
%Version 3.6----Build and Sell Half Works
%Version 3.7----Last item with sell cost, time it takes etc... may change this later

%Version 4.0----GLITCHY!!!!!!!Save file was created because of "fatal error"
%Version 4.1----Added the visual component of last item created
%Version 4.2----Lag Issue fixed by only displaying latest upgrade for the gem towers. Fixed Queue to work. Started Menu pictures
%Version 4.3----Finished menu pictures. Recipes Thanh OP.
%Version 4.4----All Workshop icons done, Added saving the queues, fixed queue, adding company name
%Version 4.5----Fixed Insert company name still need to incorporate backspace
%Version 4.6----Adding Company Name fnially done with the back space button, Cheat Mode Activate. Sorta got store timers to work not sure. PUT TOTAL MONEY IN BACKGROUND AND VISUALIZE THE STORE TIMERS
%Version 5.0----Store Timers are done. F U ALEX WEN FOR Hitting power button
%Version 5.1----Miner,Upgrade workers are now affected by stats.
%Version 5.2----Engineer is done, added font 4. Item Queue completely done, worker and training now costs money, Dashboard
%Version 5.3----Advertising is Done and Working Marketer now affects this
%Version 5.4----High Scores Added and functioning, winning the game now works
%Version 5.5----

% PLAN FOR HOME!!!!!! Salesman

%Still need to do. Advertising powerpoint thing, Placeholder 7 and 8? One will be end game and view high scores. Title and Ending Screen
%instructions
%Sounds!!!!!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note To Self
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Declaration of VARIABLES
var main : int := Window.Open ("graphics:1100;700,position:center;center,title:Loo_MajorProject,offscreenonly")
var endTime : real := 0
var x, y, z, choice, f1, quitgame : int := 0
var numGems, gemRate : array 1 .. 7 of int
var startTime : array 1 .. 7 of real
for i : 1 .. 7
    startTime (i) := Time.Elapsed
end for
var factoryUpgrade : array 1 .. 7, 1 .. 10 of boolean %10 is the upgrade level
var factoryCost : array 1 .. 7, 1 .. 10 of int
var font1 : int := Font.New ("Arial:25")
var font2 : int := Font.New ("Arial:10")
var font3 : int := Font.New ("Arial:15")
var font4 : int := Font.New ("Arial:20")
var hireWorker : array 1 .. 3 of int
var hireWorkerStats : array 1 .. 3, 1 .. 4 of int
var workerStats : array 1 .. 5, 1 .. 4 of int
var workerPic : array 1 .. 5 of int
var companyName : string := ""
var money : int := 0
var storeMultiplier : real := 1

var win : boolean := false
var winningTimeStart : real := Time.Elapsed
var winningTime : real

const startMoney : int := 250
const goal : int := 7500
for i : 1 .. 3
    hireWorker (i) := 0
    for j : 1 .. 4
	hireWorkerStats (i, j) := 0
    end for
end for


var currentApplicant, currentApplicantJob : int := 0
var currentApplicantStats : array 1 .. 4 of int


%Recipes Materials

var recipePage : int := 1
var FileInput : string := "recipes1.txt"
var file : int
const numRecipes : int := 5 %Change this whenever you add a new recipe
var quantity : array 1 .. numRecipes of int
for i : 1 .. numRecipes
    quantity (i) := 1
end for
var workShop : array 1 .. 7 of boolean
var maxPages : int := 3 %Change this to change number of recipe pages


%Store Variables
type store :
    record
	name : string
	sell : int
	timer : real
	quantity : int
	%queue : int
    end record



const maxqueue : int := 20 %Change the "5" to whatever the maximum queue is
var sitem : array 1 .. maxqueue of store
for i : 1 .. maxqueue
    sitem (i).name := ""
    sitem (i).sell := 0
    sitem (i).timer := 0
    sitem (i).quantity := 0
end for
var startStoreTimer : array 1 .. 5 of real
for i : 1 .. 5
    startStoreTimer (i) := 0
end for


var lastsitem : store
lastsitem.name := ""




type scoreData :
    record
	companyName : string
	score : real
    end record
var score : array 1 .. 11 of scoreData



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Window.SetActive (main)

function enoughMoney (upgradeGems, upgradeCost : int) : boolean
    if upgradeGems >= upgradeCost then
	result true
    else
	result false
    end if
end enoughMoney

function ptinrect (h, v, x1, v1, x2, v2 : int) : boolean
    result (h > x1) and (h < x2) and (v > v1) and (v < v2)
end ptinrect
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%Functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%PREGAME%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%COMPANY NAME
var letterValue : int := 65
procedure ChooseCompanyName
    cls
    var x1, x2, y1, y2, m1, m2, n1, n2, j1, j2, k1, k2, c1, d1 : int

    %Left
    x1 := 600
    x2 := x1 + 50
    y1 := 300
    y2 := y1 + 50
    drawfillbox (x1, y1, x2, y2, brightblue)
    drawbox (x1, y1, x2, y2, black)

    %Right
    m1 := x1 + 200
    m2 := m1 + 50
    n1 := y1
    n2 := y2
    drawfillbox (m1, n1, m2, n2, brightblue)
    drawbox (m1, n1, m2, n2, black)

    %Select
    j1 := m1 - 100
    j2 := m1 - 50
    k1 := y1 - 100
    k2 := y1 - 50
    drawfillbox (j1, k1, j2, k2, brightgreen)
    drawbox (j1, k1, j2, k2, black)


    %Accept Box
    var o1, o2, p1, p2 : int
    o1 := 900
    o2 := o1 + 150
    p1 := 200
    p2 := p1 + 50
    drawfillbox (o1, p1, o2, p2, brightred)
    drawbox (o1, p1, o2, p2, black)
    Font.Draw ("Accept Name", o1 + 18, p1 + 20, font3, black)

    %Delete
    var g1, g2, h1, h2 : int
    g1 := 400
    g2 := g1 + 150
    h1 := 200
    h2 := h1 + 50
    drawfillbox (g1, h1, g2, h2, brightred)
    drawbox (g1, h1, g2, h2, black)
    Font.Draw ("Delete Letter", g1 + 18, h1 + 20, font3, black)

    %Company Name

    Font.Draw (chr (letterValue), j1 + 10, k2 + 60, font1, blue) %initial letter
    View.Update

    Font.Draw ("Please enter the name of your company", 200, 400, font1, black)
    var doneName : boolean := false
    var tempName : array 1 .. 100 of int
    for i : 1 .. 100
	tempName (i) := 0
    end for
    var letterCounter : int := 1
    var spacing : int := 25
    loop
	buttonwait ("down", x, y, z, z)
	if ptinrect (x, y, x1, y1, x2, y2) and letterValue > 65 then
	    letterValue -= 1
	    drawfillbox (j1, k1 + 53, j2, k2 + 100, white)
	    Font.Draw (chr (letterValue), j1 + 10, k2 + 60, font1, blue)  %initial letter
	end if
	if ptinrect (x, y, m1, n1, m2, n2) and letterValue < 90 then
	    letterValue += 1
	    drawfillbox (j1, k1 + 53, j2, k2 + 100, white)
	    Font.Draw (chr (letterValue), j1 + 10, k2 + 60, font1, blue)  %initial letter
	end if
	%Pick Letter
	if ptinrect (x, y, j1, k1, j2, k2) then
	    tempName (letterCounter) := letterValue
	    letterCounter += 1
	    c1 := 100
	    d1 := 600
	    for i : 1 .. 100
		if tempName (i) not= 0 then
		    Font.Draw (chr (tempName (i)), c1 + spacing * i, d1, font1, blue)
		end if
	    end for
	end if
	%BackSpace
	if ptinrect (x, y, g1, h1, g2, h2) and letterCounter > 1 then
	    letterCounter -= 1
	    tempName (letterCounter) := 0

	    drawfillbox (c1, d1, c1 + 500, d1 + 100, white)
	    for i : 1 .. 100
		if tempName (i) not= 0 then
		    Font.Draw (chr (tempName (i)), c1 + spacing * i, d1, font1, blue)
		end if
	    end for
	    % var companyLength : int
	    % companyLength := length (companyName)
	    % Font.Draw (intstr (companyLength), 0, 0, font1, black)
	    % Font.Draw (companyName (companyLength), 50 + companyLength * 20, 0, font1, black)
	    % companyName (companyLength) := companyName - companyName (companyLength)
	end if
	%Done
	if ptinrect (x, y, o1, p1, o2, p2) then
	    doneName := true
	end if
	View.Update
	exit when doneName = true
    end loop

    %Save the name into variable
    for i : 1 .. 100
	if tempName (i) not= 0 then
	    companyName := companyName + chr (tempName (i))
	end if
    end for

    % var tempx, tempy : int
    % tempx := x1
    % tempy := y1
    % if ptinrect (x, y, x1, y1, x2, y2) then
    %     % drawfillbox(
    %     companyName := companyName + chr (letterValue)
    %     x1 := 100
    %     y1 := 600
    %     Font.Draw (companyName, x1, y1, font1, blue)
    %     put companyName
    % end if
    % x1 := tempx
    % y1 := tempy
    % y1 := y2 + 60
    % x1 := x1 + 10
    % Font.Draw (chr (letterValue), x1, y1, font1, blue)

end ChooseCompanyName
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%High Score STUFF%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure testReset
    open : f1, "Data", write
    for i : 1 .. 11
	score (i).companyName := "Jason"
	score (i).score := 1000000
	write : f1, score (i)
    end for
    close : f1
end testReset

procedure SortScore
    var temp : scoreData
    for j : 1 .. 10
	for i : 1 .. 10
	    if score (i).score > score (i + 1).score then
		temp := score (i)
		score (i) := score (i + 1)
		score (i + 1) := temp
	    end if
	end for
    end for
    open : f1, "Data", write
    for j : 1 .. 10
	write : f1, score (j)
    end for
    close : f1
end SortScore

procedure ResetScores
    var x1, x2, y1, y2 : int
    x1 := 600
    x2 := x1 + 150
    y1 := 500
    y2 := y1 + 50
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, yellow)
	drawbox (x1, y1, x2, y2, black)
	Font.Draw ("Reset Scores?", x1 + 5, y1 + 5, font3, black)
	if z = 1 then
	    open : f1, "Data", write
	    for i : 1 .. 11
		score (i).companyName := "Jason"
		score (i).score := (3 ** i) * 1000
		write : f1, score (i)
	    end for
	    close : f1
	    SortScore
	    Font.Draw ("Scores Reset", x1, y1 + 200, font3, black)
	end if
    else
	drawfillbox (x1, y1, x2, y2, brightgreen)
	drawbox (x1, y1, x2, y2, black)
	Font.Draw ("Reset Scores?", x1 + 5, y1 + 5, font3, black)
    end if

end ResetScores

procedure ShowScores
    var x1 : int := 100
    Font.Draw ("Name", x1, 610, font1, black)
    Font.Draw ("Time to achieve " + intstr (goal) + "$", x1 + 200, 610, font1, black)
    Draw.ThickLine (x1, 600, x1 + 110, 600, 5, black)
    Draw.ThickLine (x1 + 200, 600, x1 + 730, 600, 5, black)
    open : f1, "Data", read
    for i : 1 .. 10
	read : f1, score (i)


	Font.Draw (score (i).companyName, x1, 600 - (50 * i), font2, black)
	Font.Draw (realstr (score (i).score div 1000, 0) + "s", x1 + 200, 600 - (50 * i), font2, black)
    end for

    close : f1
end ShowScores




procedure SaveScore
    open : f1, "Data", write
    score (11).companyName := companyName
    score (11).score := winningTime
    write : f1, score (1)
    close : f1
    SortScore
end SaveScore


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
	var lastUpgrade, upgradeBoxy : int := 0
	var boxx : int := 8 + (100 * i)
	for j : 1 .. 10

	    var boxy : int := 200 + (j * 40)
	    var boxh : int := 30
	    if x > boxx and x < boxx + boxh and y > boxy and y < boxy + boxh and factoryUpgrade (i, j) = false then
		drawfillbox (boxx, boxy, boxx + boxh, boxy + boxh, black)
		drawfillbox (boxx + 1, boxy + 1, boxx + boxh - 1, boxy + boxh - 1, yellow)
		if i = 1 then
		    Pic.ScreenLoad ("pics/gems/" + intstr (i) + "1.bmp", boxx, boxy, picMerge)
		else

		    Pic.ScreenLoad ("pics/gems/" + intstr (i - 1) + "1.bmp", boxx, boxy, picMerge)
		end if
		Font.Draw (intstr (2 ** j), boxx - 40, boxy + 10, font2, black)
		if z = 1 then
		    if i = 1 then
			if enoughMoney (numGems (i), factoryCost (i, j)) then
			    factoryUpgrade (i, j) := true
			    %Font.Draw ("TRUE", 800, 400, font1, black)
			    numGems (i) := numGems (i) - factoryCost (i, j)
			else
			    % Font.Draw ("FALSE", 800, 400, font1, black)
			end if
		    else
			if enoughMoney (numGems (i - 1), factoryCost (i, j)) then
			    factoryUpgrade (i, j) := true
			    %  Font.Draw ("TRUE", 800, 400, font1, black)
			    numGems (i - 1) := numGems (i - 1) - factoryCost (i, j)
			else
			    %  Font.Draw ("FALSE", 800, 400, font1, black)
			end if
		    end if
		end if
	    else
		if factoryUpgrade (i, j) = true then
		    drawfillbox (boxx, boxy, boxx + boxh, boxy + boxh, black)
		    drawfillbox (boxx + 1, boxy + 1, boxx + boxh - 1, boxy + boxh - 1, brightgreen)
		    lastUpgrade := j
		    upgradeBoxy := 200 + (j * 40)

		else
		    drawfillbox (boxx, boxy, boxx + boxh, boxy + boxh, black)
		end if
	    end if

	    %drawfillbox (8 + (100 * i), 200 + (j * 20), 8 + (100 * i) + 10, 200 + (j * 20) + 10, black)
	end for

	Pic.ScreenLoad ("pics/gems/" + intstr (i) + intstr (lastUpgrade) + ".bmp", boxx - 40, upgradeBoxy, picMerge)


    end for


    %Testing purposes
    %Font.Draw (realstr (endTime / 1000, 0), 100, 100, font1, black)
    %Font.Draw (realstr (startTime (1) / 1000, 0), 500, 100, font1, black)

    %Miner on Set (1)
    var x1, x2, y1, y2 : int
    x1 := 100
    y1 := 130
    Font.Draw ("Miner in Charge of Facility", x1, y1, font1, black)
    Font.Draw ("Your miner decreases the time per gem by " + intstr (2 * workerStats (1, 2)) + " milliseconds", x1, y1 - 60, font3, black)
    x1 := 500
    y1 := 100
    Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (1)) + ".bmp", x1, y1, picMerge)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    y1 := 150
    x1 := 600
    Font.Draw ("Intelligence: ", x1, y1 - 15, font2, black)
    Font.Draw ("Strength: ", x1, y1 - 30, font2, brightred)
    Font.Draw ("Stamina: ", x1, y1 - 45, font2, black)
    Font.Draw ("Luck: ", x1, y1 - 60, font2, black)
    for i : 1 .. 4
	if i = 2 then
	    Font.Draw (intstr (workerStats (1, i)), x1 + 80, y1 - 15 * i, font2, brightred)
	else
	    Font.Draw (intstr (workerStats (1, i)), x1 + 80, y1 - 15 * i, font2, black)
	end if
    end for

    Font.Draw ("in milliseconds per gem", 780, 170, font3, black)
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
	    Font.Draw ("-", 0 + (100 * i), 165, font1, red)
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
		gemRate (i) := round (3000 / j) - 2 * workerStats (1, 2)
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
    end for
    money := startMoney
    storeMultiplier := 1
end ResetStartGems

procedure CurrentGemTotals
    GemTimers
    CheckGemRate
    for i : 1 .. 7
	Pic.ScreenLoad ("pics/gems/" + intstr (i) + "1.bmp", -30 + (100 * i), 650, picMerge)
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

procedure StoreTimers
    for i : 1 .. 5
	if endTime - startStoreTimer (i) > sitem (i).timer and sitem (i).quantity > 0 then
	    sitem (i).quantity -= 1
	    money += sitem (i).sell
	    startStoreTimer (i) := Time.Elapsed
	end if
	if sitem (i).quantity = 0 then
	    var tempj : int
	    for j : 1 .. (maxqueue - 5)
		tempj := j + 5
		if sitem (tempj).quantity > 0 then
		    exit
		end if
	    end for
	    sitem (i).name := sitem (tempj).name
	    sitem (i).sell := sitem (tempj).sell
	    sitem (i).timer := sitem (tempj).timer
	    sitem (i).quantity := sitem (tempj).quantity
	    sitem (tempj).name := ""
	    sitem (tempj).sell := 0
	    sitem (tempj).timer := 0
	    sitem (tempj).quantity := 0
	end if
    end for

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end StoreTimers

procedure MoneyBackGround
    var x1, x2, y1, y2 : int
    x1 := 880
    y1 := 425
    Font.Draw ("Company Budget: ", x1, y1, font3, black)
    y1 := y1 - 40
    y2 := y1 + 35
    x2 := x1 + 170
    drawfillbox (x1, y1, x2, y2, yellow)
    x1 := x1 + 40
    y1 := y1 + 5
    Font.Draw (intstr (money) + "$", x1, y1, font1, 176)
end MoneyBackGround



%%%%%%%%%%%%%%SAVE GAME%
procedure SaveTheGame
    open : f1, "savefile", write
    for i : 1 .. 7
	write : f1, numGems (i)
    end for
    for i : 1 .. 5
	write : f1, workerPic (i)
	for j : 1 .. 4
	    write : f1, workerStats (i, j)
	end for
    end for

    for i : 1 .. 7
	for j : 1 .. 10
	    write : f1, factoryUpgrade (i, j)
	end for
    end for
    for i : 1 .. maxqueue
	write : f1, sitem (i).name
	write : f1, sitem (i).sell
	write : f1, sitem (i).timer
	write : f1, sitem (i).quantity
    end for
    write : f1, companyName
    write : f1, money
    write : f1, storeMultiplier
    close : f1
end SaveTheGame


procedure SaveGame
    var x1, x2, y1, y2 : int
    x1 := 600
    x2 := 790
    y1 := 5
    y2 := 40
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Save Game", x1 + 10, y1 + 5, font1, black)
	if z = 1 then
	    SaveTheGame
	    Font.Draw ("Game Saved", x1 + 200, y1 + 10, font3, black)
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	Font.Draw ("Save Game", x1 + 10, y1 + 5, font1, black)

    end if
end SaveGame

procedure QuitGame
    var x1, x2, y1, y2 : int
    x1 := 0
    x2 := 110
    y1 := 0
    y2 := 25
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Font.Draw ("Quit Game", x1 + 5, y1 + 5, font3, black)
	if z = 1 then
	    quitgame := 1
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	Font.Draw ("Quit Game", x1 + 5, y1 + 5, font3, black)
    end if
end QuitGame

%%%%%%%%%%%%%%%%%%%%%%
procedure Background
    MoneyBackGround
    StoreTimers
    CurrentGemTotals
    CurrentWorkers
    BackToMenu
    SaveGame
    Font.Draw (companyName + " Incorporated", 120, 5, font1, black)
    QuitGame
end Background


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%View Worker STuff%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%From ViewWorker
procedure UpgradeWorkers (i, j : int)
    workerStats (i, j) += 3
    if workerStats (i, j) >= 100 then
	workerStats (i, j) := 100
    end if
end UpgradeWorkers




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
%%%%%%%%%%U%%%%%%%%WORKSHOP STUFFF%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure ResetQueue
    for i : 1 .. maxqueue
	sitem (i).name := ""
	sitem (i).sell := 0
	sitem (i).timer := 0
	sitem (i).quantity := 0
    end for
end ResetQueue

%Remember to change numrecipes at top near declare variables
procedure Recipes
    if recipePage = 1 then
	FileInput := "recipes1.txt"
    elsif recipePage = 2 then
	FileInput := "recipes2.txt"
    elsif recipePage = 3 then
	FileInput := "recipes3.txt"
    end if
    open : file, FileInput, get
    for i : 1 .. numRecipes     %@
	var numMatType, x1, x2, y1, y2, col, counter : int
	var matType, numMat : array 1 .. 7 of int
	counter := 0
	var item : string
	get : file, numMatType
	get : file, item


	for j : 1 .. numMatType
	    get : file, matType (j)
	    get : file, numMat (matType (j))
	    numMat (matType (j)) := numMat (matType (j)) - (round (workerStats (3, 1) / 10))

	    if numGems (matType (j)) >= numMat (matType (j)) * quantity (numRecipes) then
		workShop (j) := true
	    else
		workShop (j) := false
	    end if


	    %Type of Gem
	    %Font.Draw (intstr (matType), 50 * matType, 650 - 100 * i, font2, black)
	    Pic.ScreenLoad ("pics/gems/" + intstr (matType (j)) + "1.bmp", 50 * matType (j), 630 - 100 * i, picMerge)
	    %Number of Gems
	    Font.Draw ("x" + intstr (numMat (matType (j))), 50 * matType (j), 600 - 100 * i, font2, black)
	end for


	for j : 1 .. numMatType
	    if workShop (j) = true then
		counter += 1
	    end if
	end for

	x1 := 50 * 9
	x2 := x1 + 100
	y1 := 600 - 100 * i
	y2 := y1 + 50
	if counter = numMatType then
	    col := 10
	else
	    col := 12
	end if
	%Boxes
	drawfillbox (x1, y1, x2, y2, col)
	drawbox (x1, y1, x2, y2, black)
	Font.Draw (intstr (quantity (numRecipes)), x1 + 35, y1 + 10, font1, black)
	%Triangles

	var xt : array 1 .. 3 of int
	xt (1) := x1 - 10
	xt (2) := x1 - 10
	xt (3) := xt (1) - 50
	var yt : array 1 .. 3 of int
	yt (1) := y1
	yt (2) := y2
	yt (3) := (y1 + y2) div 2
	/*if whatdotcolor (x, y) = brightcyan and y >= yt (1)and y <= yt (2) and x <= xt (2) then
	 Draw.FillPolygon (xt, yt, 3, yellow)
	 else
	 Draw.FillPolygon (xt, yt, 3, brightcyan)
	 end if*/

	%left
	Draw.FillPolygon (xt, yt, 3, brightcyan)
	Draw.Polygon (xt, yt, 3, black)
	%right
	xt (1) := x2 + 10
	xt (2) := x2 + 10
	xt (3) := xt (1) + 50
	Draw.FillPolygon (xt, yt, 3, brightcyan)
	Draw.Polygon (xt, yt, 3, black)

	if whatdotcolor (x, y) = brightcyan or whatdotcolour (x, y) = yellow then
	    Draw.Fill (x, y, yellow, white)
	    %Draw.Polygon (xt, yt, 3, black)
	    if z = 1 then
		if x > x1 then
		    quantity (numRecipes) += 1     %numRecipes
		    %delay (75)
		    z := 0
		elsif x < x1 and quantity (numRecipes) > 1 then
		    quantity (numRecipes) -= 1
		    %delay (75)
		    z := 0
		end if
	    end if
	elsif whatdotcolour (x, y) = white then
	    Draw.Fill (x, y, brightcyan, white)
	end if


	for k : 1 .. numRecipes
	    y1 := 600 - 100 * k
	    y2 := y1 + 50
	    xt (1) := x1 - 10
	    xt (2) := x1 - 10
	    xt (3) := xt (1) - 50

	    yt (1) := y1
	    yt (2) := y2
	    yt (3) := (y1 + y2) div 2
	    Draw.Polygon (xt, yt, 3, black)
	    xt (1) := x2 + 10
	    xt (2) := x2 + 10
	    xt (3) := xt (1) + 50
	    Draw.Polygon (xt, yt, 3, black)
	end for


	%Build and Sell Box box
	x1 := 50 * 13
	x2 := x1 + 220
	y1 := 600 - 100 * i
	y2 := y1 + 50
	if counter = numMatType then
	    if x > x1 and x < x2 and y > y1 and y < y2 then
		drawfillbox (x1, y1, x2, y2, 68)     %yellow
		drawbox (x1, y1, x2, y2, black)
		Font.Draw ("Build and Sell", x1 + 10, y1 + 10, font1, black)
		%View.Update
		if z = 1 then
		    var maxGems : int := 0
		    %BuildItems
		    for j : 1 .. numMatType
			%put numGems (matType (j))
			numGems (matType (j)) -= numMat (matType (j)) * quantity (numRecipes)
			maxGems += numMat (matType (j))
		    end for

		    %%%%%%%%%%%%%%%%%%%%%%
		    %Sending items to store
		    %%%%%%%%%%%%%%%%%%%%%%%5
		    var whatqueue : int
		    var queueFull : boolean := false
		    for j : 1 .. maxqueue
			whatqueue := j
			if j = maxqueue then
			    queueFull := true
			end if
			exit when sitem (j).quantity = 0
		    end for
		    %TEST THESE FORMULAS PROBABLY WRONG
		    if queueFull = false then
			sitem (whatqueue).name := item
			sitem (whatqueue).sell := round (maxGems * storeMultiplier)
			if workerStats (5, 3) = 0 then
			    sitem (whatqueue).timer := (maxGems div 5 * 1000)
			else
			    sitem (whatqueue).timer := (maxGems div 5 * 1000) div (workerStats (5, 3) div 20)
			end if
			%sitem (whatqueue).timer := (maxGems div 5 * 1000)
			sitem (whatqueue).quantity := quantity (numRecipes)
			lastsitem.name := sitem (whatqueue).name
			lastsitem.sell := sitem (whatqueue).sell
			lastsitem.timer := sitem (whatqueue).timer
			lastsitem.quantity := sitem (whatqueue).quantity
			if whatqueue <= 5 then
			    startStoreTimer (whatqueue) := Time.Elapsed
			end if
		    else
			lastsitem.name := "QUEUE IS FULL"
		    end if
		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		end if
	    else
		drawfillbox (x1, y1, x2, y2, brightgreen)
		drawbox (x1, y1, x2, y2, black)
		Font.Draw ("Build and Sell", x1 + 10, y1 + 10, font1, black)
	    end if
	end if

	%SHOW LAST ITEM BUILT AND SOLD

	if lastsitem.name not= "" then
	    x1 := 880
	    y1 := 360
	    if lastsitem.name = "QUEUE IS FULL" then
		Font.Draw (lastsitem.name, x1, y1, font3, black)
		y1 -= 40
		Font.Draw ("You may not build", x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("anymore items", x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("until an item", x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("in the queue", x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("is finished being built.", x1, y1, font3, black)
		y1 -= 40
		Font.Draw ("Visit your store", x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("for more details.", x1, y1, font3, black)
	    else
		Font.Draw ("Last Built:", x1 + 5, y1, font3, black)
		y1 -= 40
		Font.Draw (lastsitem.name, x1 + 45, y1, font3, black)
		y1 -= 55
		Pic.ScreenLoad ("pics/items/" + lastsitem.name + ".bmp", x1 + 65, y1, picMerge)
		y1 -= 25
		Font.Draw ("Being Sold at: " + intstr (lastsitem.sell) + "$ each", x1, 300, font3, black)
		y1 -= 20
		Font.Draw ("Sell Time: " + realstr (lastsitem.timer / 1000, 0) + "s each", x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("# Built: " + intstr (lastsitem.quantity), x1, y1, font3, black)
		y1 -= 20
		Font.Draw ("Estimated Total Time: ", x1, y1, font3, black)
		y1 -= 40
		Font.Draw (realstr (lastsitem.timer * lastsitem.quantity / 1000, 0) + "s", x1 + 70, y1, font1, black)
		y1 -= 20
		Font.Draw ("Total Price: ", x1, y1, font3, black)
		y1 -= 40
		Font.Draw (realstr (lastsitem.sell * lastsitem.quantity, 0) + "$", x1 + 70, y1, font1, black)
	    end if
	end if

	%Select Recipe Page
	Font.Draw ("Recipe Page: ", 5, 50, font3, black)
	for m : 1 .. maxPages
	    x1 := 130 * m
	    x2 := x1 + 50
	    y1 := 40
	    y2 := 80
	    if x > x1 and x < x2 and y > y1 and y < y2 or recipePage = m then
		drawfillbox (x1, y1, x2, y2, yellow)
		drawbox (x1, y1, x2, y2, black)
		Font.Draw (intstr (m), x1 + 15, y1 + 10, font1, black)
		if z = 1 then
		    recipePage := m
		end if
	    else
		drawfillbox (x1, y1, x2, y2, blue)
		drawbox (x1, y1, x2, y2, black)
		Font.Draw (intstr (m), x1 + 15, y1 + 10, font1, white)
	    end if
	end for




	% if workShop = true then
	%     Font.Draw ("True", 50 * 8, 600 - 100 * i, font1, black)
	% else
	%     Font.Draw ("False", 50 * 8, 600 - 100 * i, font1, black)
	% end if
	%Font.Draw (intstr (numMatType), 2, 600 - 100 * i, font1, black)
	Pic.ScreenLoad ("pics/items/" + item + ".bmp", 10, 625 - 100 * i, picMerge)
	%Put the picture of the object
    end for     %@
    close (file)
end Recipes

procedure Engineer
    var x1, x2, y1, y2 : int
    x1 := 50
    y1 := 600
    Font.Draw ("Head Engineer", x1, y1, font1, black)
    y2 := y1 - 30
    Font.Draw ("Your engineer decreases number of materials needed.", x1, y2, font3, black)
    x1 := x1 + 210
    y1 -= 10
    Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (3)) + ".bmp", x1, y1, picMerge)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    x1 := x1 + 300
    y1 += 50
    Font.Draw ("Intelligence: ", x1, y1 - 15, font2, brightred)
    Font.Draw ("Strength: ", x1, y1 - 30, font2, black)
    Font.Draw ("Stamina: ", x1, y1 - 45, font2, black)
    Font.Draw ("Luck: ", x1, y1 - 60, font2, black)
    for i : 1 .. 4
	if i = 1 then
	    Font.Draw (intstr (workerStats (3, i)), x1 + 80, y1 - 15 * i, font2, brightred)
	else
	    Font.Draw (intstr (workerStats (3, i)), x1 + 80, y1 - 15 * i, font2, black)
	end if
    end for
end Engineer


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%STORE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure Salesman
    var x1, x2, y1, y2 : int
    x1 := 800
    y1 := 350
    Font.Draw ("Leading Salesman", x1, y1, font1, black)
    y1 := y1 - 30
    Font.Draw ("Your salesman increases", x1, y1, font3, black)
    y1 -= 20
    Font.Draw ("your selling speed.", x1, y1, font3, black)
    y1 -= 60
    Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (5)) + ".bmp", x1, y1, picMerge)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    y1 -= 30
    Font.Draw ("Intelligence: ", x1, y1 - 15, font2, black)
    Font.Draw ("Strength: ", x1, y1 - 30, font2, black)
    Font.Draw ("Stamina: ", x1, y1 - 45, font2, brightred)
    Font.Draw ("Luck: ", x1, y1 - 60, font2, black)
    x1 += 50
    for i : 1 .. 4
	if i = 3 then
	    Font.Draw (intstr (workerStats (5, i)), x1 + 80, y1 - 15 * i, font2, brightred)
	else
	    Font.Draw (intstr (workerStats (5, i)), x1 + 80, y1 - 15 * i, font2, black)
	end if
    end for
end Salesman

procedure ViewItemsOnSale
    var x1, x2, y1, y2, amount : int
    x1 := -100
    y1 := 550
    amount := 150
    for i : 1 .. 6
	drawline (x1 + i * amount - 5, 0, x1 + i * amount - 5, maxy - 100, black)
    end for
    drawline (x1 + amount - 5, maxy - 100, x1 + 6 * amount - 5, maxy - 100, black)
    for i : 1 .. 5
	y1 := 550
	x1 := -100 + i * amount
	if sitem (i).quantity > 0 then
	    Font.Draw (sitem (i).name, x1, y1, font4, black)
	    y1 -= 50
	    Pic.ScreenLoad ("pics/items/" + sitem (i).name + ".bmp", x1 + 50, y1, picMerge)
	    y1 -= 20
	    Font.Draw ("Being Sold at:", x1, y1, font3, black)
	    y1 -= 20
	    Font.Draw (realstr (sitem (i).sell, 0) + "$ each", x1 + 30, y1, font3, black)
	    y1 -= 20
	    Font.Draw ("Sell Time:", x1, y1, font3, black)
	    y1 -= 20
	    Font.Draw (realstr (sitem (i).timer / 1000, 0) + "s each", x1 + 30, y1, font3, black)
	    y1 -= 20
	    Font.Draw ("# Left to Sell:", x1, y1, font3, black)
	    y1 -= 20
	    Font.Draw (intstr (sitem (i).quantity), x1 + 60, y1, font3, black)
	    y1 -= 40
	    Font.Draw ("Total Time", x1, y1, font3, black)
	    y1 -= 20
	    Font.Draw ("Remaining:", x1, y1, font3, black)
	    y1 -= 20
	    var tempTotalTimer : real := sitem (i).timer * sitem (i).quantity
	    Font.Draw (realstr (tempTotalTimer / 1000, 0) + "s", x1 + 30, y1, font3, black)
	    y1 -= 40
	    Font.Draw ("Total Price:", x1, y1, font3, black)
	    y1 -= 20
	    Font.Draw (realstr (sitem (i).sell * sitem (i).quantity, 0) + "$", x1 + 30, y1, font3, black)
	    y1 -= 40
	    Font.Draw ("Curently Selling:", x1, y1, font3, black)
	    y1 -= 20
	    var tempTimer : real := sitem (i).timer - (endTime - startStoreTimer (i))
	    Font.Draw (realstr ((tempTimer / 1000), 0) + "s", x1, y1, font3, black)
	    y1 -= 80
	    y2 := y1 + 50
	    x2 := x1 + 140
	    if x > x1 and x < x2 and y > y1 and y < y2 then
		drawfillbox (x1, y1, x2, y2, yellow)
		drawbox (x1, y1, x2, y2, black)
		Font.Draw ("Remove from", x1 + 5, y1 + 30, font3, black)
		Font.Draw ("Shop", x1 + 5, y1 + 5, font3, black)
		if z = 1 then
		    sitem (i).quantity := 0
		    Time.DelaySinceLast (250)
		end if
	    else
		drawfillbox (x1, y1, x2, y2, 90)
		drawbox (x1, y1, x2, y2, black)
		Font.Draw ("Remove from", x1 + 5, y1 + 30, font3, black)
		Font.Draw ("Shop", x1 + 5, y1 + 5, font3, black)
	    end if
	else
	    x1 += 20
	    Font.Draw ("Empty", x1, y1, font3, black)
	end if
    end for

    Salesman

end ViewItemsOnSale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%ADVERTISING STUFF%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure PurchaseAd (cost, ad : int)
    %order is screwed up because of square format
    %1-2%  newspaper ad          na
    %2-0.5% word of mouth        wom
    %3-10% television ad         ta
    %4-5% radio ad               ra
    if money >= cost then
	var amount : real
	if ad = 1 then
	    amount := 0.02
	elsif ad = 2 then
	    amount := 0.005
	elsif ad = 3 then
	    amount := 0.1
	elsif ad = 4 then
	    amount := 0.05
	end if
	storeMultiplier += amount
	money := money - cost
	Time.DelaySinceLast (250)
    else
	Font.Draw ("You do not have enough money.", 300, 500, font3, black)
    end if

end PurchaseAd

procedure Advertisements
    var x1, x2, y1, y2, ad : int
    x1 := 100
    y1 := 530
    const wom : int := 60
    const na : int := 200
    const ta : int := 450
    const ra : int := 900
    var cost : array 1 .. 4 of int
    cost (2) := wom - (workerStats (4, 4) div 2)
    Font.Draw ("Word of Mouth: " + intstr (cost (2)) + "$", x1, y1, font3, black)
    cost (1) := na - (workerStats (4, 4) div 2)
    Font.Draw ("Newspaper Ad: " + intstr (cost (1)) + "$", x1, y1 - 20, font3, black)
    cost (4) := ra - (workerStats (4, 4) div 2)
    Font.Draw ("Radio Ad: " + intstr (cost (4)) + "$", x1, y1 - 40, font3, black)
    cost (3) := ta - (workerStats (4, 4) div 2)
    Font.Draw ("Television Ad: " + intstr (cost (3)) + "$", x1, y1 - 60, font3, black)
    x1 := 450
    Font.Draw ("Current Store Multiplier: " + realstr (storeMultiplier, 0) + "x", x1, y1, font1, black)

    ad := 0
    for i : 1 .. 2
	x1 := i * 400 - 300
	x2 := x1 + 300
	for j : 1 .. 2
	    ad += 1
	    y1 := j * 200 - 100
	    y2 := y1 + 150
	    %300 by 150 box
	    if x > x1 and x < x2 and y > y1 and y < y2 then
		drawfillbox (x1, y1, x2, y2, yellow)
		Pic.ScreenLoad ("pics/advertising/" + intstr (i) + intstr (j) + ".bmp", x1, y1, picMerge)
		drawbox (x1, y1, x2, y2, black)
		if z = 1 then
		    PurchaseAd (cost (ad), ad)
		end if
	    else
		drawfillbox (x1, y1, x2, y2, brightblue)
		Pic.ScreenLoad ("pics/advertising/" + intstr (i) + intstr (j) + ".bmp", x1, y1, picMerge)
		drawbox (x1, y1, x2, y2, black)
	    end if

	end for
    end for
end Advertisements

procedure Marketer
    var x1, x2, y1, y2 : int
    x1 := 50
    y1 := 600
    Font.Draw ("Head Marketer", x1, y1, font1, black)
    y2 := y1 - 30
    Font.Draw ("Your Marketer lowers the cost of advertising by " + intstr (workerStats (4, 4) div 2) + "$", x1, y2, font3, black)
    x1 := x1 + 210
    y1 -= 10
    Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (4)) + ".bmp", x1, y1, picMerge)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    x1 := x1 + 300
    y1 += 50
    Font.Draw ("Intelligence: ", x1, y1 - 15, font2, black)
    Font.Draw ("Strength: ", x1, y1 - 30, font2, black)
    Font.Draw ("Stamina: ", x1, y1 - 45, font2, black)
    Font.Draw ("Luck: ", x1, y1 - 60, font2, brightred)
    for i : 1 .. 4
	if i = 4 then
	    Font.Draw (intstr (workerStats (4, i)), x1 + 80, y1 - 15 * i, font2, brightred)
	else
	    Font.Draw (intstr (workerStats (4, i)), x1 + 80, y1 - 15 * i, font2, black)
	end if
    end for
end Marketer





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%MENU STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




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
	Pic.ScreenLoad ("pics/menu/1.bmp", x1, y1, picMerge)
	%Font.Draw ("Hire Workers", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 2
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/1.bmp", x1, y1, picMerge)
	%Font.Draw ("Hire Workers", x1 + 10, y1 + 30, font1, black)
    end if

    %VIEW FACTORY UPGRADES
    y1 := 350
    y2 := 450
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/2.bmp", x1, y1, picMerge)
	%Font.Draw ("View Factory Upgrades", x1 + 10, y1 + 30, font1, black)

	if z = 1 then
	    choice := 1
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/2.bmp", x1, y1, picMerge)
	%Font.Draw ("View Factory Upgrades", x1 + 10, y1 + 30, font1, black)
    end if

    %VIEW WORKERS
    y1 := 200
    y2 := 300
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/3.bmp", x1, y1, picMerge)
	%Font.Draw ("View Workers", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 3
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/3.bmp", x1, y1, picMerge)
	%Font.Draw ("View Workers", x1 + 10, y1 + 30, font1, black)
    end if

    %Workshop
    y1 := 50
    y2 := 150
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/4.bmp", x1, y1, picMerge)
	% Font.Draw ("View Workshop", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 4
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/4.bmp", x1, y1, picMerge)
	% Font.Draw ("View Workshop", x1 + 10, y1 + 30, font1, black)
    end if
    %SECOND COLUMN

    x1 := 500
    x2 := 850

    %Store
    y1 := 500
    y2 := 600
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/5.bmp", x1, y1, picMerge)
	% Font.Draw ("View Store", x1 + 10, y1 + 30, font1, black)
	if z = 1 then
	    choice := 5
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/5.bmp", x1, y1, picMerge)
	%Font.Draw ("View Store", x1 + 10, y1 + 30, font1, black)
    end if

    %Advertising
    y1 := 350
    y2 := 450
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/6.bmp", x1, y1, picMerge)
	% Font.Draw ("Advertising", x1 + 10, y1 + 30, font1, black)

	if z = 1 then
	    choice := 6
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/6.bmp", x1, y1, picMerge)
	%Font.Draw ("Advertising", x1 + 10, y1 + 30, font1, black)
    end if

    %High Scores
    y1 := 200
    y2 := 300
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/7.bmp", x1, y1, picMerge)
	if z = 1 then
	    choice := 7
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/7.bmp", x1, y1, picMerge)
    end if

    %Cheat Mode
    y1 := 50
    y2 := 150
    if x > x1 and x < x2 and y > y1 and y < y2 then
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	Pic.ScreenLoad ("pics/menu/8.bmp", x1, y1, picMerge)
	if z = 1 then
	    choice := 8
	end if
    else
	drawfillbox (x1, y1, x2, y2, black)
	drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, brightblue)
	Pic.ScreenLoad ("pics/menu/8.bmp", x1, y1, picMerge)
    end if

    Font.Draw ("Company Dashboard", 340, 620, font1, black)
    Draw.ThickLine (335, 610, 650, 610, 5, black)

    if win = true then
	x1 := 870
	y1 := 350
	Font.Draw ("You have won!", x1, y1, font3, black)
	y1 -= 20
	Font.Draw ("Your Score in time is:", x1, y1, font3, black)
	y1 -= 30
	Font.Draw (realstr (winningTime div 1000, 0) + "s", x1, y1, font3, black)
	y1 -= 30
	Font.Draw ("Feel free to continue", x1, y1, font3, black)
	y1 -= 20
	Font.Draw ("playing or go to", x1, y1, font3, black)
	y1 -= 60
	y2 := y1 + 50
	x2 := x1 + 225
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, yellow)
	    drawbox (x1, y1, x2, y2, black)
	    Font.Draw ("Congratulations Screen!", x1 + 5, y1 + 20, font3, black)
	    if z = 1 then
		choice := 9
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, brightgreen)
	    drawbox (x1, y1, x2, y2, black)
	    Font.Draw ("Congratulations Screen!", x1 + 5, y1 + 20, font3, black)
	end if

    end if


end MainMenu

procedure FactoryMenu
    %Draw the upgrade boxes
    DrawUpgradeBoxes
    %Checks to see if true
    CurrentGemRates
    CheckGemRate
    Background
end FactoryMenu

procedure HireWorkerMenu
    if x > 250 and x < 650 and y > 150 and y < 300 then
	drawfillbox (250, 150, 650, 300, black)
	drawfillbox (250 + 1, 150 + 1, 650 - 1, 300 - 1, yellow)
	Font.Draw ("View Applications", 275, 200, font1, black)
	if z = 1 then
	    Time.DelaySinceLast (250)
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
		elsif money >= 20 then
		    HireWorker
		    currentApplicantJob := 0
		    currentApplicant := 0
		    money -= 20
		else
		    Font.Draw ("You don't have enough money to hire.", x1 - 150, y1 - 30, font3, black)
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
	y1 := 200
	Font.Draw ("20$ to Hire", x1, y1, font3, black)
	y1 := 280
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

    %Train
    x1 := 800
    y1 := 350
    Font.Draw ("Cost to Train is", x1, y1, font1, black)
    var costToTrain : int
    costToTrain := 200 - workerStats (2, 4)
    y1 -= 50
    Font.Draw (intstr (costToTrain) + "$ for +3 stat", x1 + 50, y1, font1, black)

    for i : 1 .. 5
	y1 := 370
	x1 := 100 + i * amount - amount - 50
	x2 := x1 + 140
	for j : 1 .. 4
	    y1 -= 70
	    y2 := y1 + 50
	    var titleWord : string
	    if j = 1 then
		titleWord := "Intelligence"
	    elsif j = 2 then
		titleWord := "Strength"
	    elsif j = 3 then
		titleWord := "Stamina"
	    elsif j = 4 then
		titleWord := "Luck"
	    end if
	    if x > x1 and x < x2 and y > y1 and y < y2 and money >= costToTrain then
		drawfillbox (x1, y1, x2, y2, yellow)
		drawbox (x1, y1, x2, y2, black)
		if z = 1 then
		    UpgradeWorkers (i, j)
		    if workerStats (i, j) not= 100 then
			money -= costToTrain
		    end if
		end if
	    else
		drawfillbox (x1, y1, x2, y2, 90)
		drawbox (x1, y1, x2, y2, black)
	    end if

	    if money >= costToTrain then
		Font.Draw ("Increase", x1 + 5, y1 + 30, font3, black)
		Font.Draw (titleWord, x1 + 5, y1 + 5, font3, black)
	    else
		Font.Draw ("Not enough", x1 + 5, y1 + 30, font3, black)
		Font.Draw ("Money", x1 + 5, y1 + 5, font3, black)
	    end if
	end for
    end for

    %Manager on Set (1)
    x1 := 800
    y1 := 260
    Font.Draw ("Manager in Charge", x1, y1, font3, black)
    y1 -= 60
    Pic.ScreenLoad ("pics/workers/" + intstr (workerPic (2)) + ".bmp", x1, y1, picMerge)
    x1 := 880
    y1 := 260
    Font.Draw ("Intelligence: ", x1, y1 - 15, font2, black)
    Font.Draw ("Strength: ", x1, y1 - 30, font2, black)
    Font.Draw ("Stamina: ", x1, y1 - 45, font2, black)
    Font.Draw ("Luck: ", x1, y1 - 60, font2, brightred)
    for i : 1 .. 4
	if i = 4 then
	    Font.Draw (intstr (workerStats (2, i)), x1 + 80, y1 - 15 * i, font2, brightred)
	else
	    Font.Draw (intstr (workerStats (2, i)), x1 + 80, y1 - 15 * i, font2, black)
	end if
    end for
    x1 := 800
    y1 := 200
    Font.Draw ("Your manager decreases", x1, y1 - 60, font3, black)
    y1 -= 90
    Font.Draw ("the training cost by " + intstr (workerStats (2, 4)) + " $", x1, y1, font3, black)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55



    Background
    View.Update
end ViewWorkerMenu

procedure WorkshopMenu
    Recipes
    Engineer
    Background
    View.Update
end WorkshopMenu

procedure StoreMenu
    ViewItemsOnSale
    Background
    View.Update
end StoreMenu

procedure AdvertisingMenu
    Advertisements
    Marketer
    Background
    View.Update
end AdvertisingMenu

procedure HighScoreMenu
    ShowScores
    ResetScores
    Background
    View.Update
end HighScoreMenu

procedure CongratulationsMenu
    loop
	mousewhere (x, y, z)
	Pic.ScreenLoad ("pics/end.bmp", 0, 0, picMerge)
	if x > maxx - 100 and x < maxx and y > 0 and y < 50 then
	    drawfillbox (maxx - 100, 0, maxx, 50, black)
	    drawfillbox (maxx - 100 + 1, 0 + 1, maxx - 1, 50 - 1, yellow)
	    Font.Draw ("Menu", maxx - 95, 10, font1, black)
	    if z = 1 then
		exit
	    end if
	else
	    drawfillbox (maxx - 100, 0, maxx, 50, black)
	    drawfillbox (maxx - 100 + 1, 0 + 1, maxx - 1, 50 - 1, brightred)
	    Font.Draw ("Menu", maxx - 95, 10, font1, black)
	end if
	View.Update
    end loop
end CongratulationsMenu



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%CHEATING ZONE%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure CheatMode
    for i : 1 .. 7
	for j : 1 .. 10
	    factoryUpgrade (i, j) := true
	end for
    end for
    Font.Draw ("Your Upgrades are all at Max Rank and your money is now 10000$.", 20, 200, font1, black)
    money := 10000
end CheatMode








%CODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loop
    cls
    quitgame := 0
    choice := 0
    var selection : int
    var button : int
    loop
	Pic.ScreenLoad ("pics/start.bmp", 0, 0, picMerge)
	mousewhere (x, y, button)
	var x1, x2, y1, y2, amount, amountx : int
	amount := 35
	amountx := 10
	selection := 0
	x1 := 800
	x2 := x1 + 200

	y1 := 400
	y2 := 500
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	    Font.Draw ("New Game", x1 + amountx, y1 + amount, font1, black)
	    if button = 1 then
		selection := 1
		winningTimeStart := Time.Elapsed
		win := false
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	    Font.Draw ("New Game", x1 + amountx, y1 + amount, font1, black)
	end if


	y1 := y1 - 150
	y2 := y1 + 100

	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	    Font.Draw ("Load Game", x1 + amountx, y1 + amount, font1, black)
	    if button = 1 then
		selection := 2
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	    Font.Draw ("Load Game", x1 + amountx, y1 + amount, font1, black)
	end if

	y1 := y1 - 150
	y2 := y1 + 100
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	    Font.Draw ("Close Game", x1 + amountx, y1 + amount, font1, black)
	    if button = 1 then
		selection := 3
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	    Font.Draw ("Close Game", x1 + amountx, y1 + amount, font1, black)
	end if
	% x1 := 600
	% x2 := x1 + 200
	% if x > x1 and x < x2 and y > y1 and y < y2 then
	%     drawfillbox (x1, y1, x2, y2, black)
	%     drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	%     Font.Draw ("Activate Cheat Mode", x1 + 5, y1 + 5, font1, black)
	%     if button = 1 then
	%         selection := 4
	%     end if
	% else
	%     drawfillbox (x1, y1, x2, y2, black)
	%     drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	%     Font.Draw ("Activate Cheat Mode", x1 + 5, y1 + 5, font1, black)
	% end if




	View.Update
	exit when selection not= 0
    end loop
    %There is a delay here so that the user does not go right away into one of the menu locations by accident
    Time.DelaySinceLast (1000)
    z := 0

    %%%%%%%%%%%%%%NEW GAME
    if selection = 1 or selection = 4 then
	ChooseCompanyName
	ResetFactoryUpgrades
	ResetStartGems
	ResetQueue
	for i : 1 .. 5
	    workerPic (i) := 0
	    for j : 1 .. 4
		workerStats (i, j) := 0
	    end for
	end for
    end if

    %%%%%%%%%%%%%%%%LOAD GAME
    if selection = 2 then
	open : f1, "savefile", read
	for i : 1 .. 7
	    read : f1, numGems (i)
	end for
	for i : 1 .. 5
	    read : f1, workerPic (i)
	    for j : 1 .. 4
		read : f1, workerStats (i, j)
	    end for
	end for
	for i : 1 .. 7
	    for j : 1 .. 10
		read : f1, factoryUpgrade (i, j)
	    end for
	end for

	for i : 1 .. 7
	    gemRate (i) := 999999999
	end for
	for i : 1 .. maxqueue
	    read : f1, sitem (i).name
	    read : f1, sitem (i).sell
	    read : f1, sitem (i).timer
	    read : f1, sitem (i).quantity
	end for
	read : f1, companyName
	read : f1, money
	read : f1, storeMultiplier
	close : f1
	CheckGemRate
	CurrentGemTotals
    end if

    exit when selection = 3
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
	    %testReset
	    FactoryMenu
	elsif choice = 2 then
	    HireWorkerMenu
	elsif choice = 3 then
	    ViewWorkerMenu
	elsif choice = 4 then
	    WorkshopMenu
	elsif choice = 5 then
	    StoreMenu
	elsif choice = 6 then
	    AdvertisingMenu
	elsif choice = 7 then
	    HighScoreMenu
	elsif choice = 8 then
	    CheatMode
	elsif choice = 9 then
	    CongratulationsMenu
	end if
	if money >= goal and win = false then
	    win := true
	    testReset
	    winningTime := endTime - winningTimeStart
	    SaveScore
	    SortScore
	end if
	Background
	View.Update
	exit when quitgame = 1
    end loop
end loop
Window.Close (main)
