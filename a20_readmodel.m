%% Don't run this file - it is run from the filter file
% a11_roundParameters;
out_dir = ['results' filesep forecastRound];
if ~isdir(out_dir)&&~isempty(out_dir), mkdir(out_dir); end;

obsdb = dbload(fullfile(out_dir,'reborninp.csv'));

save(fullfile(out_dir,'processed_data.mat'),'obsdb');

fprintf('Data import step completed\n');