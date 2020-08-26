function [thesource] = plotsource(source,position)
%FUnction takes as an input the handle for the source term of the PDE and
%the position struct that mimics the location struct used by the PDE
%solver, although it can be used outside of the PDE object. No outputs are
%given, and a 3D scatter plot is produced representing the source term.

msystemdim;

%Tick sizes and labels for the plots
tickall = linspace(-domainsize,domainsize,11);
labell = linspace(-domainsize/kp,domainsize/kp,11);


thesource = -1/a*source(position,0);

toplot = thesource;
toplot(toplot==0) = NaN;

figure
scatter3(position.x,position.y,position.z, 100, toplot, '.');
xlabel('x (kpc)')
ylabel('y (kpc)')
zlabel('z (kpc)')
xticks(tickall);
yticks(tickall);
zticks(tickall);
xticklabels(labell);
yticklabels(labell);
zticklabels(labell);

bottom = min(thesource);
top = max(thesource);
    
colormap jet
colorbar

caxis([bottom,top]);

end

