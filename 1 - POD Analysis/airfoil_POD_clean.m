% Clear workspace
clear; clc;

% directory where data is stored
DIR = 'C:\Users\user\Desktop\ME_493';

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
% X = reshape(ux, nx*ny, nt);
% Y = reshape(uy, nx*ny, nt);

[Ux,Sx,Vx] = svd(X,"econ");
[Uy,Sy,Vy] = svd(Y,"econ");

%% 
% A = [ux; uy];
% 
% corr_A = zeros(2*nx,ny,nt);
% mean_A = mean(A,[1 2]);
% 
% for i = 1:length(mean_A)
%     corr_A(:,:,i) = A(:,:,i) - mean_A(1, 1, i);
% end
% 
% corr_A = reshape(corr_A, nx*2*ny, []);
% [U, S, V] = svd(corr_A, "econ");

%% Sigma Vals

S_sqx = diag(Sx.*Sx);
S_sqy = diag(Sy.*Sy);
% S_sq = diag(S.*S);

n = 30;
x_sigmaplot = linspace(1,n,n);
% yA_sigmaplot = S_sq(1:n);
yx_sigmaplot = S_sqx(1:n);
yy_sigmaplot = S_sqy(1:n);

figure
% semilogy(x_sigmaplot,yA_sigmaplot, "-x")
% title('Eigvals vs Mode Number')
% grid on

subplot(1,2,1)
semilogy(x_sigmaplot,yx_sigmaplot, "-x")
title('Eigvals vs Mode Number of Ux')
grid on

subplot(1,2,2)
semilogy(x_sigmaplot,yy_sigmaplot, "-x")
title('Eigvals vs Mode Number of Uy')
grid on


%% Temporal Amplitudes for Ux

V_mode1 = Vx(:,1);
S_mode1 = Sx(1,1);
temp_amp1x = S_mode1*V_mode1;
mean_tx = mean(temp_amp1x);

V_mode2 = Vx(:,2);
S_mode2 = Sx(2,2);
temp_amp2x = S_mode2*V_mode2;

V_mode3 = Vx(:,3);
S_mode3 = Sx(3,3);
temp_amp3x = S_mode3*V_mode3;

V_mode4 = Vx(:,4);
S_mode4 = Sx(4,4);
temp_amp4x = S_mode4*V_mode4;

V_mode5 = Vx(:,5);
S_mode5 = Sx(5,5);
temp_amp5x = S_mode5*V_mode5;

V_mode6 = Vx(:,6);
S_mode6 = Sx(6,6);
temp_amp6x = S_mode6*V_mode6;

figure
subplot(2,3,1)
plot(t_field,temp_amp1x-mean_tx)
title('1st')
subplot(2,3,2)
plot(t_field,temp_amp2x)
title('2nd')
subplot(2,3,3)
plot(t_field,temp_amp3x)
title('3rd')
subplot(2,3,4)
plot(t_field,temp_amp4x)
title('4th')
subplot(2,3,5)
plot(t_field,temp_amp5x)
title('5th')
subplot(2,3,6)
plot(t_field,temp_amp6x)
title('6th')

%% Spatial Modes for Ux

mode2 = Ux(:,2);
mode2 = reshape(mode2,nx,ny,[]);
mode2 = transpose(mode2(:,:,1));

mode4 = Ux(:,4);
mode4 = reshape(mode4,nx,ny,[]);
mode4 = transpose(mode4(:,:,1));

mode6 = Ux(:,6);
mode6 = reshape(mode6,nx,ny,[]);
mode6 = transpose(mode6(:,:,1));

mode8 = Ux(:,8);
mode8 = reshape(mode8,nx,ny,[]);
mode8 = transpose(mode8(:,:,1));

mode10 = Ux(:,10);
mode10 = reshape(mode10,nx,ny,[]);
mode10 = transpose(mode10(:,:,1));

mode12 = Ux(:,12);
mode12 = reshape(mode12,nx,ny,[]);
mode12 = transpose(mode12(:,:,1));

figure
subplot(2,3,1);
contourf(x,y,mode2);
title('2nd Mode')

subplot(2,3,2);
contourf(x,y,mode4);
title('4th Mode')

subplot(2,3,3);
contourf(x,y,mode6);
title('6th Mode')

subplot(2,3,4);
contourf(x,y,mode8);
title('8th Mode')

subplot(2,3,5);
contourf(x,y,mode10);
title('10th Mode')

subplot(2,3,6);
contourf(x,y,mode12);
title('12th Mode')

%% Reconstruction of First Six Modes

t = 1;

U2 = Ux(:,1:2);
S2 = Sx(1:2,1:2);
V2 = Vx(1:2,:);

recon2 = U2*S2*V2;
recon2 = reshape(recon2,nx,ny,nt);
recon2 = transpose(recon2(:,:,t));

for i = 1:length(nt)
    recon2(:,:,i) = recon2(:,:,i) + mean_ux(1, 1, i);
end

U4 = Ux(:,1:4);
S4 = Sx(1:4,1:4);
V4 = Vx(1:4,:);

recon4 = U4*S4*V4;
recon4 = reshape(recon4,nx,ny,nt);
recon4 = transpose(recon4(:,:,t));

for i = 1:length(nt)
    recon4(:,:,i) = recon4(:,:,i) + mean_ux(1, 1, i);
end

U6 = Ux(:,1:6);
S6 = Sx(1:6,1:6);
V6 = Vx(1:6,:);

recon6 = U6*S6*V6;
recon6 = reshape(recon6,nx,ny,nt);
recon6 = transpose(recon6(:,:,t));

for i = 1:length(nt)
    recon6(:,:,i) = recon6(:,:,i) + mean_ux(1, 1, i);
end

ux_1 = transpose(ux(:,:,t));

figure
subplot(2,2,1);
contourf(x,y,ux_1,15,"LineWidth",0.1)
title('Original')

subplot(2,2,2);
contourf(x,y,recon2,15,"LineWidth",0.1)
title('r = 2')

subplot(2,2,3);
contourf(x,y,recon4,15,"LineWidth",0.1)
title('r = 4')

subplot(2,2,4);
contourf(x,y,recon6,15,"LineWidth",0.1)
title('r = 6')



