cd '/Users/pdealcan/Documents/github/CoE/code/analysis'
addpath('/Users/pdealcan/Documents/github/matlabTools/MocapToolbox/mocaptoolbox/')
addpath('/Users/pdealcan/Documents/github/matlabTools/MIRtoolbox/MIRToolbox')

%%%read data
phone = mcread('../../data/accelerometer1.json', 2)
mocap = mcread('../../data/Pedro-accel-2/movementTSV/mocap1.tsv');

%Resample phone
phone = mcresample(phone, 120);

%Get markers
mocap = mcgetmarker(mocap, 1)
phone = mcgetmarker(phone, 1)

%Remove time column from phone
phone.data = phone.data(:, 1:3)

%Calculate acceleration mocap
mocap = mctimeder(mocap, 2);

%Take norm
mocap = mcnorm(mocap)
phone = mcnorm(phone)

%Visualizing
mcplottimeseries(phone, 1, 'dim', 1)
mcplottimeseries(mocap, 1, 'dim', 1)

%Trim data to time of interest
phone = mctrim(phone, 4, 34);
mocap = mctrim(mocap, 42, 72);

%Cross correlation
[r, lag] = xcorr(phone.data,mocap.data);
[m, index] = max(r);
bestLag = lag(index);

% Trim to best lag
if bestLag > 0
    phone = mctrim(phone, abs(bestLag), phone.nFrames, 'frame'); 
elseif bestLag < 0
    mocap = mctrim(mocap, abs(bestLag), mocap.nFrames, 'frame'); 
end

%Normalizing
mocap.data = zscore(mocap.data)
phone.data = zscore(phone.data)

%Visualizing
mcplottimeseries(phone, 1, 'dim', 1)
mcplottimeseries(mocap, 1, 'dim', 1)

%Writing matrix
writematrix(mocap.data,'PhoneAccel1.csv')
writematrix(phone.data,'MocapAccel1.csv')

%Calculate overall periodicity
[perPhone, acp, eacp, lagp] = mcperiod(phone, 2);
[perMocap, acm, eacm, lagm] = mcperiod(mocap, 2);

%%%Calculate periodicity per frame
[perPhone, ac, eac, lags, wstartPhone] = mcwindow(@mcperiod, phone, 2, 0.25);
[perMocap, ac, eac, lags, wstartMocap] = mcwindow(@mcperiod, mocap, 2, 0.25);

writematrix(perPhone,'PhonePeriods1.csv')
writematrix(perMocap,'MocapPeriods1.csv')
