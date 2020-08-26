msystemdim

%%
%{
Creating the default object tmodel, argument 1 giving the number of coupled
PDEs.
%}
initialt = tic;

tmodel=createpde(1);

fprintf('Generating Mesh...');

meshadaptive;
% tmodel.Mesh.GeometricOrder = 'quadratic';

mesht = toc;
fprintf('Mesh Generated in %e s \n \n', mesht);        
        
%{
Assigning the coordinates of each node to a variable, in x,y,z directions.
The function AP3001 uses p,e,t. p gives the (x,y) coordinates of the mesh
points; e gives the mesh edges and t the mesh triangles.
In 3D it's not triangles but tetrahedra (pyramids). 
tmodel.Mesh.Nodes gives the coordinates (x,y,z) of the mesh points. x, y and
z are ROW vectors. Also defining the radial distance.
%}

%IMPORTANT: There was a typo here setting x,y and z all to nodes(1,:) so
%they are all the same! Some results have this and hence give the wrong
%result if you try to plot the solution with scatter3!
x = nodes(1,:);
y = nodes(2,:);
z = nodes(3,:);

%Defining the struct position with the same structure as location (.x, .y,
%.z) so we can utilise information on the source by calling the source
%function directly;
position.x = x;
position.y = y;
position.z = z;

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
location and state are structs:
location is for coordinates, e.g.
location.x is the same as x
state is for the function, e.g.
state.u is the same as u;
state.ux is the same as du/dx 
As a source we can pick a uniform distribution inside the sun, 0 outside.
%}                               

%Finding the closest point to the origin that has a mesh point on it
origin = min(r);                            

%Analytic approximations of the dirac delta: https://mathworld.wolfram.com/DeltaFunction.html
                            
source = @multigauss;

%%
%Interpolation Functions

interpolation = @deepmond;

fprintf('Specifying coefficients...');
tic

%To avoid numerical instability (such as a reciprocal condition number
%close to 0), it is best to move all numerical coefficients from the c
%coefficient to the f coefficient. Did it with a.

coeffs = specifyCoefficients(tmodel, ...
    'm',0,...
    'd',0,...
    'c',interpolation,...
    'a',0,...
    'f',source);
coefft = toc;
fprintf('Coefficients done in %e s. \n \n',coefft);

%%
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

%For the boundary conditions we always need to use the overall mass
%"massoverall", not the mass of the individual sources "mass"!
mondconst = 1/2*sqrt(massoverall*G*a)*log(domainsize);

%Assigning the boundary condition function
thebound = @deepcond;

fprintf('Applying Boundary Conditions...');
tic

bounds = applyBoundaryCondition(tmodel, ...
    'dirichlet',...
    'Face',...
    1,...
    'r',...
    thebound);

boundt = toc;
fprintf('Boundary Conditions done in %e s. \n \n', boundt);

%%
%The initial guess for the non-linear solver is given from the
%SetInitialConditions option. Also here the initil guess has to use the
%total mass "massoverall", not the individual mass "mass".

gconst = 1/2*sqrt(mass*G*a)*log(domainsize);

guess = setInitialConditions(tmodel,...
        gconst);

%Other options for the non-linear solver are the minimum step size and
%maximum iterations. It is best to keep track of each iteration of the
%solver from the ReportStatistics option (see below), and tweak the
%#iterations and step size accordingly.
    
tmodel.SolverOptions.MinStep = 0;

%As solver always gets stuck on the same value of the residual, which is
%3 orders of magnitude smaller than value of the solution, we set the
%residual tolerance to that and see what solution comes out.

tmodel.SolverOptions.ResidualTolerance = 2.7e9;

%%
%{
Viewing the generated 3D mesh on the domain picked. 
%}

% meshmod = pdemesh(tmodel,'FaceAlpha',0.5);

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
tmodel.SolverOptions.ReportStatistics = 'on';

fprintf('Solving PDE... \n');
tic

solutionhalf = solvepde(tmodel);

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
pdeplot3D(tmodel,'ColorMapData',potentialhalf);
hold on
pdeplot3D(tmodel,'FlowData',accelerationhalf);
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