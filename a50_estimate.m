a11_roundParameters;
out_dir = ['results' filesep forecastRound];
if ~isdir(out_dir)&&~isempty(out_dir), mkdir(out_dir); end;


%% Filter model
% a30_filter;
sdate = sfilt;
edate = sfcast-1;

load(fullfile(out_dir,'model_filtration.mat'));
m = mfilt;

load(fullfile(out_dir,'filtered_dbase.mat'));
load(fullfile(out_dir,'processed_data.mat'),'obsdb');

obsList = get(m,'Ylist');

dd =  dbclip(filtdb.mean*obsList,sfilt:sfcast-1);

% % ========================================================================
% %           DEFINING PRIORS FOR THE VARIABLES OF INTEREST
% %           
% %           E.parameter_name = {starting,lower,upper,logdist}          
% %           
% %          GUIDE ON PRIOR SPECIFICATION
% %          BETWEEN 0 AND 1 BETA DISTRIBUTION
% %          STRICTLY GREATER THAN ZERO, GAMMA DISTRIBUTION
% %          ERROR TERMS, INVERSE GAMMA DISTRIBUTION
% %       
% % ========================================================================
%% 
E = struct();
usdbnr=1000;
nms =  get(m,'plist');

%do not estiamte:
donotestimate = {'oil_ss', 'y_f_ss', 'y_h_ss', 'rho_ss', 'rho_EM_ss', 'a_y_f','a_y_h','a_ir_f','a_ir_h', ...
    'a1_pia', 'a2_pia', 'a3_pia', 'a0_dGoXOG','a1_dGoXOG', 'a2_dGoXOG', 'a1_dGoXNOG', 'a2_dGoXNOG', ...
    'a3_dGoXNOG', 'a4_dGoXNOG', 'a5_dGoXNOG', ...
    'a1_dGoM','a2_dGoM', 'a3_dGoM'};
betalist = {'a_oil', 'a_rho_EM','a_rho'};

nms = setdiff(nms, donotestimate);
nms = setdiff(nms, betalist)

%%
for prm = 1 : length(nms)
    E.(nms{prm}) = {m.(nms{prm}),m.(nms{prm})-usdbnr, m.(nms{prm})+usdbnr, logdist.uniform(m.(nms{prm})-usdbnr, m.(nms{prm})+usdbnr)}
end
for prm = 1 : length(betalist)
    E.(betalist{ prm }) = {m.(betalist{prm}),0, 1, logdist.beta(m.(betalist{prm}),0.3)}
end

% for prm = 1 : length(betalist)
%     E.(betalist{prm}) = {m.(betalist{prm}), 0.1, 0.999999, logdist.beta(m.(betalist{prm}), 0.3)}
% end

% plot priors noSolution
% [est,pos,C,H,mest,v,delta,Pdelta] = estimate(m,dd,sdate+1:edate,E,'noSolution=','penalty' ,'filter',{'relative',true},'maxIter=',10000,'maxFunEvals=',10000);


[est,pos,C,H,mest,v,delta,Pdelta] = estimate(m,dd,sdate+1:edate,E,...
        'filter=',{'chkFmse=',true,'initCond=','stochastic','relative=',false},...
        'optimset=',{'tolfun=',1e-8,'tolx=',1e-8},...
        'optimizer=','fmin',...
        'maxfunevals=',1e+7,...
        'maxiter=',900,...
        'nosolution=','penalty')



%% Change the prior: 
get(mest,'params')