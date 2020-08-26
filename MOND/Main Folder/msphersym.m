msystemdim

%%
%{
Creating the default object model, argument 1 giving the number of coupled
PDEs.
%}

model=createpde(1);

%%
%{
Defining the domain geometry in 3D. 
Multisphere can be used with a single argument, in which case it generates
a single sphere of that radius.
Multicylinder takes 2 argument for a single cylinder, radius and height.
Can change size of domain by using size.
%}

sphere=multisphere(domainsize);
cylinder=multicylinder(domainsize,domainsize/100);

%%
%{
Assigning the geometry we pick, either sphere or cylinder, to the Geometry
property of the Model object.
%}

model.Geometry=sphere;

%%
%{
Generating a default mesh for the domain picked. Defining all the mesh
properties through generateMesh. Appending an f to each property name and
defining its numerical value.
%}

%{
hgradf gives the max size difference between two adjacent elements, and
1<hgradf<2.hmaxf gives the maximum size of each element, hmin the minimum
size.
%}

hgradf = 2;
hmaxf = domainsize/resolutionmax;
hminf = domainsize/resolutionmin;

%{
Default interpolation between points is quadratic, so a point at each 
vertex + 1 inbetween each pair of vertices. Have to change to linear as 
that is what we used for the FEM in class (can decide to experiment with 
quadratic later).
%}

points = 'quadratic';

fprintf('Generating Mesh...');

%Taking the time of the start to determine how long the whole script takes.
%Then taking the time taken by each sub-section
initialt = tic;
tic

generateMesh(model,...
            'GeometricOrder',points,...
            'Hgrad',hgradf,...
            'Hmax',hmaxf,...
            'Hmin',hminf);

mesht = toc;
fprintf('Mesh Generated in %e s \n \n', mesht);        
        
%{
Assigning the coordinates of each node to a variable, in x,y,z directions.
The function AP3001 uses p,e,t. p gives the (x,y) coordinates of the mesh
points; e gives the mesh edges and t the mesh triangles.
In 3D it's not triangles but tetrahedra (pyramids). 
model.Mesh.Nodes gives the coordinates (x,y,z) of the mesh points. x, y and
z are ROW vectors. Also defining the radial distance.
%}

[nodes,r,nodesort,rsort,elements,elsort] = sortelements(model);

x = nodes(1,:);
y = nodes(1,:);
z = nodes(1,:);

%Coordinates sorted according to radial distance
xsort = nodesort(1,:);
ysort = nodesort(1,:);
zsort = nodesort(1,:);

%%
%{
Directly giving the PDE to be solved by specifying the coefficients
from the general formulation given for specifyCoefficients(). Coefficients
are:
m (d^2φ/dt^2) + d (dφ/dt) - Div[c Grad(φ)] + a (φ) = f
where φ is the variable to solve for and f a source term.
We can use non-constant coefficients for any of these (we're interested in
c and f for Newton and MOND). To do so, we need a function handle, that can
contain both coordinates (x,y,z), the function φ and its partial
derivatives. Function must be called with handle of type, e.g.:
function(location,state)
location and state are objects:
location is for coordinates, e.g.
location.x is the same as x
state is for the function, e.g.
state.u is the same as u;
state.ux is the same as du/dx 
As a source we pick a uniform distribution inside the sun, 0 outside.
%}
      
thickness = 0.2;
radiusin = radiustot*thickness;

%Total volume of a shell of r=radiustot
volumeout = 4/3*pi*(radiustot^3);
%Total volume of an empty shell of other radius
volumein = 4/3*pi*((radiustot*(1-thickness))^3);
volumetot = volumeout-volumein;
            
gaussource = @(location,state) 4*pi*G*masstot*exp(-(location.x.^2+location.y.^2+location.z.^2)/(density*radiustot)^2);

testinside = @(location,state)  (heaviside(radiustot - sqrt(location.x.^2+location.y.^2+location.z.^2)).*...
                                (4*pi*G*masstot./(4/3*pi*(sqrt(location.x.^2+location.y.^2+location.z.^2)).^3)));                            
                                
uniform = @(location,state)     -a*heaviside(radiustot - sqrt(location.x.^2+location.y.^2+location.z.^2)).*...
                                (4*pi*G*masstot./(volumeout));
                            
unishell = @(location,state)     -a*(heaviside(sqrt(location.x.^2+location.y.^2+location.z.^2)-0.8*radiustot)-...
                                     heaviside(sqrt(location.x.^2+location.y.^2+location.z.^2)-radiustot)).*...
                                (4*pi*G*masstot./(volumetot));    
                            
multiple = @(location,state)     -a*(heaviside(0.5*radiustot-sqrt(location.x.^2+location.y.^2+location.z.^2 - 0.25*radiustot^2))-...
                                     heaviside(0.5*radiustot-sqrt(location.x.^2+location.y.^2+location.z.^2 + 0.25*radiustot^2))).*...
                                (4*pi*G*masstot./(volume));     

%Finding the closest point to the origin that has a mesh point on it
origin = min(r);                            

%Analytic approximations of the dirac delta: https://mathworld.wolfram.com/DeltaFunction.html

dirac = @(location,state)       -a*4*pi*G*masstot*dirac(sqrt(location.x.^2+location.y.^2+location.z.^2)-origin);  
                            
source = @gaussourcesing;

%%
%Interpolation Functions

deepmond = @(location,state) sqrt(state.ux.^2 + state.uy.^2 + state.uz.^2);

testmond = @(location,state) -location.x;

interpolation = deepmond;

fprintf('Specifying coefficients...');
tic

%To avoid numerical instability (such as a reciprocal condition number
%close to 0), it is best to move all numerical coefficients from the c
%coefficient to the f coefficient. Did it with a.

coeffs = specifyCoefficients(model, ...
    'm',0,...
    'd',0,...
    'c',interpolation,...
    'a',0,...
    'f',@fcoeffunction);
coefft = toc;
fprintf('Coefficients done in %e s. \n \n',coefft);

%%
%BOUNDARY CONDITIONS
%{
Specifying the boundary condition for the problem. We want a Dirichlet 
boundary condition: φ=0 on the boundary. We specify the type (dirichlet,
Face since we're in 3D (in 2D it's Edge), 1 meaning the 1st face (only one
face in e.g. sphere).
Standard format for Dirichlet is: hφ=r.
If r is not specified, it defaults to 0. If h is not specified, it defaults
to 1.
To define non-constant B.C., need to use function(location,state) as for
the coefficients explained above.
%}

mondconst = 1/2*sqrt(masstot*G*a)*log(domainsize);

newtcond = @(location,state) -G*masstot./sqrt(location.x.^2 + location.y.^2 + location.z.^2);

deepcond = @(location,state) 1/2*sqrt(masstot*G*a)*log(location.x.^2 + location.y.^2 + location.z.^2);
 
thebound = deepcond;


fprintf('Applying Boundary Conditions...');
tic

bounds = applyBoundaryCondition(model, ...
    'dirichlet',...
    'Face',...
    1,...
    'r',...
    thebound);

boundt = toc;
fprintf('Boundary Conditions done in %e s. \n \n', boundt);

%%
%The initial guess for the non-linear solver is given from the
%SetInitialConditions option

gdeep = @(location)1/2*sqrt(masstot*G*a)*log(location.x.^2 + location.y.^2 + location.z.^2);

gnewt = @(location) -G*masstot./sqrt(location.x.^2 + location.y.^2 + location.z.^2);

gconst = 1/2*sqrt(masstot*G*a)*log(domainsize);

guess = setInitialConditions(model,...
        gconst);

%Other options for the non-linear solver are the minimum step size and
%maximum iterations. It is best to keep track of each iteration of the
%solver from the ReportStatistics option (see below), and tweak the
%#iterations and step size accordingly.
    
model.SolverOptions.MinStep = 0;

%As solver always gets stuck on the same value of the residual, which is
%3 orders of magnitude smaller than value of the solution, we set the
%residual tolerance to that and see what solution comes out.

model.SolverOptions.ResidualTolerance = 4.2e8;

%%
%{
Viewing the generated 3D mesh on the domain picked. 
%}

meshmod = pdemesh(model,'FaceAlpha',0.5);

%%
%{
Obtaining the solution to the PDE and storing the StationaryResult object
into the object solution. 
The potential is given in solution.NodalSolution as a 1 by Nn vector of its
value at each point of the mesh, with Nn the #nodes.
The acceleration is a vector, and is given as a 3 by Nn vector, with its 
magnitude in the directions (x,y,z).
%}

%Allowing the Non-linear solver to give information during solution
model.SolverOptions.ReportStatistics = 'on';

fprintf('Solving PDE... \n');
tic

solutionhalf = solvepde(model);

solvet = toc;
fprintf('PDE Solved in %e s. \n \n', solvet);

potentialhalf = solutionhalf.NodalSolution;
accelerationhalf = [solutionhalf.XGradients, solutionhalf.YGradients, solutionhalf.ZGradients];

%Magnitude of the acceleration against the radial distance

valueaccelhalf = sqrt(accelerationhalf(:,1).^2+accelerationhalf(:,2).^2+accelerationhalf(:,3).^2);

%Rotation velocity, have to transpose r cause it's a row vector and
%valueaccel a coluimn

rotationhalf = sqrt(valueaccelhalf.*r');

%{
Plotting the potential as a colormap and the acceleration as a quiver plot.
%}

%{
pdeplot3D(model,'ColorMapData',potential);
hold on
pdeplot3D(model,'FlowData',acceleration);
hold off
%}
 

%%
%{
Plotting the value of the potential against r, as well as the acceleration.
%}

% plotsource

fprintf('Plotting Result...');
tic

plotsolution

plot3t = toc;
fprintf('3D Plotted in %e s. \n \n', plot3t);

tic

mplotradial

plotrt = toc;
fprintf('Radial Plotted in %e s. \n \n', plotrt);

%Printing the total time from the initial tic
endt = toc(initialt);
fprintf('Total time taken: %e s. \n \n', endt);