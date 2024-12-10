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
param_eq.gsi_model = 'sentman';
param_eq.alpha = 1; % Accommodation (altitude dependent)
param_eq.Tw = 695; % Wall Temperature [K]
param_eq.Tinf = 695; %
param_eq.s = 100; %

param_eq.sol_cR = 0.15; % Specular Reflectivity
param_eq.sol_cD = 0.25; % Diffuse Reflectivity

verb = 0; % Verbose
del = 1; % Delete temp

% Shad/Sol-Flags
flag_shad=1;
flag_sol=1;

% Start Parameters
aoa = -45; % Angle of attack
aos = -45; % Angle of sideslip

% Import model
modOut = ADBSatImport(modIn, modOut, verb);

i = 1;
j = 1;

n_i = 5;
n_j = 3;

% Preallocating matrices
Cf_wX = zeros(i,j);
Cf_wY = zeros(i,j);
Cf_wZ = zeros(i,j);

while i <= n_i
    while j <= n_j
        disp(aoa)
        disp(aos)
        load("results.mat","Cf_w")
        
        % Coefficient Calculation
        output = calc_coeff(modName, respath, deg2rad(aoa), deg2rad(aos), param_eq, flag_shad, flag_sol, del, verb);

        Cf_wX(i,j) = Cf_w(1);
        Cf_wY(i,j) = Cf_w(2);
        Cf_wZ(i,j) = Cf_w(3);

        aos = aos+1;

        j = j+1;
    end
    aos=-45;
    aoa=aoa+1;

    j=1;
    i=i+1;
end

disp(Cf_wX)
disp(Cf_wY)
disp(Cf_wZ)

