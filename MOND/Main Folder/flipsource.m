function Vflip = flipsource(V,ax,ay,az)
%This function takes as an input a quantity defined on a grid and mirrors
%it w.r.t. the plane of choice. ax mirrors the x component (flips w.r.t. yz
%plane), ay the y component, az the z component. ax,ay,az have to be given
%as 1 or 0, representing the axis to be flipped. NOTE: The order of
%flipping is x,y,z.

if (ax~=1 & ax~=0) | (ay~=1 & ay~=0) | (az~=1 & az~=0) 

   errmess = 'ax,ay,az have to be either 0 (no flip along the axis) or 1 (flip along the axis)';
   error(errmess);
  
end

%IMPORTANT: The array used for the 3D grid is NOT set up as (X,Y,Z) but it is setup as (Y,X,Z)! 
%Hence, to flip the x values we need to flip the 2nd dimension, for y the
%1st, for z the 3rd!


%Flipping the x values
if ax == 1
Vflip = flip(V,2);
end

%Flipping the y values
if ay == 1
Vflip = flip(V,1);
end 


%Flipping the z values
if az == 1
Vflip = flip(V,3);
end

