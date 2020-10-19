%% Set up IRIS, if it is not running already
try
    irisversion
catch 
    addpath(fullfile('C:\Users\',getenv('username'),'\Documents\202001IRISToolbox\'))
    irisstartup
end


forecastRound='202007';

%% DATES: major dates
sfilt = qq(2010,1); % start of filtration
sfcast = qq(2020,3); % start of forecast
efcast = qq(2030,4); % end of forecast

% For reports:
srpt_filt = sfilt; % start of filtration report
erpt_filt = qq(dat2ypf(sfcast)+4,4); % end of filtration report
srpt_fcast = qq(dat2ypf(sfcast)-1,4); % start of forecast report
erpt_fcast = qq(dat2ypf(sfcast)+3,4); % end of forecast report