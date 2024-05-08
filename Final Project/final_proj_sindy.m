
data = readtable("C:\Users\user\Downloads\stock\ALL.xlsx");
data = table2array(data);
data = data(:,1:5)';

data_smooth = zeros(length(data(:,1)),length(data(1,:)));
data_smooth(:,1:2) = data(:,1:2);
days = 253;
data_smooth(:,(days-2):end) = data(:,(days-2):end);

for j=1:5
    for i=3:(length(data(1,:))-2)
        data_smooth(j,i) = (data(j,i-2) + data(j,i-1) + data(j,i) + data(j,i+1) + data(j,i+2))/5;
    end
end

avg = mean(data_smooth, 2);
dt_data = diff(data,1,2);

n = 3;
Theta = poolData(data,n,1);  % up to first order polynomials

lambda = 0.0139;      % lambda is our sparsification knob.
Xi = sparsifyDynamics(Theta,dt_data,lambda,n);

sindy = Theta*Xi;

dt_field = 1;
t_field = linspace(1,253,253);

%% 

figure
for k=1:5
    sindy_amp = cumtrapz(dt_field, sindy(k,:));
    sindy_amp = sindy_amp + avg(k,1);

    subplot(3,2,k);
    hold on
    plot(t_field(1:end-1), data_smooth(k,1:end-1))
    plot(t_field(1:end-1), sindy_amp)
    legend("data", "sindy")
end