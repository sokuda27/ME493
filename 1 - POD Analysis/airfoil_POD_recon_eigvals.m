% Clear workspace
clear; clc;

% directory where data is stored
DIR = 'C:\Users\user\Desktop\ME 493';

paramsFile = fullfile(DIR,'airfoilDNS_parameters.h5');

dt_field = h5read(paramsFile,'/dt_field'); % timestep for field variables (velocity and vorticity)
dt_force = h5read(paramsFile,'/dt_force'); % timestep for scalar quantities
Re = h5read(paramsFile,'/Re');
FreqsAll = h5read(paramsFile,'/frequencies'); % pitching frequencies
alpha_p = h5read(paramsFile,'/alpha_p'); % pitching amplitude (deg)
alpha_0s = h5read(paramsFile,'/alpha_0s'); % base angles of attack (deg) (25 and 30)
pich_axis = h5read(paramsFile,'/pitch_axis'); % 0.5, midchord pitching

BaseAngle = 25; % options are 25 and 30 deg

Freqs = [0.05,0.25,0.5]; % choose pitching frequencies to plot
% must be from the set 0.05, 0.1, 0.2, 0.25, 0.3, 0.35, 0.4, 0.5

FreqLabels = {'0p05'}; % for loading files, must match selected Freqs

% load and plot snapshots
tstep = 1; % timestep to plot

% load spatial grid, and time vectors
filenameGrid = fullfile(DIR,'airfoilDNS_grid.h5');

x = h5read(filenameGrid,'/x');
y = h5read(filenameGrid,'/y');
nx = length(x);
ny = length(y);

FreqStr = '0p05';
Freq = 0.05;

filename = fullfile(DIR,['airfoilDNS_a',num2str(BaseAngle),'f',FreqStr,'.h5']);
t_field = h5read(filename,'/t_field');
nt = length(t_field);

ux = h5read(filename,'/ux'); % streamwise velocity
uy = h5read(filename,'/uy'); % transverse velocity

mean_ux = mean(ux,[1 2]);
mean_uy = mean(uy,[1 2]);

corr_ux = zeros(nx,ny,nt);
corr_uy = zeros(nx,ny,nt);

for i = 1:length(mean_uy)
    corr_ux(:,:,i) = ux(:,:,i) - mean_ux(1, 1, i);
    corr_uy(:,:,i) = uy(:,:,i) - mean_uy(1, 1, i);
end

X = reshape(corr_ux, nx*ny, nt);
Y = reshape(corr_uy, nx*ny, nt);

[Ux,Sx,Vx] = svd(X,"econ");
[Uy,Sy,Vy] = svd(Y,"econ");

%% 

t = 1;

U2 = Ux(:,1:2);
S2 = Sx(1:2,1:2);
V2 = Vx(:,1:2);

recon2 = U2*S2*V2';
recon2 = reshape(recon2,nx,ny,nt);
recon2 = transpose(recon2(:,:,t));

for i = 1:length(nt)
    recon2(:,:,i) = recon2(:,:,i) + mean_ux(1, 1, i);
end

U4 = Ux(:,1:4);
S4 = Sx(1:4,1:4);
V4 = Vx(:,1:4);

recon4 = U4*S4*V4';
recon4 = reshape(recon4,nx,ny,nt);
recon4 = transpose(recon4(:,:,t));

for i = 1:length(nt)
    recon4(:,:,i) = recon4(:,:,i) + mean_ux(1, 1, i);
end

U6 = Ux(:,1:6);
S6 = Sx(1:6,1:6);
V6 = Vx(:,1:6);

recon6 = U6*S6*V6';
recon6 = reshape(recon6,nx,ny,nt);
recon6 = transpose(recon6(:,:,t));

for i = 1:length(nt)
    recon6(:,:,i) = recon6(:,:,i) + mean_ux(1, 1, i);
end

ux_1 = transpose(ux(:,:,t));

figure
subplot(2,2,1);
contourf(x,y,ux_1,15,"LineWidth",0.1)

subplot(2,2,2);
contourf(x,y,recon2,15,"LineWidth",0.1)

subplot(2,2,3);
contourf(x,y,recon4,15,"LineWidth",0.1)

subplot(2,2,4);
contourf(x,y,recon6,15,"LineWidth",0.1)


%% 

U2 = Uy(:,1:2);
S2 = Sy(1:2,1:2);
V2 = Vy(:,1:2);

recon2 = U2*S2*V2';
recon2 = reshape(recon2,nx,ny,nt);
recon2 = transpose(recon2(:,:,t));

for i = 1:length(nt)
    recon2(:,:,i) = recon2(:,:,i) + mean_uy(1, 1, i);
end

U4 = Uy(:,1:4);
S4 = Sy(1:4,1:4);
V4 = Vy(:,1:4);

recon4 = U4*S4*V4';
recon4 = reshape(recon4,nx,ny,nt);
recon4 = transpose(recon4(:,:,t));

for i = 1:length(nt)
    recon4(:,:,i) = recon4(:,:,i) + mean_uy(1, 1, i);
end

U6 = Uy(:,1:6);
S6 = Sy(1:6,1:6);
V6 = Vy(:,1:6);

recon6 = U6*S6*V6';
recon6 = reshape(recon6,nx,ny,nt);
recon6 = transpose(recon6(:,:,t));

for i = 1:length(nt)
    recon6(:,:,i) = recon6(:,:,i) + mean_uy(1, 1, i);
end

uy_1 = transpose(uy(:,:,t));

figure
subplot(2,2,1);
contourf(x,y,uy_1,15,"LineWidth",0.1)

subplot(2,2,2);
contourf(x,y,recon2,15,"LineWidth",0.1)

subplot(2,2,3);
contourf(x,y,recon4,15,"LineWidth",0.1)

subplot(2,2,4);
contourf(x,y,recon6,15,"LineWidth",0.1)

%% 

mode2 = Ux(:,2);
mode2 = reshape(mode2,nx,ny);
mode2 = transpose(mode2);

mode4 = Ux(:,4);
mode4 = reshape(mode4,nx,ny);
mode4 = transpose(mode4);

mode6 = Ux(:,6);
mode6 = reshape(mode6,nx,ny);
mode6 = transpose(mode6);

mode8 = Ux(:,8);
mode8 = reshape(mode8,nx,ny);
mode8 = transpose(mode8);

mode10 = Ux(:,10);
mode10 = reshape(mode10,nx,ny);
mode10 = transpose(mode10);

mode12 = Ux(:,12);
mode12 = reshape(mode12,nx,ny);
mode12 = transpose(mode12);

figure
subplot(2,3,1);
contourf(x,y,mode2);

subplot(2,3,2);
contourf(x,y,mode4);

subplot(2,3,3);
contourf(x,y,mode6);

subplot(2,3,4);
contourf(x,y,mode8);

subplot(2,3,5);
contourf(x,y,mode10);

subplot(2,3,6);
contourf(x,y,mode12);

%% 

mode2 = Uy(:,1);
mode2 = reshape(mode2,nx,ny);
mode2 = transpose(mode2);

mode4 = Uy(:,2);
mode4 = reshape(mode4,nx,ny);
mode4 = transpose(mode4);

mode6 = Uy(:,3);
mode6 = reshape(mode6,nx,ny);
mode6 = transpose(mode6);

mode8 = Uy(:,4);
mode8 = reshape(mode8,nx,ny);
mode8 = transpose(mode8);

mode10 = Uy(:,5);
mode10 = reshape(mode10,nx,ny);
mode10 = transpose(mode10);

mode12 = Uy(:,6);
mode12 = reshape(mode12,nx,ny);
mode12 = transpose(mode12);

figure
subplot(2,3,1);
contourf(x,y,mode2);

subplot(2,3,2);
contourf(x,y,mode4);

subplot(2,3,3);
contourf(x,y,mode6);

subplot(2,3,4);
contourf(x,y,mode8);

subplot(2,3,5);
contourf(x,y,mode10);

subplot(2,3,6);
contourf(x,y,mode12);

