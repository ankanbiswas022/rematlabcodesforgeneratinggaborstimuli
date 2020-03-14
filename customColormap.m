% make your custom colormap!
% Vinay Shirhatti, 20 Sep 2016
%
% reference: http://stackoverflow.com/questions/17230837/how-to-create-a-custom-colormap-programatically
%
% ARGUMENTS IN:
% n : number of colors
% vertices : cell of colors (to interpolate across)
% boundaries : the transition points at which the colors in vertices are
% placed; value between 0 and 1 for each color in 'vertices' in ascending
% order
% showcmap : flag to show the colormap in a separate figure
%
% eg: 
% vertices{1} = [1 0 0]; vertices{2} = [0 0 1]; vertices{3} = [0.5 1 0];
% vertices{4} = [0.2 0.2 0.1];
% boundaries = [0 0.4 0.7 1];
%**************************************************************************

function mycolormap = customColormap(n,vertices,boundaries,showcmap)

if n<=1
    error('n must be greater than 1. If you want just one color use >> color = [r g b];');
end

if ~exist('showcmap','var'); showcmap = 0; end
if ~exist('boundaries','var'); boundaries = 0:1/(n-1):1; end

% ##TODO: make a list of colors with their colornames so that the vertices
% can also have name entries :D
% % convert colour names to values if any
% for i=1:length(vertices)
%     if ischar(vertices{i})
%         vertices{i} = getColorValueFromName(vertices(i),'normalized');
%     end
% end

colormatrix = cell2mat(vertices');

mycolormap = interp1(boundaries,colormatrix,linspace(0,1,n));

if showcmap
    figure;
    I = linspace(0,1,n);
    imagesc(I(ones(1,10),:)')
    colormap(mycolormap)
end

end