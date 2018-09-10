function ReconstructAsteroid(v,f,keepratio,maxvol,par_flg)

tic

p0 = [-0.3 -0.3 -0.3];
p1 = [0.3 0.3 0.3];

[v,f] = meshcheckrepair(v,f,'duplicated');
[node,elem,face] = surf2mesh(v,f,p0,p1,keepratio,maxvol);
vol=elemvolume(node,elem(:,1:4));
centroid=meshcentroid(node,elem(:,1:4));
fcentroid=meshcentroid(node,face(:,1:3));

% Gravity acceleration of each Finite Element
G = astroConstants(1)*10^9; % Universal gravity constant (G) (from DITAN) [km^3/(kg*s^2)]
elemnum = numel(elem(:,1)); % obtain the number of the tetrahedral finite element elements that compose the asteroid
fnum = numel(face(:,1)); % obtain the number of the tetrahedral finite element elements that compose the asteroid

dm = (1.95E+3*vol); % density is equal to the average bulk density of 25143 Itokawa measured by Hayabusa (Abe, S. et al.)

x = fcentroid(:,1); y = fcentroid(:,2); z = fcentroid(:,3);
slope = zeros(fnum,1);
switch par_flg
    case 'N'
        for i =1:fnum
            fpoint = [x(i)*ones(elemnum,1), y(i)*ones(elemnum,1), z(i)*ones(elemnum,1)];
            dR = (centroid-fpoint);
            norm_dR = (dR(:,1).^2+dR(:,2).^2+dR(:,3).^2).^0.5;
            dG = [G*dm.*dR(:,1)./norm_dR.^3, G*dm.*dR(:,2)./norm_dR.^3, G*dm.*dR(:,3)./norm_dR.^3];
            ndG = [sum(dG(:,1)) sum(dG(:,2)) sum(dG(:,3))]/norm([sum(dG(:,1)) sum(dG(:,2)) sum(dG(:,3))]);
            nfp = -fpoint(i,:)/norm(fpoint(i,:));
            theta = ndG*nfp';
            slope(i)=acos(theta)*180/pi;
        end
    case 'Y'
        parfor i =1:fnum
            fpoint = [x(i)*ones(elemnum,1), y(i)*ones(elemnum,1), z(i)*ones(elemnum,1)];
            dR = (centroid-fpoint);
            norm_dR = (dR(:,1).^2+dR(:,2).^2+dR(:,3).^2).^0.5;
            dG = [G*dm.*dR(:,1)./norm_dR.^3, G*dm.*dR(:,2)./norm_dR.^3, G*dm.*dR(:,3)./norm_dR.^3];
            ndG = [sum(dG(:,1)) sum(dG(:,2)) sum(dG(:,3))]/norm([sum(dG(:,1)) sum(dG(:,2)) sum(dG(:,3))]);
            nfp = -fpoint(i,:)/norm(fpoint(i,:));
            theta = ndG*nfp';
            slope(i)=acos(theta)*180/pi;
        end
end

clear centroidfcentroiddG dm dR norm_dR fpoint;

% save('dataset.mat','slope')

toc

%% PLOT 3D Asteroid

% load('dataset','slope');

figure1 = figure('Color',[0 0 0]);
nG = (slope-min(slope))/(max(slope)-min(slope));
plotsurf2(node,[face(:,1:3) nG],'linestyle','none');

set(figure1,'Position',[40 40 900 640]);
set(gca,'Visible','off','Parent',figure1,'ZTick',zeros(1,0),'YTick',zeros(1,0),'XTick',zeros(1,0));

view([180 180]);