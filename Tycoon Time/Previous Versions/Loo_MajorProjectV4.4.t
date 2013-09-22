%By : Jason Loo
%Loo_Major Project
%Date Started: Ocotber 29, 2012
%Version 4.4
%Last edit: January 16, 2013

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
%Plan for Version 4.5---- Work on Store Timers, fix the erasing of background of company name selection

%Plan for future versions---Incorporate the workers into each section of company. Have them actually affect things

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
var hireWorker : array 1 .. 3 of int
var hireWorkerStats : array 1 .. 3, 1 .. 4 of int
var workerStats : array 1 .. 5, 1 .. 4 of int
var workerPic : array 1 .. 5 of int
var companyName : string := ""
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
var numRecipes : int := 5 %Change this whenever you add a new recipe
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
var maxqueue : int := 11 %Change the "5" to whatever the maximum queue is
var sitem : array 1 .. maxqueue of store



var lastsitem : store
lastsitem.name := ""

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
    loop
	var x1, x2, y1, y2 : int

	%Left
	x1 := 600
	x2 := x1 + 50
	y1 := 300
	y2 := y1 + 50
	drawfillbox (x1, y1, x2, y2, black)
	if ptinrect (x, y, x1, y1, x2, y2) then
	    letterValue -= 1
	end if


	%Right
	x1 := x1 + 200
	x2 := x1 + 50
	drawfillbox (x1, y1, x2, y2, black)
	if ptinrect (x, y, x1, y1, x2, y2) then
	    letterValue += 1
	end if


	%Select
	x1 := x1 - 100
	x2 := x1 + 50
	y1 := y1 - 100
	y2 := y1 + 50
	drawfillbox (x1, y1, x2, y2, black)
	if ptinrect (x, y, x1, y1, x2, y2) then
       % drawfillbox(
	    companyName := companyName + chr (letterValue)
	end if

	y1 := y2 + 60
	x1 := x1 + 10
	Font.Draw (chr (letterValue), x1, y1, font1, blue)
	x1 := 100
	y1 := 600
	Font.Draw (companyName, x1, y1, font1, blue)
	buttonwait ("down", x, y, z, z)
	View.Update
    end loop
end ChooseCompanyName




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
    CurrentGemTotals
    CurrentWorkers
    BackToMenu
    SaveGame
    QuitGame
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
%%%%%%%%%%%%%%%%%%WORKSHOP STUFFF%%%%%%%%%%%%%%%%%%%%%
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
			sitem (whatqueue).sell := maxGems %devise a formula for this somewhere
			sitem (whatqueue).timer := maxGems div 5
			sitem (whatqueue).quantity := quantity (numRecipes)
			lastsitem.name := item
			lastsitem.sell := maxGems
			lastsitem.timer := (maxGems / 5) * 1000
			lastsitem.quantity := quantity (numRecipes)
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
	    if lastsitem.name = "QUEUE IS FULL" then
		Font.Draw (lastsitem.name, x1, 410, font3, black)
		Font.Draw ("You may not build", x1, 370, font3, black)
		Font.Draw ("anymore items", x1, 350, font3, black)
		Font.Draw ("until an item", x1, 330, font3, black)
		Font.Draw ("in the queue", x1, 310, font3, black)
		Font.Draw ("is finished being built.", x1, 290, font3, black)
		Font.Draw ("Visit your store", x1, 250, font3, black)
		Font.Draw ("for more details.", x1, 230, font3, black)
	    else
		Font.Draw ("Last Built:", x1 + 5, 410, font1, black)
		Font.Draw (lastsitem.name, x1 + 45, 370, font3, black)
		Pic.ScreenLoad ("pics/items/" + lastsitem.name + ".bmp", x1 + 55, 325, picMerge)
		Font.Draw ("Being Sold at: " + intstr (lastsitem.sell) + "$ each", x1, 300, font3, black)
		Font.Draw ("Sell Time: " + realstr (lastsitem.timer / 1000, 0) + "s each", x1, 280, font3, black)
		Font.Draw ("# Built: " + intstr (lastsitem.quantity), x1, 260, font3, black)
		Font.Draw ("Estimated Total Time: ", x1, 240, font3, black)
		Font.Draw (realstr (lastsitem.timer * lastsitem.quantity / 1000, 0) + "s", x1 + 70, 200, font1, black)
		Font.Draw ("Total Price: ", x1, 180, font3, black)
		Font.Draw (realstr (lastsitem.sell * lastsitem.quantity, 0) + "$", x1 + 70, 140, font1, black)
	    end if
	end if

	%Select Recipe Page
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%STORE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure ViewItemsOnSale
    for i : 1 .. 5
	put "Queue Number: ", i
	put "Name of item: ", sitem (i).name
	put "Sell Price: ", sitem (i).sell
	put "Timer: ", sitem (i).timer
	put "Quantity: ", sitem (i).quantity
	put ""
    end for

    for i : 1 .. 5
	var l := i * 6
	locate (l, 50)
	var n := i + 5
	put "Queue Number: ", n
	l += 1
	locate (l, 50)
	put "Name of item: ", sitem (n).name
	l += 1
	locate (l, 50)
	put "Sell Price: ", sitem (n).sell
	l += 1
	locate (l, 50)
	put "Timer: ", sitem (n).timer
	l += 1
	locate (l, 50)
	put "Quantity: ", sitem (n).quantity
	l += 1
	locate (l, 50)
	put ""
    end for
end ViewItemsOnSale


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

    %Placeholder6
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
    Recipes
    Background
    View.Update
end WorkshopMenu

procedure StoreMenu
    ViewItemsOnSale
    Background
    View.Update
end StoreMenu

%CODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loop
    cls
    quitgame := 0
    choice := 0
    var selection : int
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
	y1 := 50
	y2 := 150
	if x > x1 and x < x2 and y > y1 and y < y2 then
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, yellow)
	    Font.Draw ("Close Game", x1 + 5, y1 + 5, font1, black)
	    if z = 1 then
		selection := 3
	    end if
	else
	    drawfillbox (x1, y1, x2, y2, black)
	    drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, white)
	    Font.Draw ("Close Game", x1 + 5, y1 + 5, font1, black)
	end if




	View.Update
	exit when selection not= 0
    end loop
    %There is a delay here so that the user does not go right away into one of the menu locations by accident
    delay (250)
    z := 0

    %%%%%%%%%%%%%%NEW GAME
    if selection = 1 then
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
	    FactoryMenu
	elsif choice = 2 then
	    HireWorkerMenu
	elsif choice = 3 then
	    ViewWorkerMenu
	elsif choice = 4 then
	    WorkshopMenu
	elsif choice = 5 then
	    StoreMenu

	end if
	Background
	View.Update
	exit when quitgame = 1
    end loop
end loop
Window.Close (main)
