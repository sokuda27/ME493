% Clear workspace% Clear workspace
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

X1 = X(:,1:end-1);
X2 = X(:,2:end);

S = diag(Sx);
plot(S(1:50,:));

%%
r = 15;

Ux_tilde = Ux(:,1:r);
Vx_tilde = Vx(:,1:r);
Sx_tilde = diag(Sx(1:r,1:r));

A_tilde = Ux_tilde'*X2*Vx_tilde(1:end-1,:)./Sx_tilde;
[W, Lambda] = eig(A_tilde);
Phi = X2*Vx_tilde(1:end-1,:)*W; %divide by Sx_tilde not working

%% Leading DMD Modes

figure
subplot(2,3,1)
contourf(x,y,transpose(reshape(real(Phi(:,1)),nx,ny)));
subplot(2,3,2)
contourf(x,y,transpose(reshape(real(Phi(:,2)),nx,ny)));
subplot(2,3,3)
contourf(x,y,transpose(reshape(real(Phi(:,3)),nx,ny)));
subplot(2,3,4)
contourf(x,y,transpose(reshape(real(Phi(:,4)),nx,ny)));
subplot(2,3,5)
contourf(x,y,transpose(reshape(real(Phi(:,5)),nx,ny)));
subplot(2,3,6)
contourf(x,y,transpose(reshape(real(Phi(:,6)),nx,ny)));


