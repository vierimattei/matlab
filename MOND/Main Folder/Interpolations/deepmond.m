function interpolation = deepmond(location,state)
%Sphere of uniform mass density of radius "radiustot"

msystemdim

interpolation = sqrt(state.ux.^2 + state.uy.^2 + state.uz.^2);

end

