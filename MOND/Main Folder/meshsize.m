%Volume computes the volume of each element in the mesh, stores the total
%in vtot and the individual volumes in the Nel length vector vel, Nel =
%#elements.
[vtot,vel] = volume(tmesh);

%Sorting the volumes according to the distance of radius of their incenter.
[rinsort,velsort] = sortdist(rin,vel);
velmax = max(vel);

%Setting thresholds for size of big/small elements in relation to the
%largest volume element in the mesh. vtresl for low, vtresh for high.
vtresl = 10;
vtresh = 2;

%Finding elements above/below size thresholds
smallel = vel<velmax/vtresl;
bigel   = vel>velmax/vtresh;

%Finding the indices corresponding to the non-zero elements, a.k.a big/small 
%elements. Then their total number and the proportion with total elements
smallones = find(smallel);
bigones = find(bigel);

nsmallones = length(smallones);
nbigones = length(bigones);

psmalls = nbigones/nelems;
pbigs   = nsmallones/nelems;

%Histogram of the element sizes
figure
histogram(vel);  
title('Element Volume');

%Radial plot of the elementsizes
figure
title('Radial Element Volume');
scatter(rins,(velsort),'r','.');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*mass/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('Element Volume');
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
hold off;

%Plot elements smaller (or bigger than a certain amount on top of the mesh.
figure
pdemesh(tmodel,'FaceAlpha',0.3,'FaceColor','w');
hold on
pdemesh(nodes,elements(:,smallones),'FaceAlpha',0.5,'FaceColor','k');
pdemesh(nodes,elements(:,bigones),'FaceAlpha',0.2,'FaceColor','r');

% scatter3(xin,yin,zin,elqual,elqual,'.');
% colorbar;
% caxis([1 elqualmax]); %Setting limits of the colorbar
% title('Mesh Quality');
hold off


