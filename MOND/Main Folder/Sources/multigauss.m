function source = multigauss(location,state)

msystemdim

%Making a struct for the source, including the location of it (the median
%mu), its standard deviation standev. To displace the distribution 
%arbitrarily we need the mean around x,y and z separately. To allow for
%arbitrary #sources, we make each mean a vector to define each source
%independently.
onegauss.mu.x = zeros(1,sourcenum);
onegauss.mu.y = zeros(1,sourcenum);
onegauss.mu.z = zeros(1,sourcenum);

center.x = zeros(1,sourcenum);
center.x = zeros(1,sourcenum);
center.x = zeros(1,sourcenum);

%Uaing the 3 sigma rule, 68% of distribution (mass in this case) is one
%sigma away from the mean. 95% is within 2 sigmas, 99.7% withing 3 sigmas.
%To reproduce the density of a sphere of radius r=radiustot we then want
%sigma = radiustot/3 so 99.7% of mass is within r=radiustot. We want the
%same standard deviation in all direction (so power 3) cause we want a
%sphere.
onegauss.standev =  radiustot*3;

%Giving the expression for the normalised normal standard distribution
%(with integral of 1, so we only have to multiply it by the mass itself and
%4*pi*G to get correct total mass)

    
source = -a*4*pi*G*mass*1/(onegauss.standev*sqrt(2*pi))^3*...
           (exp(-1/2*((location.x-sourceloc.x(1)).^2+(location.y-sourceloc.y(1)).^2 ...
           +(location.z-sourceloc.z(1)).^2)/(onegauss.standev^2))+...
           (exp(-1/2*((location.x-sourceloc.x(2)).^2+(location.y-sourceloc.y(2)).^2 ...
           +(location.z-sourceloc.z(2)).^2)/(onegauss.standev^2))+...
           (exp(-1/2*((location.x-sourceloc.x(3)).^2+(location.y-sourceloc.y(3)).^2 ...
           +(location.z-sourceloc.z(3)).^2)/(onegauss.standev^2))+...
           (exp(-1/2*((location.x-sourceloc.x(4)).^2+(location.y-sourceloc.y(4)).^2 ...
           +(location.z-sourceloc.z(4)).^2)/(onegauss.standev^2))+...
           (exp(-1/2*((location.x-sourceloc.x(5)).^2+(location.y-sourceloc.y(5)).^2 ...
           +(location.z-sourceloc.z(5)).^2)/(onegauss.standev^2))+...
           (exp(-1/2*((location.x-sourceloc.x(6)).^2+(location.y-sourceloc.y(6)).^2 ...
           +(location.z-sourceloc.z(6)).^2)/(onegauss.standev^2))))))));

