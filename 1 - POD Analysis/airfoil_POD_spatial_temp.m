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

corr_ux = zeros(nx,ny,nt);
corr_uy = zeros(nx,ny,nt);

% for i = 1:length(mean_uy)
%     corr_ux(:,:,i) = ux(:,:,i) - mean_ux(1, 1, i);
%     corr_uy(:,:,i) = uy(:,:,i) - mean_uy(1, 1, i);
% end

% X = [corr_ux corr_uy];
X = (ux.^2 + uy.^2).^0.5;
X = reshape(X,[],401);

mean = mean(X,[1 2]);

for i = 1:length(nt)
    X(:,:,i) = X(:,:,i) - mean(1, 1, i);
end

[U,S,V] = svd(X,"econ");

%% 

S_sq = diag(S.*S);

x_sigmaplot = linspace(1,nt,nt);
y_sigmaplot = S_sq;

figure
semilogy(x_sigmaplot,y_sigmaplot);
grid on

%% 

%temporal amplitude??

V_mode2 = V(:,2);
S_mode2 = S(2,2);
temp_amp2 = S_mode2*V_mode2';

V_mode4 = V(:,4);
S_mode4 = S(4,4);
temp_amp4 = S_mode4*V_mode4';

V_mode6 = V(:,4);
S_mode6 = S(6,6);
temp_amp6 = S_mode6*V_mode6';

figure
plot(t_field,temp_amp2)
plot(t_field,temp_amp4)
plot(t_field,temp_amp6)

%% 

%spatial mode???

mode2 = U(:,2);
mode2 = reshape(mode2,nx,ny);
mode2 = transpose(mode2);

mode4 = U(:,4);
mode4 = reshape(mode4,nx,ny);
mode4 = transpose(mode4);

mode6 = U(:,6);
mode6 = reshape(mode6,nx,ny);
mode6 = transpose(mode6);

mode8 = U(:,8);
mode8 = reshape(mode8,nx,ny);
mode8 = transpose(mode8);

mode10 = U(:,10);
mode10 = reshape(mode10,nx,ny);
mode10 = transpose(mode10);

mode12 = U(:,12);
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