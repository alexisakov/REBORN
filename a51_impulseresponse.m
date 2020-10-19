a11_roundParameters;
out_dir = ['results' filesep forecastRound];
if ~isdir(out_dir)&&~isempty(out_dir), mkdir(out_dir); end;

%%
load(fullfile(out_dir,'model_filtration.mat'));
m = mfilt;
mfilt = solve(mfilt);
mfilt = sstate(mfilt);

%%
var2plot = {'dUR','TB'}; %,'U_GAP','WR_GAP'
shkList = {'e_Oil','e_rho','e_rho_EM','e_y_f'};%RES_LS_USD, 'RES_DOT_W','RES_U_GAP'

%% simulating shocks
sdb = cell(size(shkList));
for ix = 1 : length(shkList)
  sdb{ix} = srf(mfilt,50,'select',shkList{ix},'size=',1);
end

sdb = cell(size(shkList));
for ix = 1 : length(shkList)
  sdb{ix} = srf(mfilt,12,'select',shkList{ix},'size=',@auto);
end

close all;
for ix = 1 : length(shkList)
      dbplot(sdb{ix},var2plot,inf,'zeroLine=',true,'lineWidth',2);
end
figure;


figure;
plot([sdb{1}.y_gap -sdb{4}.y_gap ])