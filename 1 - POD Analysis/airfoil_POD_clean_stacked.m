% Clear workspace
clear;
clc;
close all;

DIR = 'C:\Users\user\Desktop\ME_493';

% Import files
filenameGrid = fullfile(DIR, 'airfoilDNS_grid.h5');
filename = fullfile(DIR, 'airfoilDNS_a25f0p05.h5');

% Get the velocities and time_parameters for all snapshots taken. 
t_field = h5read(filename,'/t_field');
nt = length(t_field);

x = h5read(filenameGrid,'/x');
nx = length(x);
y = h5read(filenameGrid,'/y');
ny = length(y);

ux = h5read(filename,'/ux'); % streamwise velocity
uy = h5read(filename,'/uy'); % transverse velocity

%% 

X = reshape(ux, nx*ny, []);
Y = reshape(uy, nx*ny, []);

stacked = [X;Y];

meanSub = 1;

if meanSub
    Mean = mean(stacked, 2);
    stacked = stacked - Mean * ones(1, nt);
end

[U,S,V] = svd(stacked, "econ");

%% 

S_sq = diag(S.*S);

n = 30;
x_sigmaplot = linspace(1,n,n);
y_sigmaplot = S_sq(1:n);

figure
semilogy(x_sigmaplot,y_sigmaplot, "-x")
title('Eigvals vs Mode Number')
grid on


%% 

S_diag = diag(S);

V_mode1 = V(:,1);
temp_amp1x = S_diag(1)*V_mode1;
% mean_tx = mean(temp_amp1x);

V_mode2 = V(:,2);
temp_amp2x = S_diag(2)*V_mode2;

V_mode3 = V(:,3);
temp_amp3x = S_diag(3)*V_mode3;

V_mode4 = V(:,4);
temp_amp4x = S_diag(4)*V_mode4;

V_mode5 = V(:,5);
temp_amp5x = S_diag(5)*V_mode5;

V_mode6 = V(:,6);
temp_amp6x = S_diag(6)*V_mode6;

figure
subplot(2,3,1)
plot(t_field,temp_amp1x)
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

%% 

mode2 = U(:,1);
mode2 = reshape(mode2,nx,ny,[]);
mode2 = transpose(mode2(:,:,1));

mode4 = U(:,2);
mode4 = reshape(mode4,nx,ny,[]);
mode4 = transpose(mode4(:,:,1));

mode6 = U(:,3);
mode6 = reshape(mode6,nx,ny,[]);
mode6 = transpose(mode6(:,:,1));

mode8 = U(:,4);
mode8 = reshape(mode8,nx,ny,[]);
mode8 = transpose(mode8(:,:,1));

mode10 = U(:,5);
mode10 = reshape(mode10,nx,ny,[]);
mode10 = transpose(mode10(:,:,1));

mode12 = U(:,6);
mode12 = reshape(mode12,nx,ny,[]);
mode12 = transpose(mode12(:,:,1));

figure
subplot(2,3,1);
contourf(x,y,mode2);
title('1st Mode')

subplot(2,3,2);
contourf(x,y,mode4);
title('2nd Mode')

subplot(2,3,3);
contourf(x,y,mode6);
title('3rd Mode')

subplot(2,3,4);
contourf(x,y,mode8);
title('4th Mode')

subplot(2,3,5);
contourf(x,y,mode10);
title('5th Mode')

subplot(2,3,6);
contourf(x,y,mode12);
title('6th Mode')

%% Reconstruction of First Six Modes

t = 1;

U2 = U(:,1:2);
S2 = S(1:2,1:2);
V2 = V(1:2,:);

recon2 = U2*S2*V2;
for i = 1:length(nt)
    recon2(:,i) = recon2(:,i) + mean(1, i);
end
recon2x = recon2(1:(nx*ny),1:nt);
recon2x = reshape(recon2x,nx,ny,nt);
recon2y = recon2((nx*ny+1):end,1:nt);
recon2y = reshape(recon2y,nx,ny,nt);


U4 = U(:,1:4);
S4 = S(1:4,1:4);
V4 = V(1:4,:);

recon4 = U4*S4*V4;
for i = 1:length(nt)
    recon4(:,i) = recon4(:,i) + mean(1, i);
end
recon4x = recon4(1:(nx*ny),1:nt);
recon4x = reshape(recon4x,nx,ny,nt);
recon4y = recon4((nx*ny+1):end,1:nt);
recon4y = reshape(recon4y,nx,ny,nt);

U6 = U(:,1:6);
S6 = S(1:6,1:6);
V6 = V(1:6,:);

recon6 = U6*S6*V6;
for i = 1:length(nt)
    recon6(:,i) = recon6(:,i) + mean(1, i);
end
recon6x = recon6(1:(nx*ny),1:nt);
recon6x = reshape(recon6x,nx,ny,nt);
recon6y = recon6((nx*ny+1):end,1:nt);
recon6y = reshape(recon6y,nx,ny,nt);

ux_1 = transpose(ux(:,:,t));

figure
subplot(2,2,1);
contourf(x,y,ux_1,15,"LineWidth",0.1)
title('Original')

subplot(2,2,2);
contourf(x,y,recon2y(:,:,t)',15,"LineWidth",0.1)
title('r = 2')

subplot(2,2,3);
contourf(x,y,recon4y(:,:,t)',15,"LineWidth",0.1)
title('r = 4')

subplot(2,2,4);
contourf(x,y,recon6y(:,:,t)',15,"LineWidth",0.1)
title('r = 6')

