function guess = gdeep(location)
%Sphere of uniform mass density of radius "radiustot"

msystemdim

guess =  1/2*sqrt(mass*G*a)*log(location.x.^2 + location.y.^2 + location.z.^2)+1;

end

