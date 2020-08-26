function boundary = deepcond(location,state)
%Sphere of uniform mass density of radius "radiustot"

msystemdim

boundary =  1/2*sqrt(massoverall*G*a)*log(location.x.^2 + location.y.^2 + location.z.^2);

end

