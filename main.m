% This program reconstructs a 3D model of arbitrary asteroid from its vertex-facet shape data.
% Local gravitational slope of the asteorid is computed and presented by facet color.
% 
% 25143 Itokawa/101955 Bennu/433 Eros shape model is read in this example code, which can be found at:  
% https://sbn.psi.edu/pds/resource/itokawashape.html  
% https://sbn.psi.edu/pds/resource/bennushape.html  
% https://sbn.psi.edu/pds/resource/erosshape.html  

clear;
close all;

prompt = 'Select shape data (Itokawa=0 / Bennu=1 / Eros=2)\n>> ';
shape_model = input(prompt);
prompt = 'Do you have Parallel Computing Toolbox? (Y/N [Y])\n>>';
par_flg = input(prompt,'s');
if isempty(par_flg)
    par_flg = 'Y';
end

if par_flg == 'Y'
    p = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(p)
        poolsize = 0;
        parpool
    else
        poolsize = p.NumWorkers;
    end
end

switch shape_model
    case 0 % Itokawa
        v = csvread('SHAPE_ITOKAWA_V.csv'); % vertices
        f = csvread('SHAPE_ITOKAWA_F.csv'); % triangular facets
        keepratio = 1.0E-1;
        maxvol = 1.0E-3;
    case 1 % Bennu
        v = csvread('SHAPE_BENNU_V.csv'); % vertices
        f = csvread('SHAPE_BENNU_F.csv'); % triangular facets
        keepratio = 1.0;
        maxvol = 1.0E-3;
    case 2 % Eros
        v = csvread('SHAPE_EROS_V.csv'); % vertices
        f = csvread('SHAPE_EROS_F.csv'); % triangular facets
        keepratio = 1.0E-1;
        maxvol = 1.0E-1;
end

ReconstructAsteroid(v,f,keepratio,maxvol,par_flg)