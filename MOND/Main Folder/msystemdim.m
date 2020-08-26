%{
Defining the characteristic dimensions, sources etc. of the system to
simulate.
%}

%Calling the constants script to load all the necessary constants
constants;

%Setting the size of the simulation domain
domainsize = 20*kp;

%Setting how fine the grid for plotting the contours is, intervals over the
%domain
domainfine = 50;

%Defining the threshold of mesh quality to check mesh
meshtresh = 0.1;

%Setting how many contour slices to plot
slicestot = 1;

%Displacement (in x direction) of mass from the origin
displacement = 2*kp;

%Defining the amount of sources. Used to refine mesh in "makemesh", to 
%plot source and to get correct boundary conditions.
sourcenum = 6;

%Defining the location of the source and superimposing it onto the contour
%slices        
sourceloc.x = [displacement, -displacement, 0, 0, 0, 0];
sourceloc.y = [0, 0, displacement, -displacement, 0, 0];
sourceloc.z = [0, 0, 0, 0, displacement, -displacement];

%Setting the resolution for the FEM grid, with elements being smaller for
%larger resolution (good initial value was 5 max, 10 min)

resolutionmax = 5;
resolutionmin = 5;

%Setting the total mass of the system
massoverall = mgb;

%Giving the total mass of each source so that the total mass is constant
mass = massoverall/sourcenum;

%Setting radius of mass distribution
radiustot = 0.5*kp;

%Total volume of a shell of r=radiustot
volumeout = 4/3*pi*(radiustot^3);

%Thuckness of a shell
thickness = 0.2;
radiusin = radiustot*thickness;

%Total volume of an empty shell of other radius
volumein = 4/3*pi*((radiustot*(1-thickness))^3);
volumetot = volumeout-volumein;

%Setting the relative size of the spheres for the plotting of the 3D
%scatter
ballsize = 2;