clear;

tic;


modName = ['sat_test'];
% Path to model file
ADBSat_path = ADBSat_dynpath;
modIn = fullfile(ADBSat_path,'inou','obj_files',[modName,'.obj']);
modOut = fullfile(ADBSat_path,'inou','models');
respath = fullfile(ADBSat_path,'inou','results');

%Input conditions
alt = 300; %km
inc = 0; %deg
env = [alt*1e3, inc/2, 0, 106, 0, 90, 90, ones(1,7)*15, 0]; % Environment variables

% Model parameters
shadow = 1;
inparam.gsi_model = 'sentman';
inparam.alpha = 1; % Accommodation (altitude dependent)
inparam.Tw = 300; % Wall Temperature [K]

solar = 1;
inparam.sol_cR = 0.15; % Specular Reflectivity
inparam.sol_cD = 0.25; % Diffuse Reflectivity

verb = 0; % Verbose
del = 1; % Delete temp

% Start Parameters
n=1;
aoaS = 1:1:n; % Angle of attack
aosS = 1:1:n; % Angle of sideslip

% Shad/Sol-Flags
flag_shad=1;
flag_sol=0;

param=param_eq();

% Import model
modOut = ADBSatImport(modIn, modOut, verb);

% Coefficient Calculation
%output = ADBSatFcn( modOut, resOut, inparam, aoa, aos, shadow, solar, env, del, verb );
output = calc_coeff(modName, respath, aoaS, aosS, param_eq, flag_shad, flag_sol, del, verb);

% Table-initialisation
LookUpTable=zeros(n,n);

load(output,'aedb');

while aoa <= n
    while aos <= n
        
        %LookUpTable(aoa,aos)=aedb.aero.Cf_wX;
        disp(aos)
        aos=aos+1;

    end
    aos=1;
    aoa=aoa+1;

end

disp(LookUpTable)

% Plot surface distribution C_D
figure
load(output,'aedb')
contourf((aedb.aos).*(180/pi), aedb.aoa.*(180/pi), aedb.aero.Cf_wX)
colorbar
xlabel('Angle of Sideslip')
ylabel('Angle of Attack')
title('Drag Force Coefficient')

toc;