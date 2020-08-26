function guess = gnewt(location)
%Sphere of uniform mass density of radius "radiustot"

msystemdim

guess = -G*mass./sqrt(location.x.^2 + location.y.^2 + location.z.^2);

end

