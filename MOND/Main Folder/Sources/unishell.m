function source = unishell(location,state)
%Shell of uniform density

msystemdim

source = -a*(heaviside(sqrt(location.x.^2+location.y.^2+location.z.^2)-0.8*radiustot)-...
            heaviside(sqrt(location.x.^2+location.y.^2+location.z.^2)-radiustot)).*...
            (4*pi*G*masstot./(volumetot)); 

end

