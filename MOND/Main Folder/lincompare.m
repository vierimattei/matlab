function [outputArg1,outputArg2] = lincompare(Vtot,Vcomp)
%Inputs are the PDE solution objects. These are put on two grid sizes
%(normal and zoomed) and compared with contour plots and isosurfaces.

msystemdim

contint = tic;

%Making the grid cover the domain in all direction. zgridder is the grid
%used for the zoomed in graph

fprintf('Making %d by %d by %d grid... \n', domainfine,domainfine,domainfine);

gridder = linspace(-domainsize,domainsize,domainfine);
zgridder = linspace(-2*displacement,2*displacement,domainfine);

%Making the mesh grid with the mesh gridder in all directions (x,y,z). Same
%for the zommed mesh

[X,Y,Z] = meshgrid(gridder,gridder,gridder);
[Xz,Yz,Zz] = meshgrid(zgridder,zgridder,zgridder);

gridt = toc(contint);

fprintf('Making the grid took %e s... \n', gridt);

%Interpolating the solution at all the points defined by the grid. Vz is
%solution interpolated over the zoomed in region

fprintf('Interpolating solution... \n');
tic

%Interpolation takes the vast majority of the computation time, so we only
%do it if we changed the size of the grid and want to plot with a
%different resolution (higher one, for lower makes no sense to redo the
%computation and get a less accurate result)
if exist('V','var') == 0

V=interpolateSolution(solutionhalf,X,Y,Z);
Vleft = interpolateSolution(solleft,X,Y,Z);

elseif ~isequal(size(V),size(X)) | ~isequal(size(Vleft),size(X))
     
V=interpolateSolution(solutionhalf,X,Y,Z);
Vleft = interpolateSolution(solleft,X,Y,Z);
    
end




if size(V) ~= size(X) | size(Vz) ~= size(Xz)

V  = interpolateSolution(solutionhalf,X,Y,Z);
Vz = interpolateSolution(solutionhalf,Xz,Yz,Zz);

%Interpolating the solutions from the configurations with only ones mass
%each independently, so then we can add them and compare. Vleftz and
%Vrightz as above

Vleft   = interpolateSolution(solleft,X,Y,Z);
Vright  = interpolateSolution(solright,X,Y,Z);
Vleftz  = interpolateSolution(solleft,Xz,Yz,Zz);
Vrightz = interpolateSolution(solright,Xz,Yz,Zz);

interpt = toc;

fprintf('Solution interpolated in %e s \n', interpt);

end

%Reshaping the solution vector so it's the same size as the coordinates of
%the grid, so a (50,50,50) array. Reshaping also for zoomed versions

fprintf('Reshaping solutions... \n');
tic

V=reshape(V,size(X));
Vleft=reshape(Vleft,size(X));
Vright=reshape(Vright,size(X));

Vz=reshape(Vz,size(Xz));
Vleftz=reshape(Vleftz,size(Xz));
Vrightz=reshape(Vrightz,size(Xz));

%Adding the left+right contributions of the individual mass configurations
Vadded  = Vleft+Vright;
Vaddedz = Vleftz+Vrightz;

%Vadded is the sum of the interpolated solutions from the simulations with
%one mass each. Since the size of X,Y,Z (how fine the grid is) depends on
%the domainfine variable defined in systemdim, we need to reshape Vadded as
%well everytime here after importing it

Vadded  =reshape(Vadded,size(X));
Vaddedz =reshape(Vaddedz,size(Xz));

%Computing the difference between the two potentials, both for the whole
%domaina nd zoomed case
Vdiff  = V - Vadded;
Vdiffz = Vz -Vaddedz;

resht = toc;
fprintf('Solutions reshaped in %e s \n',resht);

% Contour Plot for the solution, uncomment to use

%Defining the location of the source and superimposing it onto the contour
%slices
sourceloc = [displacement,0,0 ; -displacement,0,0];

%# lines plotted in each contour slice
contlines=20;

fprintf('Plotting the contours... \n');
tic

sliceall = -domainsize:domainsize/slicestot:domainsize;

%Plotting the potentials of the sum of the separate masses and originating
%from the two masses together.
tilcomp = tiledlayout('flow');
ax1 = nexttile;
colormap jet
colorbar
xlabel('x')
ylabel('y')
zlabel('z')
hold on 
axis equal
scatter(sourceloc(1:2,1),sourceloc(1:2,2),'filled');
title('Potential from two masses')
contourslice(X,Y,Z,V,sliceall,sliceall,sliceall,contlines,'cubic')
ax2 = nexttile;
contourslice(X,Y,Z,Vadded,sliceall,sliceall,sliceall,contlines,'cubic')
xlabel('x')
ylabel('y')
zlabel('z')
colorbar
hold on 
scatter(sourceloc(1:2,1),sourceloc(1:2,2),'filled');
title('Potential sum of individual masses')
axis equal
hold off

%With the axis function, have to define either 4,6 or 8 elements,
%corresponding to D*3. We have 3 axes so need limall 3 times, one for x, y,
%z each.
axis([ax1, ax2],[limall,limall,limall]);

slicezoom = -displacement*2:displacement*4/slicestot:displacement*2;

figure
tilzoom = tiledlayout('flow');
ax3 = nexttile;
colormap jet
colorbar
xlabel('x')
ylabel('y')
zlabel('z')
hold on 
axis equal
scatter(sourceloc(1:2,1),sourceloc(1:2,2),'filled');
contourslice(Xz,Yz,Zz,Vz,slicezoom,slicezoom,slicezoom,contlines,'cubic')
ax4 = nexttile;
contourslice(Xz,Yz,Zz,Vaddedz,slicezoom,slicezoom,slicezoom,contlines,'cubic')
xlabel('x')
ylabel('y')
zlabel('z')
colorbar
hold on 
scatter(sourceloc(1:2,1),sourceloc(1:2,2),'filled');
axis equal
hold off

%With the axis function, have to define either 4,6 or 8 elements,
%corresponding to D*3. We have 3 axes so need limall 3 times, one for x, y,
%z each.
axis([ax1, ax2],[limall,limall,limall]);

figure
tiler = tiledlayout('flow');
ax5 = nexttile;
colorbar
title('Difference in potential');
contourslice(X,Y,Z,Vdiff,sliceall,sliceall,sliceall,contlines,'cubic');
ax6 = nexttile;
colorbar
contourslice(Xz,Yz,Zz,Vdiffz,slicezoom,slicezoom,slicezoom,contlines,'cubic')


%Defining ticks, labels, and limits to be the same for all subplots(tiles)
tickall = (-domainsize:domainsize/10:domainsize);
labell = ({-domainsize/kp:domainsize/(10*kp):domainsize/kp});
limall = [-domainsize,domainsize];

%With the axis function, have to define either 4,6 or 8 elements,
%corresponding to D*3. We have 3 axes so need limall 3 times, one for x, y,
%z each.
axis([ax1, ax2],[limall,limall,limall]);

%Linking the axes together, so if one changes they all change
linkaxes([ax1, ax2])

contourt = toc;

fprintf('Plotting contours took %e \n',contourt);

%Specifying interesting values of the potential at and around which to draw
%isosurfaces, the interval around the central value and the amount to draw.
isoval    = 2.236*10^12;
isovaladd = 3.162*10^12;
isoint = 0.005;
isonum = 5;

fprintf('Plotting isosurfaces... \n');
tic

%Plotting isosurface slices for both potentials, giving them different
%colors to distinguish between them. Also have to note that the two
%potentials are offset from one another, so colormaps dont have the same
%value, hence using difference values isoval and isovaladd.

figure
isos = tiledlayout('flow');
for i = -isonum:isonum
nexttile
fprintf('Plotting isosurface %d of %d \n',i,isonum*2+1);
    if mod(i,2) == 0
        p = patch(isosurface(Xz,Yz,Zz,Vz,isoval*(1+isoint*i)));
        % isonormals(X,Y,Z,V,p)
        p.FaceColor = 'red';
    else
        p = patch(isosurface(Xz,Yz,Zz,Vaddedz,isovaladd*(1+isoint*i)));
        % isonormals(X,Y,Z,V,p)
        p.FaceColor = 'blue';   
    end    
end

isot = toc;

fprintf('Printed isosurfaces in %e s \n...', isot);

contend = toc(contint);

fprintf('All graphs done in %e s \n', contend);
end

