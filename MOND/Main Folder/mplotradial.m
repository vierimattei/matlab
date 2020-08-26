%To be able to plot rather than scatter, we sort r in ascending order and
%reorder all functions accordingly. First we define all the functions we
%need.

%Defining the potential inside and outside a uniform spherical mass
%distribution using the Heaviside function. Also defining the MOND
%potential outside the mass distribution.
pninandout = heaviside(r-radiustot).*(-G*mass./r) + (1-heaviside(r-radiustot)).*(r.^2-3*radiustot^2)*(G*mass/(2*radiustot^3));
pmond = sqrt(G*mass*a).*log(r);
pminandout = heaviside(r-radiustot).*sqrt(G*mass*a).*log(r) + (1-heaviside(r-radiustot)).*(4/3*sqrt(pi/3*a*G*mass/volumeout).*r.^(3/2)+sqrt(G*mass*a).*log(radiustot)-4/3*sqrt(pi/3*a*G*mass/volumeout).*radiustot.^(3/2));
pmond = pminandout;
piso = 1/3*sqrt(G*mass*a/6)*log(1+r.^(3/2)/(mass/volumeout)^(3/2));

%Defining gravitational acceleration for potential (inside and outside), 
%for MOND inside and constant a_0
gninandout = heaviside(r-radiustot).*(G*mass./(r.^2)) + (1-heaviside(r-radiustot)).*(G*mass/radiustot^3*r);
gmond = sqrt(G*mass*a).*(1./r);
gminandout = heaviside(r-radiustot).*sqrt(G*mass*a).*(1./r) + (1-heaviside(r-radiustot)).*4/3*sqrt(pi/3*a*G*mass/volumeout)*3/2.*sqrt(r);
gmond = gminandout;
gconst = ones(1,size(r,2))'*a;

%Doing the same for the velocities
vninandout = heaviside(r-radiustot).*(sqrt(G*mass./r)) + (1-heaviside(r-radiustot)).*sqrt(G*mass/radiustot^3*r.^2);
vmond = ones(1,size(r,2)).*(G*mass*a)^(1/4);
vminandout = heaviside(r-radiustot).* ones(1,size(r,2)).*(G*mass*a)^(1/4); + (1-heaviside(r-radiustot)).*sqrt(4/3*sqrt(pi/3*a*G*mass/volumeout)*3/2.*r.^(3/2));
vminandout = sqrt(gminandout.*r);
vmond = vminandout;
vconst = (sqrt(a*r));

%Defining the source used (HANDLETOPLOT CURRENTLY DOESNT WORK, NEED TO FIX
%IT).

% %The following lists have to be in the correct order!
% %Quantitites to be sorted with the sortdist function. r always has to be
% %first input.
% unsorted = [r,potentialhalf,pmond,pninandout,piso,valueaccelhalf,gninandout,gmond,gconst,rotationhalf,vninandout,vmond,vconst];
% 
% %Array in which to store the sorted output from the sortdist function.
% sorted = [rsort,potentialshalf,pmonds,pninandouts,pisos,valueaccelshalf,gninandouts,gmonds,gconsts,rotationshalf,vninandouts,vmonds,vconsts];

[rsort,potentialshalf,pmonds,pninandouts,pisos,valueaccelshalf,gninandouts,gmonds,gconsts,rotationshalf,vninandouts,vmonds,vconsts]...
 = sortdist(r,potentialhalf,pmond,pninandout,piso,valueaccelhalf,gninandout,gmond,gconst,rotationhalf,vninandout,vmond,vconst);

% plotsource = handletoplot(source);
% scatter(r,plotsource(r));

%Defining size and position of plot insets


%Plotting the potential against the radial distance
figure
subplot(2,2,1)
title('Gravitational Potential');
%As MOND and Newton potentials are offset but have similar magnitude, it's
%better to plot them with two different y axes
yyaxis left;
plot(rsort,potentialshalf,'r');
hold on
% plot(rsort,potentials,'c-');
plot(rsort,pmonds,'b-');
% plot(rsort,pisos,'c-');
% ylim([1.48,1.64]*10^12);
yyaxis right;
plot(rsort,pninandouts,'g-');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*mass/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('φ');
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
legend('MOND(1/4)','MOND(1/2)','MOND(Analytic)','Newton(Isothermal)');
axes('Position',[0.25,0.25,0.5,0.5]);
hold off;


%Plotting the gravitational acceleration against the radial distance
subplot(2,2,2)
plot(rsort,valueaccelshalf,'r');
hold on
% plot(rsort,valueaccels,'c');
plot(rsort,gmonds,'b-');
plot(rsort,gninandouts,'g-');
plot(rsort,gconsts,'c-');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*mass/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('g--');
ylim([0,1.2*10^(-9)]);
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
legend('MOND(1/4)','MOND(1/2)','MOND(Analytic)','Newton(Analytic)');
title('Gravitational Acceleration');
hold off;


%Plotting the rotation curves against the radial distance
subplot(2,2,[3,4])
title('Rotation Velocity');
% plot(rsort,rotations,'r');
hold on
plot(rsort,rotationshalf,'r');
% plot(rsort,rotations,'c');
plot(rsort,vmonds,'b-');
plot(rsort,vninandouts,'g-');
xline(radiustot,'-.','R_{tot}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xline(sqrt(G*mass/a),'-.','g_{N}=g_{M}','LineWidth',1,'LabelHorizontalAlignment','center','LabelVerticalAlignment','bottom');
xlabel('Radial Distance (kpc)');
ylabel('v');
xticks(0:domainsize/10:domainsize);
xticklabels({0:domainsize/(10*kp):domainsize/kp});
xlim([0,domainsize]);
legend('MOND(1/4)','MOND(1/2)','MOND(Analytic)','Newton(Analytic)');
hold off
