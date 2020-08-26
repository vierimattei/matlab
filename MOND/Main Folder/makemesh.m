%Experimenting with a user defined set of points to generate the mesh.
msystemdim
tic

%For good meshes, use odd number for res, or result is really boxy
%NOTE: To improve the quality of the sphere, it's best to take a bigger
%initial cube (increase leng by a factor n) and increase the resolution accordingly (same
%factor n for res). By doing so, we can avoid the straight surfaces ad the
%6 edges of the sphere! Also, best to use res approx = 10*leng multiplier,
%so e.g. lengt = 3*domainsize -> res=29 (odd number).
res=29;
leng=3*domainsize;

%Defining the # of and distance between the points in each direction
x = linspace(-leng,leng,res);
y=x;
z=x;

%Prealloacating the array for the vertices
verts = zeros(3,size(x,2)^3);

%Setting dummy variable n=0 before loop. Formatting the coordinates in
%x,y,z into what needed for triangulation

n=0;
for i = 1:size(x,2)
    for j = 1:size(y,2)
        for k = 1:size(z,2)
            n = n+1;
            verts(:,n) = [x(i); y(j); z(k)];
        end
    end
end

%Determining the radius of each vertex
trad = sqrt(verts(1,:).^2 + verts(2,:).^2 + verts(3,:).^2);

%Radius w.r.t. displaced source
%tradisp = sqrt((verts(1,:)-sourceloc().^2 + verts(2,:).^2 + verts(3,:).^2);

%Maximum value of vertices in initial cube for scaling
tradmax = max(trad);

% Discarding points beyond certain radius, so we get a sphere
for m = 1 : size(verts,2)    
    verts(:,m) = (trad(m)/max(trad))^(3/4)*verts(:,m); %making points closer to origin more dense
    %Have to redefine the radius here after modifying it above or the
    %cutoff radius will be incorrect!
    trad(m) = sqrt(verts(1,m).^2 + verts(2,m).^2 + verts(3,m).^2);
    
    if trad(m) > domainsize & trad(m) <=  1.05*domainsize
        verts(:,m) = verts(:,m) * domainsize/trad(m); %normalising rather than discarding points outisde sphere
    
    elseif trad(m) > 1.05*domainsize
        verts(:,m) = zeros(3,1);
    end
end

%For delaunayTriangulation we need to transpose to have the right format 
verts = verts';

%Eliminating the vertices that are repeated, since we're triangulating with
%these points. This avoids the warning matlab throws about duplicate data
%points.
verts = unique(verts,'rows');

%Making the triangulation object tri
tri = delaunayTriangulation(verts);

%Obtaining the circumcenter of each element in the mesh + radius of
%circumscribed sphere. Then transposing to have same format as for model,
%and obtaining the volume of each sphere.
[circent,cirrad] = circumcenter(tri);
circent = circent';
cirrad = cirrad';
cirvol = 4*pi/3*cirrad.^3;

%Same as above but with the incenter and inscribed sphere. 
[incent,inrad] = incenter(tri);
incent = incent';
inrad = inrad';
invol = 4*pi/3*inrad.^3;

%Assigning the mesh points to verts
verts = tri.Points;
rads = sqrt(verts(:,1).^2 + verts(:,1).^2 + verts(:,3).^2);

%# vertices
nvert = size(verts,1);

%Then, the 4xNe matrix of elements addressing the points. Same for
%transposing

telems = tri.ConnectivityList;
%#elements

nelems = size(telems,1);

%Creating a PDE to test generating a geometry from the mesh just made
tmodel = createpde(1);
mymesh = geometryFromMesh(tmodel,verts',telems');

%Assigning the mesh object to tmesh. Esed e.g. to find volume of each
%element etc.
tmesh = tmodel.Mesh;

%Sorting the nodes and elements of the model
[nodes,r,nodesort,rsort,elements,elsort] = sortelements(tmodel);

%Defining the coordinates of the center of each inscribed circle to plot
xin = incent(1,:);
yin = incent(2,:);
zin = incent(3,:);
rin = sqrt(xin.^2+yin.^2+zin.^2); 

%Using the meshQuality matlab command to find the quality of each element
%in the mesh
elqual = meshQuality(tmesh);
    
%Rearranging the positions of the incentered circles centers according to
%their distance from the origin as usual
[rins,elquals] = sortdist(rin,elqual);

%**********************
%DO THE 2D SCATTER OF THE NODES TO SEE HOW THEY'RE DISTRIBUTED! 
%COORDS DONT MATTER AS THE MESH IS SPHERICALLY SYMMETRIC FOR NOW

%Plotting the geometry+mesh
figure
pdemesh(tmodel);
box on

meshtime = toc;
fprintf('Generating mesh took %e s, for %d nodes and %d elements. \n',meshtime,nvert,nelems);