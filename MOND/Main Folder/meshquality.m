%IMPORTANT: MESH QUALITY CAN ALSO BE ESTABLISHED BY USING THE MESHQUALITY
%COMMAND FROM MATLAB.

%Establishing the quality of the mesh
%The quality of each tetrahedron can be given as the ratio of the
%circumscribed and incribed spheres. Optimal value is 3, which is for a
%regular tetrahedron, so scaled optimal value is 1.

elqualmax = max(elqual);
elqualmin = min(elqual);
elqualav = mean(elqual);

fprintf('Average element quality is: %1.2f \n',elqualav);

%Finding elements that have a quality factor higher than an arbitrary
%threshold (defined in msystemdim), higher quality factor=worse quality. 1s
%give bad elements, 0s give good elements
badqual = elqual<meshtresh;

%Finding the indices corresponding to the non-zero elements, a.k.a bad
%quality elements. Then their total number and the proportion with total
%elements
badels = find(badqual);
nbadels = length(badels);
dbadels = nbadels/nelems;

%Plotting the quality of the mesh as a 3D scatter in the center of each
%element, on top of the PDE Mesh. Also plotting the bad elements (badels)
%ina different color.

figure
pdemesh(tmodel,'FaceAlpha',0.3,'FaceColor','b');
hold on
pdemesh(nodes,elements(:,badels),'FaceAlpha',0.3,'FaceColor','r');
% scatter3(xin,yin,zin,100*elqual,100*elqual,'.');
colorbar;
caxis([0 elqualmax]); %Setting limits of the colorbar
title('Mesh Quality');
hold off

figure
histedges = [linspace(0,1,51)];
histogram(elqual,histedges);  
title('Mesh Quality');

%Plotting the mesh size radially. A value of 1 corresponds to a perfectly
%regular tetrahedron, hence the highest mesh quality. Lower values
%corresponds to worse quality elements.

figure
title('Radial Mesh Quality');
scatter(rins,(elquals),'r','.');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*mass/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('Mesh Quality');
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
title('Radial Mesh Quality');
hold off;
