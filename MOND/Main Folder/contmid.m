function  contmid(source, gridn, varargin)

%Takes as input the location of the sources (to plot with a scatter on top
%of the simulation results), the grids on which to plot, and any number of
%correctly gridded functions to plot.

msystemdim

tickall = linspace(-domainsize,domainsize,11);
labell = linspace(-domainsize/kp,domainsize/kp,11);

%Defining where to put the slices (xy,yz,xz planes if sliceall=0).
sliceall = 0;

%# lines plotted in each contour slice
contlines=50;

figure

for i= 1:nargin-2
        
    ax(i) = nexttile;

    colormap jet
    colorbar
    xlabel('x (kpc)')
    ylabel('y (kpc)')
    zlabel('z (kpc)')
    hold on 
    scatter3(source.x,source.y,source.z,'filled');
    title('varargin{i}')
    contourslice(gridn{1},gridn{2},gridn{3},varargin{i},sliceall,sliceall,sliceall,contlines,'cubic')
    xticks(tickall);
    yticks(tickall);
    zticks(tickall);
    xticklabels(labell);
    yticklabels(labell);
    zticklabels(labell);
    axis equal;
    
    bottom = min(min(min(varargin{1})));
    top = max(max(max(varargin{1})));
    
    caxis([bottom,top]);
    
    if i == nargin-2    
    
    %Linking the camera angle, axes and limits to that we always view the 
    %same part of the two subplots.
        
     Link = linkprop(ax(:),{'CameraUpVector', 'CameraPosition', ...
    'CameraTarget', 'XLim', 'YLim', 'ZLim'});

     %This line is essential for these links to actually work outside
     %of the function!
     setappdata(gcf, 'StoreTheLink', Link);
        
    end
    
end

end

