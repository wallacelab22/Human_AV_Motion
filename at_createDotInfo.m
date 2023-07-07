function dotInfo = at_createDotInfo(inputtype, currviscoh, currvisdir, typeInt, minNum, maxNum, meanNum, maxdotsframe, dur, vel_stair, visInfo)
% CREATEDOTINFO creates the default dotInfo structure
%
% dotInfo = createDotInfo(inputtype)
% where inputtype 1 is for using keyboard and 2 for using touchscreen/mouse.
% Also save the structure in file dotInfoMatrix or returns it.
%%  dotInfo.numDotField     number of dot patches that will be shown on screen
%   dotInfo.coh             vertical vectors, dots coherence (0...999) for each 
%                           dot patch
%   dotInfo.speed           vertical vectors, dots speed (10th deg/sec) for each 
%                           dot patch
%   dotInfo.dir             vertical vectors, dots direction (degrees) for each 
%                           dot patch
%   dotInfo.dotSize         size of dots in pixels, same for all patches
%   dotInfo.dotColor        color of dots in RGB, same for all patches
%   dotInfo.maxDotsPerFrame determined by testing video card
%   dotInfo.apXYD           x, y coordinates, and diameter of aperture(s) in 
%                           visual degrees          
%   dotInfo.maxDotTime      optional to set maximum duration (sec). If not provided, 
%                           dot presentation is terminated only by user response
%   dotInfo.trialtype       1 fixed duration, 2 reaction time
%   dotInfo.keys            a set of keyboard buttons that can terminate the 
%                           presentation of dots (optional)
%   dotInfo.mouse           a set of mouse buttons that can terminate the 
%                           presentation of dots (optional)
%
%   screenInfo.curWindow    window pointer on which to plot dots
%   screenInfo.center       center of the screen in pixels
%   screenInfo.ppd          pixels per visual degree
%   screenInfo.monRefresh   monitor refresh value
%   screenInfo.dontclear    If set to 1, flip will not clear the framebuffer 
%                           after Flip - this allows incremental drawing of 
%                           stimuli. Needs to be zero for dots to be erased.
%   screenInfo.rseed        random # seed, can be empty set[] 
% created June 2006 MKMK

dotInfo.cohSet = currviscoh;

% Left and right are the only directions that make sense for keypress experiment 
% at the moment. For the keypress experiment, the first number will be associated 
% with the left arrow, and the second with the right arrow (0 degrees is to the right)
% if currvisdir == 1
%     dotInfo.dirSet = [180 0];
% elseif currvisdir == 2
%     dotInfo.dirSet = [0 180];
% elseif currvisdir == 0
%     dotInfo.dirSet = [180 0];
% end
 dotInfo.dirSet = currvisdir;

% For multi set of dots, all the following fields must be provided.
% Choose either group of codes to use single set or multi set.

dotInfo.numDotField = 1;
dotInfo.apXYD = [0 50 50];
if vel_stair == 1
    dotInfo.speed = visInfo.vel;
else
    dotInfo.speed = 5.88; %block_dot_speed; %5.88;
end
dotInfo.coh = dotInfo.cohSet(ceil(rand*length(dotInfo.cohSet)))*1000; 
dotInfo.dir = dotInfo.dirSet(ceil(rand*length(dotInfo.dirSet)));
dotInfo.maxDotTime = dur;


% [1 fixed duration / 2 reaction time,  1 hold on / 2 hold off, 1 keypress / 2 mouse] 
% where "hold on" means subject has to hold fixation during task. Hold on is 
% always true for keypress routines.
if inputtype == 1 % keypress
    dotInfo.trialtype = [1 1 1];
else % mouse/touchscreen
    dotInfo.trialtype = [1 2 2];
end

dotInfo.dotColor = [255 255 255]; % white dots default

% dot size in pixels
dotInfo.dotSize = 2;

% fixation x,y coordinates
dotInfo.fixXY = [0 -20];
% fixation diameter
dotInfo.fixDiam = 20;
% fixation color
dotInfo.fixColor = [255 0 0];

% trialInfo.auto
% column 1: how to determine position of dots (relative to what): 1 to set
% manually, 2 to use fixation as center point, 3 to use aperture as center
% column 2: 1 to set coherence manually (just use one coherence repeatedly
% or set somewhere else), 2 random
% column 3: 1 to set direction manually (just use one direction repeatedly
% or set somewhere else), 2 random, 3 correction mode 
dotInfo.auto = [3 1 1];

% array for timimg
% CURRENTLY THERE IS AN ALMOST ONE SECOND DELAY FROM THE TIME DOTSX IS
% CALLED UNTIL THE DOTS START ON THE SCREEN! THIS IS BECAUSE OF PRIORITY.
% NEED TO EVALUATE WHETHER PRIORITY IS REALLY NECESSARY.
%
% FOR KEYPRESS ROUTINES
% for reaction time task
% 1. fixation on until targets on - if this is zero, than targets come on
%       with fixation, if don't want to show targets, make length 2
% 2. fixation on until dots on
% 3. max duration dots on
%
%
% for fixed duration task
% 1. fixation on until targets on - if this is zero, than targets come on
%       with fixation, if it is greater then time to dots on, comes on
%       after dots off. if greater than fix off, will come on at same time
%       as fix off.
% 2. fixation on until dots on
% 3. duration dots on
% 4. dots off until fixation off
% 5. time limit for keypress after fixation off
%
% (this will be fed into MakeInterval - to use a random distribution see
% help MakeInterval and set interval parameters in touchdottask) 

if inputtype == 1
    if dotInfo.trialtype(1) == 1
        dotInfo.durTime = [1 2 1 1 1.75];
    else
        dotInfo.durTime = [1 1 1];
    end
else
    if dotInfo.trialtype(1) == 1
        dotInfo.durTime = [4 2 1 1 0 3];
    else
        dotInfo.durTime = [4 0 1 3 3];
    end
end

% variables for making delay periods
% itype = 0 fixed delay, minNum is actual delay time (need minNum)
% itype = 1 uniform distribution (need minNum and maxNum)
% itype = 2 exponential distribution (need all three)
dotInfo.itype = typeInt;
dotInfo.imin= minNum;
dotInfo.imax = maxNum;
dotInfo.imean = meanNum;


%%%%%%% BELOW HERE IS STUFF THAT SHOULD GENERALLY NOT BE CHANGED!

% make time distributions - only has affect if variable distribution
dotInfo.minTime = makeInterval(dotInfo.itype, dotInfo.imin, dotInfo.imax,dotInfo.imean);

dotInfo.maxDotsPerFrame = maxdotsframe;   % by trial and error.  Depends on graphics card
% Use test_dots7_noRex to find out when we miss frames.
% The dots routine tries to maintain a constant dot density, regardless of
% aperture size.  However, it respects MaxDotsPerFrame as an upper bound.
% The value of 53 was established for a 7100 with native graphics card.

% possible keys active during trial
dotInfo.keyEscape = KbName('ESCAPE');
% dotInfo.keyEscape = KbName('escape');
dotInfo.keySpace = KbName('space');
dotInfo.keyReturn = KbName('return');

if inputtype == 1
%     dotInfo.keyLeft = KbName('left');
%     dotInfo.keyRight = KbName('right');
    dotInfo.keyLeft = KbName('leftarrow');
    dotInfo.keyRight = KbName('rightarrow');
else
    mouse_left = 1;
    mouse_right = 2;
    dotInfo.mouse = [mouse_left, mouse_right];
end

if nargout < 1
    if inputtype == 1
        save keyDotInfoMatrix dotInfo
    else
        save dotInfoMatrix dotInfo
    end
end
