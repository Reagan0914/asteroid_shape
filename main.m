% This program reconstructs a 3D model of arbitrary asteroid from its vertex-facet shape data.
% Local gravitational slope of the asteorid is computed and presented by facet color.
% 
% 25143 Itokawa/101955 Bennu/433 Eros shape model is read in this example code, which can be found at:  
% https://sbn.psi.edu/pds/resource/itokawashape.html  
% https://sbn.psi.edu/pds/resource/bennushape.html  
% https://sbn.psi.edu/pds/resource/erosshape.html  

clear;
close all;

prompt = 'Select shape data (Itokawa=1 / Bennu=2 / Eros=3)\n>> ';
shape_model = input(prompt);

switch shape_model
    case 1 % Itokawa
        v = csvread('SHAPE_ITOKAWA_V.csv'); % vertices
        f = csvread('SHAPE_ITOKAWA_F.csv'); % triangular facets
        keepratio = 1.0E-1;
        maxvol = 1.0E-3;
    case 2 % Bennu
        v = csvread('SHAPE_BENNU_V.csv'); % vertices
        f = csvread('SHAPE_BENNU_F.csv'); % triangular facets
        keepratio = 1.0;
        maxvol = 1.0E-3;
    case 3 % Eros
        v = csvread('SHAPE_EROS_V.csv'); % vertices
        f = csvread('SHAPE_EROS_F.csv'); % triangular facets
        keepratio = 1.0E-1;
        maxvol = 1.0E-1;
end

ReconstructAsteroid(v,f,keepratio,maxvol)