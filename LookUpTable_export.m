clear;

tic;

modName = ['sat_test'];
% Path to model file
ADBSat_path = ADBSat_dynpath;
modIn = fullfile(ADBSat_path,'inou','obj_files',[modName,'.obj']);
modOut = fullfile(ADBSat_path,'inou','models');
resOut = fullfile(ADBSat_path,'inou','results');

%Input conditions
alt = 300; %km
inc = 0; %deg
<<<<<<< HEAD
env = [alt*1e3, inc/2, 0, 106, 0, 90, 90, ones(1,7)*15, 0]; % Environment variables
=======
env = [alt*1e3, inc/2, 0, 106, 0, 165, 165, ones(1,7)*15, 0]; % Environment variables
>>>>>>> 240c6899b2328a9eaa38acb3fb1e80adc1a760b4

% Model parameters
shadow = 1;
inparam.gsi_model = 'sentman';
inparam.alpha = 1; % Accommodation (altitude dependent)
inparam.Tw = 695; % Wall Temperature [K]

solar = 1;
inparam.sol_cR = 0.15; % Specular Reflectivity
inparam.sol_cD = 0.25; % Diffuse Reflectivity

verb = 0; % Verbose
del = 1; % Delete temp

% Start Parameters
<<<<<<< HEAD
n=1;
aoa = 1:1:n; % Angle of attack
aos = 1:1:n; % Angle of sideslip
=======
range = 5;
aoa = -range:1:range; % Angle of attack vector
aos = -range:1:range; % Angle of sideslip vector
n=length(aoa);
disp(n)
>>>>>>> 240c6899b2328a9eaa38acb3fb1e80adc1a760b4

% Import model
modOut = ADBSatImport(modIn, modOut, verb);

% Coefficient Calculation
%output = ADBSatFcn( modOut, resOut, inparam, aoa, aos, shadow, solar, env, del, verb );
<<<<<<< HEAD
%output = calc_coeff(fiName, respath, aoaS, aosS, param_eq, flag_shad, flag_sol, del, verb);
=======
>>>>>>> 240c6899b2328a9eaa38acb3fb1e80adc1a760b4

% Table-initialisation
LookUpTable=zeros(n,n);


<<<<<<< HEAD
while aoa <= n
    while aos <= n
        
        %LookUpTable(aoa,aos)=aedb.aero.Cf_wX;
=======
i=1;
j=1;

while i <= n
    while j <= n
        output = calc_coeff( modOut, resOut, aoa, aos, inparam, shadow, solar, del, verb );
        load(output,'aedb');
        LookUpTable(i,j)=aedb.aero.Cf_wX;
>>>>>>> 240c6899b2328a9eaa38acb3fb1e80adc1a760b4
        disp(aos)
        j=j+1;

    end
    j=1;
    i=i+1;

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