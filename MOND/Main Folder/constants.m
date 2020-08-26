G = 6.674*10^(-11); %Newton's constant;
a = 1.2*10^(-10); %Milgrom's a0 constant;
ms = 1.989*10^30; %mass of the sun in kg;
mgd = 10^12*ms; %mass of dark matter in the milky way in kg;
mgb = 1.1*6.6*10^10*ms; %baryonic mass of milky way, 5.5 for stars, 1.1 as extra 10% given by gas+dust (Wikipedia);
ly = 9.461*10^15; %light year in meters;
kp = 3261.56*ly; %Kiloparsec in*lightyears;
kpm = 20*kp; %Distance from Mroz Paper measured to which Milky rotation is flat
au = 0.0000158*ly; %Earth-sun distance (Astronomical unit A.U.);
lst = 200*au; %Heliopause and end of the scattered disk
lsu = 50*au; %Kuiper cliff, planet density drops
lg = 52850*ly; %Radius of Milky Way stellar disk;
lgu = 40*10^3*ly; %Distance at which star density drops in Milky Way
lgb = 3*kp; %Approximate size of bulge of Milky from Wikipedia
rs = 0.00465*au; %Radius of the sun

%Data from the paper of McGaugh of 2008 for the model of the Milky way
sd = 1480*ms/(kp/1000)^2; %central surface density for the bulge
rd = 2.3*kp; %scale length for central surface density
mdisk = 4.22*10^10*ms; %total mass for the star disk 
mbulge = 0.67*10^10*ms; %Total mass in the central bulge
mgas = 1.18*10^10*ms; %Total mass in the gas ring
