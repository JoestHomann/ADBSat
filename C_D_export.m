%Drag calc function calling test

tic;

modName = ['source_simplified'];
% Path to model file
ADBSat_path = ADBSat_dynpath;
modIn = fullfile(ADBSat_path,'inou','obj_files',[modName,'.obj']);
modOut = fullfile(ADBSat_path,'inou','models');
resOut = fullfile(ADBSat_path,'inou','results');

%Input conditions
alt = 300; %km
inc = 0; %deg
env = [alt*1e3, inc/2, 0, 106, 0, 165, 165, ones(1,7)*15, 0]; % Environment variables

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
aoa = -2:1:2; % Angle of attack vector
aos = -2:1:2; % Angle of sideslip vector
n=length(aoa);
disp(n)

% Import model
modOut = ADBSatImport(modIn, modOut, verb);

output = ADBSatFcn( modOut, resOut, inparam, aoa, aos, shadow, solar, env, del, verb );

load(output,"aedb");
c_d_matrix=[[0; aoa'], [aos; aedb.aero.Cf_wX]];

disp(c_d_matrix)
disp(c_d_matrix(3,3))
save('c_d_values.mat', 'c_d_matrix'); % Speichert die Matrix A in der Datei "matrix_data.mat

toc;