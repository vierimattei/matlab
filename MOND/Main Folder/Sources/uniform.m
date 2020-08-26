function source = uniform(location,state)
%Sphere of uniform mass density of radius "radiustot"

msystemdim

source = -a*heaviside(radiustot - sqrt(location.x.^2+location.y.^2+location.z.^2)).*...
                                (4*pi*G*mass./(volumeout));

end

