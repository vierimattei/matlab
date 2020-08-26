%Obtaining the grid format of the solutions from the PDE(total and single
%mass)
[gridn,gridz] = gridding();

if exist('V','var') & exist('Vz','var')
    
    if ~isequal(size(V),size(gridn{1})) | ~isequal(size(Vz),size(gridz{1}))

       [V,Vz] = intershape(solutionhalf,gridn,gridz);

    end

else
    
    [V,Vz] = intershape(solutionhalf,gridn,gridz);

end

% Contour Plot for the solution, uncomment to use

sliceall = -domainsize:domainsize/slicestot:domainsize;

% figure
% colormap jet
% contourslice(X,Y,Z,V,sliceall,sliceall,sliceall,25)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% colorbar
% axis equal

figure
contmid(sourceloc,gridn,V);

figure
contmid(sourceloc,gridz,Vz);

%Finding the Maximum value of the potential to scale the size of the dots
%in the plot according to relative value of φ.
MaxV = max(V, [], 'all');

%Plotting the 3d scatter, uncomment to use

% figure
% colormap jet
% scatter3(X(:), Y(:), Z(:), abs(ballsize*Vcomp(:)/max(Vcomp, [], 'all')), Vcomp(:),'filled')
% xlabel('x (A.U.)')
% xticks(-domainsize:domainsize/5:domainsize);
% xticklabels({-domainsize/au:domainsize/(5*au):domainsize/au});
% ylabel('y (A.U.)')
% yticks(-domainsize:domainsize/5:domainsize);
% yticklabels({-domainsize/au:domainsize/(5*au):domainsize/au});
% zlabel('z (A.U.)')
% zticks(-domainsize:domainsize/5:domainsize);
% zticklabels({-domainsize/au:domainsize/(5*au):domainsize/au});
% colorbar
% axis equal