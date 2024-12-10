clear;

tic;

modName = ['source_simplified'];
% Path to model file
ADBSat_path = ADBSat_dynpath;
modIn = fullfile(ADBSat_path,'inou','obj_files',[modName,'.obj']);
modOut = fullfile(ADBSat_path,'inou','models');
respath = fullfile(ADBSat_path,'inou','results');

%Input conditions
alt = 300; %km
inc = 0; %deg
env = [alt*1e3, inc/2, 0, 106, 0, 165, 165, ones(1,7)*15, 0]; % Environment variables

% Model parameters
param_eq.gsi_model = 'sentman';
param_eq.alpha = 1; % Accommodation (altitude dependent)
param_eq.Tw = 695; % Wall Temperature [K]
param_eq.Tinf = 1.0021e+03; % T_inf semi-manually calculated via environment.m
param_eq.s = 7.9263; % Thermal speed ratio semi-manually calculated via environment.m

param_eq.sol_cR = 0.15; % Specular Reflectivity
param_eq.sol_cD = 0.25; % Diffuse Reflectivity

verb = 0; % Verbose
del = 1; % Delete temp

% Shad/Sol-Flags
flag_shad=1;
flag_sol=1;

% Import model
modOut = ADBSatImport(modIn, modOut, verb);

% Start Parameters
aoa = -5; % Angle of attack
aos = -5; % Angle of sideslip

i = 1;
j = 1;

n_i = abs(aoa)*2 + 1; % Number of AoA-Values (Symmetric)
n_j = abs(aoa)*2 + 1; % Count of AoS-Values (Symmetric)

% Preallocating matrices
Cf_wX = zeros(i,j);
Cf_wY = zeros(i,j);
Cf_wZ = zeros(i,j);

while i <= n_i
    while j <= n_j
        
        % Coefficient Calculation
        output = calc_coeff(modName, respath, deg2rad(aoa), deg2rad(aos), param_eq, flag_shad, flag_sol, del, verb);
        load("results.mat","Cf_w")

        Cf_wX(i,j) = Cf_w(1);
        Cf_wY(i,j) = Cf_w(2);
        Cf_wZ(i,j) = Cf_w(3);

        aos = aos+1;
   
        j = j+1;
    end
    disp(aos)
    aos=aos-n_j;
    disp(aos)
    aoa=aoa+1;

    j=1;
    i=i+1;
end

%disp(Cf_wX)
%disp(Cf_wY)
%disp(Cf_wZ)

range_aoa = (n_i-1)/2;
range_aos = (n_j-1)/2;

c_d_matrix=[[0; (-range_aoa:1:range_aoa)'], [(-range_aos:1:range_aos); Cf_wX]];

disp(c_d_matrix)

save('c_d_values2.mat', 'c_d_matrix');