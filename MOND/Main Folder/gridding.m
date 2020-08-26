function [gridn, gridz] = gridding()
%Takes no input, creates two grids, with different sizes, one to zoom in
%(Z)

msystemdim

%Defining the width and resolution of the grid
gridder = linspace(-domainsize,domainsize,domainfine);
zgridder = linspace(-2*displacement,2*displacement,domainfine);

%Making the mesh grid with the mesh gridder in all directions (x,y,z)
[X,Y,Z] = meshgrid(gridder,gridder,gridder);
[Xz,Yz,Zz] = meshgrid(zgridder,zgridder,zgridder);

gridn = {X,Y,Z};
gridz = {Xz,Yz,Zz};

