% Sample code to draw a color gabor
% Vinay Shirhatti, 13 March 2020
% This is the hack - I first make a gabor and then reassign the
% colormap as per the colors I want in the gabor
% Assisting functions: makeGaborStimMatrix, customColormap
%==========================================================================

% Define the stimulus parameters
stim.azimuthDeg = 0; % azi
stim.elevationDeg = 0; % ele
stim.sigmaDeg = 1; % sigma, radius = 3*sigma. Alternately you may just assign stim.radiusDeg
stim.spatialFreqCPD = 1; % sf
stim.orientationDeg = 90; % ori in deg
stim.contrastPC = 0.5; % con, convert to range range: [0 1]
stim.radiusDeg = stim.sigmaDeg*3; % radius = sigma*3. Alternately you may just assign this directly
stim.spatialPhase = 0; % spatial phase

stim.gaborColors = {[1 0 0],[0 1 0]}; % Assign the colors of the gabor: RG
% stim.gaborColors = {[1 1 0],[0 0 1]}; % Assign the colors of the gabor: BY

numXPixels = 100;
aspectRatio = 1;
showFixation = 0;

hStimFig = subplot(1,1,1);
[stimGabor,xd,yd,xp,yp] = makeGaborStimMatrix(stim,'xPixels',numXPixels,'aspectRatio',aspectRatio,'showFixation',showFixation);

% Have to remake the stencil to assign gray to pixels outside the stimulus
stencil = zeros(length(xd),length(yd));
for i=1:length(xd)
    for j=1:length(yd)
        stencil(i,j) = sqrt((xd(i)-stim.azimuthDeg).^2+(yd(j)-stim.elevationDeg).^2)<=stim.radiusDeg;
    end
end

% Now make a colormap that includes the colors in the gabor, and also gray
nColors = 1000; % number of steps between colors - defines the color resolution
gaborLims = [-1 1]; % limits of values in the gabor 

% Assign a placeholder value for gray part outside the stimulus. This value
% should be >1 since the gabor values are in the range [-1 1]. So, I am
% assigning this as 1+((total range)/(n-1)), and the correspinding color as
% gray. The caxis should also span exactly this range for the correct 
% mapping
stimGabor(stencil==0) = 1 + (gaborLims(2)-gaborLims(1))/(nColors-1);

% Make a colormap spanning the space of the gabor colors
myColorMap = customColormap(nColors,stim.gaborColors,0:1/(length(stim.gaborColors)-1):1);
% add gray to the colormap
myColorMap(end+1,:) = [0.5 0.5 0.5];

% Now draw the stimulus and assign myColorMap to it. And it's done!
hplot=hStimFig;subplot(hplot);
imagesc(xp,yp,stimGabor);
colormap(myColorMap);
caxis([-1 1+(gaborLims(2)-gaborLims(1))/(nColors-1)]);
drawnow;
axis square
set(hStimFig,'xlim',[xp(1) xp(end)]);
set(hStimFig,'ylim',[yp(1) yp(end)]);
set(hplot,'visible','on');
set(hplot,'ytick',[]);
set(hplot,'xtick',[]);
set(hplot,'linewidth',2);

