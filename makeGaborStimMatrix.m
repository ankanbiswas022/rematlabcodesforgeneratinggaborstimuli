% make a gabor stimulus, for GRF and CRS
% Vinay Shirhatti, 29 June 2017
% assisting function that generates the stimulus matrix
%
% inputs:
% stim : structure containing the parameter values for all the gabors. For
% CRS this will be length=3
% optional input arg:
% 'xPixels' : number of pixels along the horizontal axis; this string is
% followed by the value
% 'aspectRatio' : numXPixels/numYPixels, this string followed by the value
%==========================================================================

function [stimGabor,xd,yd,x,y] = makeGaborStimMatrix(stim,varargin)

if sum(strcmpi('xPixels',varargin))
    numXPixels = varargin{find(strcmpi(varargin,'xPixels'))+1};
else
    numXPixels = 100;
end

if sum(strcmpi('aspectRatio',varargin))
    aspectRatio = varargin{find(strcmpi(varargin,'aspectRatio'))+1};
else
    aspectRatio = 1;
end

if sum(strcmpi('showFixation',varargin))
    showFixation = varargin{find(strcmpi(varargin,'showFixation'))+1};
else
    showFixation = 0;
end

if sum(strcmpi('monitorResolution',varargin))
    numXPixels = 1280;
    aspectRatio = 1280/720;
end
%--------------------------------------------------------------------------
% Dimensions and distances
%--------------------------------------------------------------------------

% Monitor dimensions in inches
ht = 11.8; 
wd = 20.9;

% Resolution (num of pixels)
xRes = 1280;
yRes = 720;

% subject's distance from the screen in inches
distSub = 19.7;

numYPixels = numXPixels*aspectRatio; % here X => vert axis, Y => hori axis, hence Y/X = aspectRatio corr to the monitor

%--------------------------------------------------------------------------
% Calculations
%--------------------------------------------------------------------------

yDeg = 2*(atan((ht/2)/distSub))*180/pi; % in deg
xDeg = 2*(atan((wd/2)/distSub))*180/pi;

xDegPerPixel = xDeg/xRes;
yDegPerPixel = yDeg/yRes;

xPixels = numXPixels; yPixels = numYPixels;
x = -xPixels:1:xPixels;
y = -yPixels:1:yPixels;
xd = x*xDegPerPixel;
yd = y*yDegPerPixel;
stimGabor = zeros(length(xd),length(yd));
for g=1:length(stim)
    azi = stim(g).azimuthDeg; % a
    ele = stim(g).elevationDeg; % e
    sf = stim(g).spatialFreqCPD; % sf
    ori = stim(g).orientationDeg; % o
    con = stim(g).contrastPC; % c
    rad = stim(g).radiusDeg; % radius
    phs = stim(g).spatialPhase;
    w = 2*pi*sf; % omega sf in rad/s
    zd = zeros(length(xd),length(yd));
    stencil = zeros(length(xd),length(yd));
    for i=1:length(xd)
        for j=1:length(yd)
            zd(i,j) = con*sin(w*xd(i)*sin(ori*pi/180)+w*yd(j)*cos(ori*pi/180) + phs*pi/180); % main calculation
            stencil(i,j) = sqrt((xd(i)-azi).^2+(yd(j)-ele).^2)<=rad;
        end
    end
    clear gabor
    gabor = zd.*stencil;
    stimGabor(stencil~=0)=0;
    stimGabor = stimGabor+gabor;
end

if showFixation
    stencil = zeros(length(xd),length(yd));
    for i=1:length(xd)
        for j=1:length(yd)
            stencil(i,j) = sqrt((xd(i)).^2+(yd(j)).^2)<=0.1;
        end
    end
    stimGabor(stencil==1)=1;
end

% flip the matrix to make the y axis to go from down to up
stimGabor = flipud(stimGabor);
end