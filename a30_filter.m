%% Set  prior parameters
% Parameters database
P = struct(); 

%  I. Current account

P.a1_sia=-1.2553
P.a2_sia=204.3609


P.a0_dSeB = 0.0
P.a1_dSeB= 29.1034
P.a3_dSeB= -21.4224


%% Read the data
% a20_readmodel

%% Read model 

% est.a0_dGoXOG=1.0;
% est.a0_dGoM=1.0;
% est.a0_NIL = 100;
% est.a0_NAA = 100;
% 
% P = get(m,'param');

m = model('reborn.mod', 'linear=',true); %?switch?
m = assign(m,P);
m = solve(m) %
m = sstate(m);%


%% Load observed data:
load(fullfile(out_dir,'processed_data.mat'),'obsdb');

%% Create obsdb of the observed data:
% P = get(m,'param');
m = assign(m,P);

[mfilt,filtdb,se2,delta,pe] = filter(m,obsdb,sfilt+1:efcast-1 );

%% Save the filtration results
save(fullfile(out_dir,'model_filtration.mat'), 'mfilt');
save(fullfile(out_dir,'filtered_dbase.mat'), 'filtdb');

fprintf('Filtration step completed\n');
