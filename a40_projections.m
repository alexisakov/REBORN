%% Now do the conditional forecast as it should be done:
load(fullfile(out_dir,'filtered_dbase.mat'));
load(fullfile(out_dir,'processed_data.mat'),'obsdb');
load(fullfile(out_dir,'model_filtration.mat'));
m = mfilt;

%%
initdb.mean = dbclip(filtdb.mean,sfilt:sfcast-1);
initdb.std = dbclip(filtdb.std,sfilt:sfcast-1);
initdb.mse = filtdb.mse{sfilt:sfcast-1,:,:};
%% reparametrize

% m = mest;
% m.a2_NIL=3.0;
% m.a3_NIL=-100.0;
% m.a2_pia=80;
% m.a2_sia=30;
% m.a1_dGoM = -100.0878;
m = sstate(m);
m = solve(m)



%%
cond = initdb.mean;
p = plan(m, sfilt:efcast);

%% set oil terminal value
cond.Oil(sfcast) = 43;
cond.Oil(sfcast:sfcast+11) = linspace(cond.Oil(sfcast),50,12);
cond.Oil(sfcast+12:efcast) = 50;
p = exogenize(p, 'Oil', sfcast:get(cond.Oil,'end'));
p = endogenize(p, 'e_Oil', sfcast:get(cond.Oil,'end'));


rho = (1.02)^(0.25);
oilpriceline = arf(tseries(qq(2017,1),40),[1,-rho],tseries(qq(2017,1)+1:efcast,0),qq(2017,1)+1:efcast);
cond.ReA(sfcast:efcast) = (2300*(-oilpriceline(sfcast:efcast)+cond.Oil(sfcast:efcast)))/4; 
p = exogenize(p, 'ReA', sfcast:get(cond.ReA,'end'));
p = endogenize(p, 'e_ReA', sfcast:get(cond.ReA,'end'));

cond.rho(sfcast:efcast) =  110;
p = exogenize(p, 'rho', sfcast:get(cond.rho,'end'));
p = endogenize(p, 'e_rho', sfcast:get(cond.rho,'end'));


% cond.ir_f(sfcast-1:sfcast+10) =  linspace(cond.ir_f(sfcast-1),2.75,12);
% cond.ir_f(sfcast+11:efcast)=2.75;
% p = exogenize(p, 'ir_f', sfcast:get(cond.ir_f,'end'));
% p = endogenize(p, 'e_ir_f', sfcast:get(cond.ir_f,'end'));
% 
% cond.ir_h(sfcast-1:sfcast+6) =  linspace(cond.ir_h(sfcast-1),5.5,8);
% cond.ir_h(sfcast+7:efcast)=5.5;
% p = exogenize(p, 'ir_h', sfcast:get(cond.ir_h,'end'));
% p = endogenize(p, 'e_ir_h', sfcast:get(cond.ir_h,'end'));
% 
% cond.y_h(sfcast-1:sfcast+8) =  linspace(cond.y_h(sfcast-1),0.0,10);
% cond.y_h(sfcast+9:efcast)=0.0;
% p = exogenize(p, 'y_h', sfcast:get(cond.y_h,'end'));
% p = endogenize(p, 'e_y_h', sfcast:get(cond.y_h,'end'));
% 
% cond.y_f(sfcast-1:sfcast+8) =  linspace(cond.y_f(sfcast-1),0.0,10);
% cond.y_f(sfcast+9:efcast)=0.0;
% p = exogenize(p, 'y_f', sfcast:get(cond.y_f,'end'));
% p = endogenize(p, 'e_y_f', sfcast:get(cond.y_f,'end'));

%%
simdb = simulate(m, cond, sfcast:efcast, 'plan', p, 'anticipate', true);
fdb.mean = dbextend(initdb.mean,simdb); 
fdb.mean = reporting(m, fdb.mean, sfilt:efcast);

%% Save the results
dbsave([out_dir filesep 'bl_fcast.csv'],fdb.mean,get(fdb.mean.dUR,'range'), 'format','%f','class',false);
winopen([out_dir filesep 'bl_fcast.csv'])
fprintf('Projection step completed\n');

%% contributions
simdbhist = simulate(m, cond, sfcast:efcast, 'plan', p, 'anticipate', true,'contributions=',true);
hist=struct();

hist.rubhist=simdbhist.dUR; 

dbsave([out_dir filesep 'bl_fcasthist.csv'],hist,get(hist.rubhist,'range'), 'format','%f','class',false);
winopen([out_dir filesep 'bl_fcasthist.csv'])



