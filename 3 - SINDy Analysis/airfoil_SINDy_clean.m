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

X = reshape(ux, nx*ny, nt);
Y = reshape(uy, nx*ny, nt);

meanSub = 1;

if meanSub
    XMean = mean(X, 2);
    YMean = mean(Y, 2);
    X = X - XMean * ones(1, nt);
    Y = Y - YMean * ones(1, nt);
end

[Ux,Sx,Vx] = svd(X,"econ");
[Uy,Sy,Vy] = svd(Y,"econ");

%% 

% amps = reshape(Sx*Vx,[], nt);

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

amps = [temp_amp1x'; temp_amp2x'; temp_amp3x'; temp_amp4x'; temp_amp5x'; temp_amp6x'];

damps = diff(amps,1,2)/dt_field;

n = 3;
Theta = poolData(amps,n,2);  % up to second order polynomials
lambda = 0.0139;      % lambda is our sparsification knob.
Xi = sparsifyDynamics(Theta,damps,lambda,n);

sindy_x = Theta*Xi;

%% 
figure
for i=1:6
    sindy_amp = cumtrapz(dt_field, sindy_x(i,:));
    sindy_amp = sindy_amp + amps(i,1);
    subplot(3,2,i);
    hold on
    plot(t_field(1:end-1), amps(i,1:end-1))
    plot(t_field(1:end-1), sindy_amp)
end











