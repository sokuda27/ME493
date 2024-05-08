%% Variables
clear clc;
w1 = 2.4*2*pi;
w2 = 2.6*2*pi;
w3 = 6.5*2*pi;
w4 = 8.3*2*pi;
w5 = 9.3*2*pi;
k = 5;
z1 = 0.03;
z2 = 0.03;
z3 = 0.042;
z4 = 0.025;
z5 = 0.032;
tau = 10^-4;

s = tf('s');
G = k*w2^2*w3^2*w5^2*(s^2+2*z1*w1*s+w1^2)*(s^2+2*z4*w4*s+w4^2)*exp(-s*tau)/(w1^2*w4^2*(s^2+2*z2*w2*s+w2^2)*(s^2+2*z3*w3*s+w3^2)*(s^2+2*z5*w5*s+w5^2));

dt = 0.001;
t = linspace(0,5,5/dt);

X = impulse(G,t);
X = X + awgn(X,10,'measured');
X2 = X(2:end);

r = 7;

H = hankel(X');
H = H(1:(length(X)/2),1:(length(X)/2));
H2 = hankel(X2');
H2 = H2(1:(length(X)/2),1:(length(X)/2));

[U, S, V] = svd(H,"econ");

nin = 1;
nout = 1;

%% 

Sigma = S(1:r,1:r);
Ur = U(:,1:r);
Vr = V(:,1:r);
Ar = Sigma^(-.5)*Ur'*H2*Vr*Sigma^(-.5);
Br = Sigma^(-.5)*Ur'*H(:,1:nin);
Cr = H(1:nout,:)*Vr*Sigma^(-.5);
HSVs = diag(S);

plot(HSVs(1:10));
G_era = ss(Ar, Br, Cr, 0, dt)*dt;

opts = bodeoptions('cstprefs');
opts.PhaseWrapping = 'on';

figure
hold on
bode(G_era,opts)
bode(G)
xlabel("Frequency (krad/s)");
% T^T
legend