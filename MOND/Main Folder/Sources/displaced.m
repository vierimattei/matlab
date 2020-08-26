function source = displaced(location,state)
%Same as uniform but displaced in the x direction.

msystemdim

source = -a*heaviside(radiustot - sqrt((location.x-displacement).^2+location.y.^2+location.z.^2)).*...
          (4*pi*G*mass./(volumeout));

end

