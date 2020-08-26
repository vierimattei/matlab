msystemdim

contint = tic;

%Making the grid cover the domain in all direction. zgridder is the grid
%used for the zoomed in graph, gridding is the function I defined, takes no
%input

fprintf('Making %d by %d by %d grid... \n', domainfine,domainfine,domainfine);

[gridn,gridz] = gridding();

gridt = toc(contint);

fprintf('Making the grid took %e s... \n', gridt);

%Interpolating the solution at all the points defined by the grid. Vz is
%solution interpolated over the zoomed in region

fprintf('Interpolating solution... \n');
tic

%Interpolation takes the vast majority of the computation time, so we only
%do it if we changed the size of the grid and want to plot with a
%different resolution (higher one, for lower makes no sense to redo the
%computation and get a less accurate result)

if exist('V','var') & exist('Vz','var')
    
    if ~isequal(size(V),size(gridn{1})) | ~isequal(size(Vz),size(gridz{1}))

       [V,Vz] = intershape(solutionhalf,gridn,gridz);

    end

else
    
    [V,Vz] = intershape(solutionhalf,gridn,gridz);

end

%Interpolating the solutions from the configuration with only one mass.

if exist('Vleft','var') & exist('Vleftz','var')
    
    if ~isequal(size(Vleft),size(gridn{1})) | ~isequal(size(Vleftz),size(gridz{1}))

       [Vleft,Vleftz] = intershape(solleft,gridn,gridz);

    end

else
    
    [Vleft,Vleftz] = intershape(solleft,gridn,gridz);

end

interpt = toc;

fprintf('Solution interpolated in %e s \n', interpt);

%Reshaping the solution vector so it's the same size as the coordinates of
%the grid, so a (50,50,50) array. Reshaping also for zoomed versions

fprintf('Reshaping solutions... \n');
tic

%Defining the potential sum of single charges to compare the nonlinearity
Vcomp = octahedron(Vleft);
Vcompz = octahedron(Vleftz);

%Computing the difference between the two potentials, both for the whole
%domaina nd zoomed case
Vdiff  = V - Vcomp;
Vdiffz = Vz - Vcompz;

resht = toc;
fprintf('Solutions reshaped in %e s \n',resht);

fprintf('Plotting the contours... \n');
tic

%Useful to insert a sqrt(#masses) since thw proper solution grows with
%sqrt(mass), and adding the individual ones doesnt add sqrt but the mass
%itself.
contmid(sourceloc,gridn,sqrt(6)*V,Vcomp);
contmid(sourceloc,gridz,sqrt(6)*Vz,Vcompz);
contmid(sourceloc,gridn,Vdiff);
contmid(sourceloc,gridz,Vdiffz);

%Specifying interesting values of the potential at and around which to draw
%isosurfaces, the interval around the central value and the amount to draw.
isoval    = 9.25*10^12;
isoint = 0.01;
isonum = 5;

fprintf('Plotting isosurfaces... \n');
tic

%Plotting isosurface slices for both potentials, giving them different
%colors to distinguish between them. Also have to note that the two
%potentials are offset from one another, so colormaps dont have the same
%value, hence using difference values isoval and isovaladd.

figure
isos = tiledlayout('flow');
for i = -isonum:isonum
nexttile
fprintf('Plotting isosurface %d of %d \n',i,isonum*2+1);
    if mod(i,2) == 0
        p = patch(isosurface(gridn{1},gridn{2},gridn{3},Vz,isoval*(1+isoint*i)));
        % isonormals(X,Y,Z,V,p)
        p.FaceColor = 'red';
    else
        p = patch(isosurface(gridz{1},gridz{2},gridz{3},Vcompz,isoval*(1+isoint*i)));
        % isonormals(X,Y,Z,V,p)
        p.FaceColor = 'blue';   
    end    
end

isot = toc;

fprintf('Printed isosurfaces in %e s \n...', isot);

contend = toc(contint);

fprintf('All graphs done in %e s \n', contend);