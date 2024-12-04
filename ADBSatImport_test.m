

ADBSat_path = ADBSat_dynpath;

filename = 'sat_test.obj'; % Input: Name of the file in /inou/obj_files

modIn = fullfile(ADBSat_path,'inou','obj_files',filename);
[modPath,modName,ext] = fileparts(filename);

% Create .obj file from .stl if required (using meshlabserver)
if strcmpi(ext,'.stl')
    [err] = stl2obj(modIn);
    if ~err
        objname = [modName,'.obj'];
    end
else
    objname = [modName,'.obj'];
end

objpath = fullfile(modPath,objname);

pathOut = fullfile(ADBSat_path,'inou','models');

matOut = importobjtri(modIn, pathOut, modName, verb);

plotNormals(matOut); % Plots the surface mesh with the normals