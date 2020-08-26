function boundary = newtcond(location,state)
%Sphere of uniform mass density of radius "radiustot"

msystemdim

boundary =  -G*massoverall./sqrt(location.x.^2 + location.y.^2 + location.z.^2);

end

