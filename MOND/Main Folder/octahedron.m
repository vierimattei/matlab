function Voct = octahedron(Vsingle)
%This function takes as input the potential for a single mass displaced
%from the origin, produces the potential caused by identical masses placed on the
%vertices of an octahedron around the origin.

%Pre-allocating 3*size(Vsingle) array to hold 3 potentials in the same xy
%plane as Vsingle.
Vplane = zeros([3,size(Vsingle)]);
Vplanetot = zeros(size(Vsingle));

%Generating the other 3 potentials from the xy plane
V2 = rot90(Vsingle,1);
V3 = rot90(Vsingle,2);
V4 = rot90(Vsingle,3);

%Potential above the xy plane obtained by permuting the X(2nd, not 1st!)  and Z (3rd) components
%of the potential
V5 = permute(Vsingle, [1 3 2]);

%Flipping V5 in the z direction (3rd component) to obtain the potential on the other side
%of the xy plane.
V6 = flip(V5,3);

% Adding up all the contributions to get the total potential
Voct = Vsingle + V2 + V3 + V4 + V5 + V6;