clear; close all; clc;

%%% KNOWN DATA %%%
L   =   1200;   %   Spar length in mm
h   =   300;    %   Spar height (caps distance = uprights length) in mm
d   =   200;    %   Spar bay (uprights distance) in mm
t   =   1.2;    %   Skin thickness in mm
Ac  =   1500;   %   Caps cross sectional area in mm^2
hc  =   12;     %   Caps cross section side (parallel to the uprights) length in mm
Au  =   85;     %   Uprights cross sectional area in mm^2
Iu  =   2860;   %   Uprights cross section area moment of inertia with respect to axis parallel to the web in mm^4
tu  =   2.4;    %   Uprights thickness in mm
ru  =   5.8;    %   Uprights radius of gyration in mm
eu  =   5.5;    %   Uprights eccentricity (distance of the centroid) with respect to skin reference line in mm
n   =   1;      %   Type of the uprights: 1 for single stiffener, 2 for double stiffener
E   =   70;     %   Young modulus of the material in GPa
Fy  =   300;    %   Yield strength of the material in MPa
v   =   .33;    %   Poisson ratio of the material
Ftu =   420;    %   Ultimate tensile strength of the material in MPa
S   =   50;     %   Shear force applied to the spar in kN

%%% CRITICAL SHEAR STRESS FOR THE WEB %%%
E = E * 1e+3;
M = readmatrix('DATA_sheets.xlsx', 'Sheet', 'ks_ss');
ks = XYdiag(M, h/d);
Fs = ks * pi^2 * E / (12*(1-v^2)) * (t/d)^2;
disp(['Critical shear stress for the web Fs = ' num2str(Fs) ' MPa'])

%%% AVERAGE SHEAR STRESS IN THE WEB %%%
S = S * 1e+3;
fs = S / (h*t);
disp(['Average shear stress in the web fs = ' num2str(fs) ' MPa'])

%%% DIAGONAL TENSION FACTOR %%%
M = readmatrix('DATA_sheets.xlsx', 'Sheet', 'k');
k = XYdiag(M, fs/Fs);
disp(['Diagonal tension factor k = ' num2str(k)])

%%% UPRIGHT EFFECTIVE CROSS SECTIONAL AREA %%%
e = eu + t/2;
Aue = Au / (1+(e/ru)^2);

%%% UPRIGHT VERIFICATION %%%
disp(' ')
disp('Uprights verification:')

M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'fu_fs');
fu_fs = linediag3(M, k, Aue/(d*t), 3);
fu = fu_fs * fs;
fuav = fu * Aue / Au;
disp(['Average compressive strength fuav = ' num2str(fuav) ' MPa'])

M = readmatrix('DATA_sheets.xlsx', 'Sheet', 'fumax_fu');
fumax_fu = linediag3(M, d/h, k, 2);
fumax = fumax_fu * fu;
disp(['Maximum compressive strength fumax = ' num2str(fumax) ' MPa'])

M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'Ffu');
Ffu = 6.89476 * cripstr(M, k, tu/t, 1);
disp(['Crippling strength Ffu = ' num2str(Ffu) ' MPa'])

M = readmatrix('DATA_sheets.xlsx', 'Sheet', 'L2_hu');
L2_h = diag3(M, k, d/h, 2);
L1_h = .5 * L2_h;
Leq = n * L1_h * h;
lam = Leq / ru;
Fcr = Ffu - Ffu^2 * lam^2 / (4*pi^2*E);
disp(['Crippling strentgh Fcr = ' num2str(Fcr) ' MPa'])

MSmax = Ffu/fumax - 1;
MSav = Fcr/fuav - 1;
disp(['Margin of safety for max stresses MSmax = ' num2str(MSmax)])
disp(['Margin of safety for average stresses MSav = ' num2str(MSav)])

%%% WEB VERIFICATION %%%
disp(' ')
disp('Web verification:')

M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'tan(a)');
tana = diag3(M, fu/fs, k, 2);
a = atand(tana);
disp(['Angle of diagonal tension in the web a = ' num2str(a) ' deg'])

M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'C1');
C1 = XYdiag(M, tana);
M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'C2');
Ic = Ac * hc^2 / 12;
wd = .7 * d * (t / (2*Ic*h))^.25;
C2 = XYdiag(M, wd);
M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'C3');
C3 = XYdiag(M, wd);

fsmax = fs * (1 + k^2*C1) * (1 + k*C2);
disp(['Maximum shear stress in the web fsmax = ' num2str(fsmax) ' MPa'])

M = readmatrix("DATA_sheets.xlsx", 'Sheet', 'Fs_all');
Fsu = 6.89476 * diag3(M, k, a, 2);
disp(['Ultimate shear strength Fsu = ' num2str(Fsu) ' MPa'])

MSweb = Fsu/fsmax - 1;
disp(['Margin of safety MSweb = ' num2str(MSweb)])

%%% CAPS VERIFICATIONS %%%
disp(' ')
disp('Caps verification:')

Mmax = S * L * 1e-3;
disp(['Maximum primary moment Mmax = ' num2str(Mmax) ' Nm'])
fb = S * L / (Ac*h);
disp(['Stress due to primary moment fb = ' num2str(fb) ' MPa'])

fsb = k * C3 * S * d^2 * tana * hc / (24*h*Ic);
disp(['Stress due to secondary moment fsb = ' num2str(fsb) ' MPa'])

fF = k * S / (2*Ac*tana);
disp(['Stress due to diagonal tension fF = ' num2str(fF) ' MPa'])

MScap = 1 / ((fb+fF)/Fy + fsb/Ftu) - 1;
disp(['Margin of safety MScap = ' num2str(MScap)])

%%% PLOT FOR DIFFERENT SHEAR FORCES %%%
MSu_max = 0;
MSu_av = 0;
MSweb = 0;
MScap = 0;
Smax = 0;

while (MSu_max>=0 | MSu_av>=0 | MSweb>=0 | MScap>=0)
    Smax = Smax + 5000;
    fs = Smax / (h*t);
    fu = fu_fs * fs;
    fumax = fumax_fu * fu;
    fuav = fu * Aue / Au;
    MSu_max = Ffu/fumax - 1;
    MSu_av = Fcr/fuav - 1;
    fsmax = fs * (1 + k^2*C1) * (1 + k*C2);
    MSweb = Fsu/fsmax - 1;
    fb = Smax * L / (Ac*h);
    fsb = k * C3 * Smax * d^2 * tana * hc / (24*h*Ic);
    fF = k * Smax / (2*Ac*tana);
    MScap = 1 / ((fb+fF)/Fy + fsb/Ftu) - 1;
end
Smax = Smax * 1e-3;

S = 0:1:Smax;
fs = 1e+3 * S ./ (h*t);
fu = fu_fs * fs;
fumax = fumax_fu * fu;
fuav = Aue / Au * fu;
MSu_max = Ffu ./ fumax - 1;
MSu_av = Fcr ./ fuav - 1;
fsmax = (1 + k^2*C1) * (1 + k*C2) * fs;
MSweb = Fsu ./ fsmax - 1;
fb = L / (Ac*h) * 1e+3 * S;
fsb = k * C3 * d^2 * tana * hc / (24*h*Ic) * 1e+3 * S;
fF = k / (2*Ac*tana) * 1e+3 * S;
MScap = 1 ./ ((fb+fF)./Fy + fsb./Ftu) - 1;

plot(S, MSu_max, 'r', S, MSu_av, 'k', S, MSweb, 'b', S, MScap, 'g')
title('Margins of safety diagram')
legend('MSu_{max}', 'MSu_{av}', 'MSweb', 'MScap')
xlabel('Shear force (kN)'); ylabel('Margin of Safety')
xlim([.25*Smax Smax])
grid on