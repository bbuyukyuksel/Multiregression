clc; clear; close all;
%% Parse traindata to .mat object

%% Excell Verisini ayrýþtýrmak için aþaðýdaki kod kullanýldý.
% filename = 'data.xlsx';
% sheet = 2;
% excell = xlsread(filename,sheet);
% 
% trainData = struct('minTemp', excell(:,1), 'evaporation',excell(:,2), 'rainfall', excell(:,3));
% ind_minTemp     = isnan(trainData.minTemp);
% ind_evaporation = isnan(trainData.minTemp);
% ind_rainfall = isnan(trainData.minTemp);
% 
% trainData.minTemp(ind_minTemp) = [];
% trainData.evaporation(ind_evaporation) = [];
% trainData.rainfall(ind_rainfall) = [];
% 
% save('trainDataSet.mat', 'trainData');
% 
% testData = struct('minTemp', excell(:,5), 'evaporation',excell(:,6), 'rainfall', excell(:,7));
% save('testDataSet.mat','testData');
%%
% Veri Seti Yüklendi.
load TrainDataSet.mat;
load TestDataSet.mat;

% Veri Seti içerisindeki deðerler atandý.
x1 = trainData.minTemp;
x2 = trainData.evaporation;
y = trainData.rainfall;

% Regresyon Analizi Yapýlýyor : 
% Uydurma Denklemi : A0.x1 + A1.x2 + A2.x1.^2 + A3.x2.^2 + A4.x1.*x2 + A5.x1.^3 + A6.x2.^3 + A7.x1.^4 +  A8.x2.^4 + A9.((x1.^2).*(x2.^2)) + A10.((x1.^3).*(x2.^3)) + A11.((x1.^4).*(x2.^4))
X = [ones(size(x1)) x1 x2 x1.^2 x2.^2 x1.*x2 x1.^3 x2.^3 x1.^4 x2.^4 ((x1.^2).*(x2.^2)) ((x1.^3).*(x2.^3)) ((x1.^4).*(x2.^4)) x1.^5 x2.^5];
b = regress(y,X);    % Removes NaN data


hold on
x1fit = min(x1):0.1:max(x1);
x2fit = min(x2):0.1:max(x2);
[X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT +b(4)*X1FIT.^2 + b(5)*X2FIT.^2 +b(6)*X1FIT.*X2FIT + b(7)*X1FIT.^3 + b(8)*X2FIT.^3 ...
     + b(9)*X1FIT.^4 + b(10)*X2FIT.^4 ...
     + b(11)*((X1FIT.^2).*(X2FIT.^2)) ...
     + b(12)*((X1FIT.^3).*(X2FIT.^3)) ...
     + b(13)*((X1FIT.^4).*(X2FIT.^4)) ...
     + b(14)*(X1FIT.^5)...
     + b(15)*(X2FIT.^5)...
     ;
 
mesh(X1FIT,X2FIT,YFIT)
xlabel('min temp')
ylabel('evaporation')
zlabel('rainfall')
title('Result');
view(50,10)
hold on

x1 = testData.minTemp;
x2 = testData.evaporation;
y = testData.rainfall;
YFIT = b(1) + b(2)*x1 + b(3)*x2 +b(4)*x1.^2 + b(5)*x2.^2 +b(6)*x1.*x2 + b(7)*x1.^3 + b(8)*x2.^3 ...
     + b(9)*x1.^4 + b(10)*x2.^4 ...
     + b(11)*((x1.^2).*(x2.^2)) ...
     + b(12)*((x1.^3).*(x2.^3)) ...
     + b(13)*((x1.^4).*(x2.^4)) ...
     + b(14)*(x1.^5) ...
     + b(15)*(x2.^5) ...
     ;
scatter3(x1,x2,y,'filled');
scatter3(x1,x2,YFIT,'filled');
legend('Tahmin Düzlemi','Veri','Tahmin');
hold off;

%% Verileri Excell Dosyasýna Yazdýr.
filename = 'logfile.xlsx';
sheet = 1;
xlRange = 'A1';
minTemp = x1;
evaporation = x2;
rainfall = y;
predict_raindall = YFIT;

T = table(minTemp,evaporation,rainfall,predict_raindall);
writetable(T,filename,'Sheet',1,'Range','A1');

