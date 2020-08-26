function [V,Vz] = intershape(sol,gridn,gridz)
%Function interpolates the solution over the grid produced with gridding() 
%and reshapes it so it can be plotted in 3D on two grid sizes, normal and 
%zoomed (z suffix). The gridded interpolated solutions are the output.

 %Interpolating solution over the grids (normal and zoomed)
 V  = interpolateSolution(sol,gridn{1},gridn{2},gridn{3});
 Vz = interpolateSolution(sol,gridz{1},gridz{2},gridz{3});

 %Reshaping the interpolated solutions to be grids of the right size
 V=reshape(V,size(gridn{1}));
 Vz=reshape(Vz,size(gridz{1}));

end

