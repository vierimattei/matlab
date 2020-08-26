%Finding the elements whcih contain the source.
%First thing to do is find all points in the mesh that lie inside the
%radius of the mass distribution.

%IMPORTANT: THIS COULD ALSO BE DONE USING THE FINDELEMETNS FUCNTION FROM
%MATLAB. FOR THE CASE OF ONLY ONE SOURCE IT DOESNT HELP MUCH, BUT FOR
%MULTIPLE SOURCES IT IS NICE SINCE IT ALLOWS TO SPLECIFY CENTER AND RADIUS
%FOR AN ARBITRARY AMOUNT OF SPHERES!

%isinside is a vector containing ones for the vertices inside the mass
%distribution. NOTE: these are not ordered by radius
isinside = r<radiustot;

%total # of points inside mass distribution is 
inpoints = nnz(isinside);

%Obtaining indices that are non-zero in the isinside vector, to find the
%corresponding vertices
insideind = find(isinside);
insideind = insideind'; %Need column vector for vertexAttachments

%vertexAttachments returns the IDs of each element connected to the vertex
%given (in our case all vertices inside the mass distribution) and puts
%them in a cell array of Nv cells where Nv = # vertices, each containing a
%row vector with Ne components, with Ne = # elements that include that
%vertex.
elinside = vertexAttachments(tri,insideind);

%elinsidov gives a cell array, each cell is accessed as elinsideov{i} and
%it's a row vector, so by doing [elinsideov{:}] we put all elements of all
%cells into one unique vector that can index the elements inside the mass.
elinside = [elinside{:}];  

%As an element has more than one vertex, there will be repeated entries in
%elinside. To remove them, we use unique. They are now also sorted in
%increasing order, but this can be avoided by using 'stable' after elinside
unelinside = unique(elinside);

%Finding the volumes of all elements inside mass and putting them in a
%vector the same size as elinside. 
volinside = elvol(unelinside);

%tvolinside is the total volume of the elements that fall into the mass,
%using the sum() command it's the sum of all elements in tvolinside. Volratio 
%is the ratio of actual volume to the total element volume.
tvolinside = sum(volinside);
volratio = tvolinside/volumeout;

%Plotting the elements inside the mass distribution alongside the mass
%distribution volume to check
pdemesh(nodes,elements(:,unelinside),'FaceAlpha',0.3);

hold on
[sx,sy,sz] = sphere(10);
sx = sx*radiustot;
sy = sy*radiustot;
sz = sz*radiustot;
surf(sx,sy,sz,'FaceAlpha',0.7,'FaceColor','r');

%NEXT THINGS TO DO: CALCULATE THE TOTAL VOLUME OF THE OVERALL TETRAHEDRA
%ENCLOSING THE MASS AND THE TOTAL # OF TETRAHEDRA (MIGHT BE SOME REPEATED
%ONES IN THE ARRAY)