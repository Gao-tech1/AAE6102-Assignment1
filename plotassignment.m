clc
clear
close all
load navSolutionResults.mat
load trackingResults.mat

utc_time = gpstow2utc(settings.gpsweek, navSolutions.localTime)

figure("Name",'Velocity Result obtained from EKF and WLS')
title ('Velocity Result obtained from EKF and WLS','FontWeight','bold');
subplot(3,1,1)
plot(utc_time,navSolutions.Vx_ekf);hold on;
plot(utc_time,navSolutions.Vx,'-.');hold on;
legend('Vx_{EKF}','Vx');
xlabel ('Time');
ylabel ('Velocity_x (m/s)');
subplot(3,1,2)
plot(utc_time,navSolutions.Vy_ekf);hold on;
plot(utc_time,navSolutions.Vy,'-.');hold on;
legend('Vy_{EKF}','Vy');
xlabel ('Time');
ylabel ('Velocity_y (m/s)');
subplot(3,1,3)
plot(utc_time,navSolutions.Vz_ekf);hold on;
plot(utc_time,navSolutions.Vz,'-.');hold on;
legend('Vz_{EKF}','Vz');
xlabel ('Time');
ylabel ('Velocity_z (m/s)');

figure("Name",'Velocity Result obtained from EKF and WLS')
title ('Velocity Result obtained from EKF and WLS','FontWeight','bold');
subplot(2,1,1)
plot(utc_time,navSolutions.Vx_ekf);hold on;
plot(utc_time,navSolutions.Vy_ekf);hold on;
plot(utc_time,navSolutions.Vz_ekf);hold on;
legend('Vx_{EKF}','Vy_{EKF}','Vz_{EKF}');
xlabel ('Time');
ylabel ('Velocity_{EKF} (m/s)');
subplot(2,1,2)
plot(utc_time,navSolutions.Vx);hold on;
plot(utc_time,navSolutions.Vy);hold on;
plot(utc_time,navSolutions.Vz);hold on;
legend('Vx','Vy','Vz');
xlabel ('Time');
ylabel ('Velocity_{WLS} (m/s)');


% Generate correlation plots for the tracking results
figure("Name",'Multicorrelator');
for i=1:fix(settings.msToProcess/10000)
    subplot(2,2,i)
    for j=1:4
        for k=1:length(trackResults(j).I_multi{i*10000})
            mag(k)=sqrt(trackResults(j).I_multi{i*10000}(k)^2+trackResults(j).Q_multi{i*10000}(k)^2);
        end
        plot(mag,'-o', 'LineWidth', 1); hold on;
    end
    xlabel ('Chip');
    ylabel ('Amplitude');
    % title(['Correlator Outputs with Multiple Offsets at ', num2str(10*i), 's']);
    % legend('Channel 1','Channel 2', 'Channel 3', 'Channel 4', 'Channel 5');
    title([num2str(10*i), 's']);
end
legend('Channel 1','Channel 2', 'Channel 3', 'Channel 4');

figure("Name",'WLS_EKF_basemap')
geobasemap('streets-light'); % 设置底图类型为街道图
plot(22.3198722, 114.209101777778,'k+');
geoscatter(navSolutions.latitude,navSolutions.longitude,'b.');hold on;
geoscatter(mean(navSolutions.latitude),mean(navSolutions.longitude),'r.');hold on;
geoscatter(navSolutions.latitude_ekf,navSolutions.longitude_ekf,'g*');hold on;
geoscatter(mean(navSolutions.latitude_ekf),mean(navSolutions.longitude_ekf),'*');hold on;
legend('Ground Truth','WLS','mean WLS','EKF','mean EKF');