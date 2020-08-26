%Looking at the relative error between the FEM and the analytic solution
%for some simple cases to determine which mesh is optimal. Have to use all
%the values that have been already sorted according to r in the mplotradial
%script.
%Have to take the transpose of pmonds and gmonds to be the same size as
%potentialshalf and valueaccleshalf.

poterr = abs((potentialshalf - pmonds')./pmonds');
gerr = abs((valueaccelshalf - gmonds')./gmonds');

%Plotting the potential against the radial distance
figure
subplot(2,1,1)
title('Gravitational Potential Error');
plot(rsort,poterr,'r');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*masstot/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('φ');
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
hold off;

subplot(2,1,2)
title('Gravitational Acceleration Error');
plot(rsort,gerr,'r');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*masstot/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('φ');
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
hold off;
