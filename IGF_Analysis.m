%{
Network Analysis: Impact of IGF-1 on Cortical Network Architecture

Script for:
Loading derived EEG features
Deriving network model
Visualising networks
Comparing network measures between treated & untreated groups
Predicting treatment response based on network measures

Raw data loaded, cleaned & features extracted in accompanying script
Some discrete functions provided as separate scripts

Conor Keogh
Revised 07/08/19
%}

%%%%%%%%%%%%%%%%%%%%%%%%
%% Treated vs. Untreated
%%%%%%%%%%%%%%%%%%%%%%%%

%% Load data
dir = '/Volumes/File Storage/EEG Project/Data/';

all_RTT_power = xlsread([dir 'Results/bands_sheet.xls']);
all_RTT_asymmetry = xlsread([dir 'Results/asymmetry_sheet.xls']);
all_RTT_coherence = xlsread([dir 'Results/coherence_sheet.xlsx']);

all_spectra_data = load([dir 'Results/spectra.mat']);
all_spectra = all_spectra_data.all_spectra;
freqs = all_spectra_data.freqs;

%% Set up groups
treated_t1 = [14, 1; 5, 1; 10, 1; 13, 1; 27, 1; 29, 1; 36, 1; 40, 1; 42, 1];
treated_t2 = [14, 5; 5, 4; 10, 4; 13, 3; 27, 2; 29, 3; 36, 4; 40, 6; 42, 3];

untreated_t1 = [11, 1; 15, 1; 22, 1; 24, 1; 30, 1; 39, 4; 44, 1; 16, 1; 17, 1];
untreated_t2 = [11, 2; 15, 2; 22, 2; 24, 2; 30, 2; 39, 5; 44, 2; 16, 2; 17, 3];


treated_t1_inds = RTT_getindices(treated_t1);
treated_t2_inds = RTT_getindices(treated_t2);
untreated_t1_inds = RTT_getindices(untreated_t1);
untreated_t2_inds = RTT_getindices(untreated_t2);

treated_t1_power = all_RTT_power(treated_t1_inds, 3:end);
treated_t1_asymmetry = all_RTT_asymmetry(treated_t1_inds, 3:end);
treated_t1_coherence = all_RTT_coherence(treated_t1_inds, 3:end);

treated_t2_power = all_RTT_power(treated_t2_inds, 3:end);
treated_t2_asymmetry = all_RTT_asymmetry(treated_t2_inds, 3:end);
treated_t2_coherence = all_RTT_coherence(treated_t2_inds, 3:end);

untreated_t1_power = all_RTT_power(untreated_t1_inds, 3:end);
untreated_t1_asymmetry = all_RTT_asymmetry(untreated_t1_inds, 3:end);
untreated_t1_coherence = all_RTT_coherence(untreated_t1_inds, 3:end);

untreated_t2_power = all_RTT_power(untreated_t2_inds, 3:end);
untreated_t2_asymmetry = all_RTT_asymmetry(untreated_t2_inds, 3:end);
untreated_t2_coherence = all_RTT_coherence(untreated_t2_inds, 3:end);

%% Treated vs. Untreated, T1

for i = 1:size(treated_t1_power,2)
    [p_power(i), h_power(i), stats_power{i}] = ranksum(treated_t1_power(:,i), untreated_t1_power(:,i));
end

for i = 1:size(treated_t1_asymmetry,2)
    [p_asymmetry(i), h_asymmetry(i), stats_asymmetry{i}] = ranksum(treated_t1_asymmetry(:,i), untreated_t1_asymmetry(:,i));
end

for i = 1:size(treated_t1_coherence,2)
    [p_coherence(i), h_coherence(i), stats_coherence{i}] = ranksum(treated_t1_coherence(:,i), untreated_t1_coherence(:,i));
end

%% Do comparisons
columnlabels = {'Treated1', 'Untreated1', 'p'};

%% Power
% Get mean & SD of significantly different values:

sig_inds = find(p_power < 0.05);
%sig_inds = find(p_power > 0.00);    % Get all for results summary table

g1_sig = treated_t1_power(:, sig_inds);
g2_sig = untreated_t1_power(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_power(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idbands(sig_inds);

powertable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(powertable, [dir 'Results/Extra Figures/Tables/Treated_Untreated_T1_power.csv']);
%% Asymmetry
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_asymmetry < 0.05);
%sig_inds = find(p_asymmetry > 0.00);

g1_sig = treated_t1_asymmetry(:, sig_inds);
g2_sig = untreated_t1_asymmetry(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_asymmetry(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idasym(sig_inds);

asymmetrytable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(asymmetrytable, [dir 'Results/Extra Figures/Tables/Treated_Untreated_T1_asymmetry.csv']);
%% Coherence
% Get mean & SD of significantly different values:

sig_inds = find(p_coherence < 0.05);
%sig_inds = find(p_coherence > 0.00);

g1_sig = treated_t1_coherence(:, sig_inds);
g2_sig = untreated_t1_coherence(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_coherence(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idcoherence(sig_inds);

coherencetable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(coherencetable, [dir 'Results/Extra Figures/Tables/Treated_Untreated_T1_coherence.csv']);

treated_t1_cov = cov(treated_t1_coherence);
untreated_t1_cov = cov(untreated_t1_coherence);

[resp_coef, resp_lat, resp_exp] = pcacov(treated_t1_cov);
[none_coef, none_lat, none_exp] = pcacov(untreated_t1_cov);

treated_untreated_t1_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/treated_t1_cov.csv'], treated_t1_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t1_cov.csv'], untreated_t1_cov);

% Overall only:
treated_t1_coherence_overall = treated_t1_coherence(:, 141:end);
untreated_t1_coherence_overall = untreated_t1_coherence(:, 141:end);

treated_t1_overall_cov = cov(treated_t1_coherence_overall);
untreated_t1_overall_cov = cov(untreated_t1_coherence_overall);

[resp_coef, resp_lat, resp_exp] = pcacov(treated_t1_overall_cov);
[none_coef, none_lat, none_exp] = pcacov(untreated_t1_overall_cov);

treated_untreated_t1_overall_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/treated_t1_overall_cov.csv'], treated_t1_overall_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t1_overall_cov.csv'], untreated_t1_overall_cov);

%% Treated vs. Untreated, T2

for i = 1:size(treated_t2_power,2)
    [p_power(i), h_power(i), stats_power{i}] = ranksum(treated_t2_power(:,i), untreated_t2_power(:,i));
end

for i = 1:size(treated_t2_asymmetry,2)
    [p_asymmetry(i), h_asymmetry(i), stats_asymmetry{i}] = ranksum(treated_t2_asymmetry(:,i), untreated_t2_asymmetry(:,i));
end

for i = 1:size(treated_t2_coherence,2)
    [p_coherence(i), h_coherence(i), stats_coherence{i}] = ranksum(treated_t2_coherence(:,i), untreated_t2_coherence(:,i));
end

%% Do comparisons
columnlabels = {'Treated2', 'Untreated2', 'p'};

%% Power
% Get mean & SD of significantly different values:

sig_inds = find(p_power < 0.05);
%sig_inds = find(p_power > 0.00);    % Get all for results table

g1_sig = treated_t2_power(:, sig_inds);
g2_sig = untreated_t2_power(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_power(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idbands(sig_inds);

powertable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(powertable, [dir 'Results/Extra Figures/Tables/Treated_Untreated_t2_power.csv']);
%% Asymmetry
% Get mean & SD of significantly different values:

sig_inds = find(p_asymmetry < 0.05);
%sig_inds = find(p_asymmetry > 0.00);

g1_sig = treated_t2_asymmetry(:, sig_inds);
g2_sig = untreated_t2_asymmetry(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_asymmetry(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idasym(sig_inds);

asymmetrytable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(asymmetrytable, [dir 'Results/Extra Figures/Tables/Treated_Untreated_t2_asymmetry.csv']);
%% Coherence
% Get mean & SD of significantly different values:

sig_inds = find(p_coherence < 0.05);
%sig_inds = find(p_coherence > 0.00);

g1_sig = treated_t2_coherence(:, sig_inds);
g2_sig = untreated_t2_coherence(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_coherence(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idcoherence(sig_inds);

coherencetable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(coherencetable, [dir 'Results/Extra Figures/Tables/Treated_Untreated_t2_coherence.csv']);

treated_t2_cov = cov(treated_t2_coherence);
untreated_t2_cov = cov(untreated_t2_coherence);

[resp_coef, resp_lat, resp_exp] = pcacov(treated_t2_cov);
[none_coef, none_lat, none_exp] = pcacov(untreated_t2_cov);

treated_untreated_t2_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/treated_t2_cov.csv'], treated_t2_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t2_cov.csv'], untreated_t2_cov);

% Overall only:
treated_t2_coherence_overall = treated_t2_coherence(:, 141:end);
untreated_t2_coherence_overall = untreated_t2_coherence(:, 141:end);

treated_t2_overall_cov = cov(treated_t2_coherence_overall);
untreated_t2_overall_cov = cov(untreated_t2_coherence_overall);

[resp_coef, resp_lat, resp_exp] = pcacov(treated_t2_overall_cov);
[none_coef, none_lat, none_exp] = pcacov(untreated_t2_overall_cov);

treated_untreated_t2_overall_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/treated_t2_overall_cov.csv'], treated_t2_overall_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t2_overall_cov.csv'], untreated_t2_overall_cov);


%% Treated T1 vs. Treated T2

for i = 1:size(treated_t1_power,2)
    [p_power(i), h_power(i), stats_power{i}] = signrank(treated_t1_power(:,i), treated_t2_power(:,i));
end

for i = 1:size(treated_t1_asymmetry,2)
    [p_asymmetry(i), h_asymmetry(i), stats_asymmetry{i}] = signrank(treated_t1_asymmetry(:,i), treated_t2_asymmetry(:,i));
end

for i = 1:size(treated_t1_coherence,2)
    [p_coherence(i), h_coherence(i), stats_coherence{i}] = signrank(treated_t1_coherence(:,i), treated_t2_coherence(:,i));
end

%% Do comparisons
columnlabels = {'Treated1', 'Treated2', 'p'};

%% Power
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_power < 0.05);
%sig_inds = find(p_power > 0.00);    % Get all for results table

g1_sig = treated_t1_power(:, sig_inds);
g2_sig = treated_t2_power(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_power(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idbands(sig_inds);

powertable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(powertable, [dir 'Results/Extra Figures/Tables/Treated1_treated2_power.csv']);
%% Asymmetry
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_asymmetry < 0.05);
%sig_inds = find(p_asymmetry > 0.00);

g1_sig = treated_t1_asymmetry(:, sig_inds);
g2_sig = treated_t2_asymmetry(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_asymmetry(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idasym(sig_inds);

asymmetrytable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(asymmetrytable, [dir 'Results/Extra Figures/Tables/Treated1_treated2_asymmetry.csv']);
%% Coherence
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_coherence < 0.05);
%sig_inds = find(p_coherence > 0.00);

g1_sig = treated_t1_coherence(:, sig_inds);
g2_sig = treated_t2_coherence(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_coherence(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idcoherence(sig_inds);

coherencetable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(coherencetable, [dir 'Results/Extra Figures/Tables/Treated1_treated2_coherence.csv']);

treated_t1_cov = cov(treated_t1_coherence);
treated_t2_cov = cov(treated_t2_coherence);

[resp_coef, resp_lat, resp_exp] = pcacov(treated_t1_cov);
[none_coef, none_lat, none_exp] = pcacov(treated_t2_cov);

treated_treated_t2_pca_p = signrank(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/treated_t1_cov.csv'], treated_t1_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/treated_t2_cov.csv'], treated_t2_cov);

% Overall only:
treated_t1_coherence_overall = treated_t1_coherence(:, 141:end);
treated_t2_coherence_overall = treated_t2_coherence(:, 141:end);

treated_t1_overall_cov = cov(treated_t1_coherence_overall);
treated_t2_overall_cov = cov(treated_t2_coherence_overall);

[resp_coef, resp_lat, resp_exp] = pcacov(treated_t1_overall_cov);
[none_coef, none_lat, none_exp] = pcacov(treated_t2_overall_cov);

treated_t1t2_overall_pca_p = signrank(resp_coef(:,1), none_coef(:,1))

csvwrite(['/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/treated_t1_overall_cov.csv'], treated_t1_overall_cov);
csvwrite(['/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/treated_t2_overall_cov.csv'], treated_t2_overall_cov);


%% Untreated T1 vs. Untreated T2

for i = 1:size(untreated_t1_power,2)
    [p_power(i), h_power(i), stats_power{i}] = signrank(untreated_t1_power(:,i), untreated_t2_power(:,i));
end

for i = 1:size(untreated_t1_asymmetry,2)
    [p_asymmetry(i), h_asymmetry(i), stats_asymmetry{i}] = signrank(untreated_t1_asymmetry(:,i), untreated_t2_asymmetry(:,i));
end

for i = 1:size(untreated_t1_coherence,2)
    [p_coherence(i), h_coherence(i), stats_coherence{i}] = signrank(untreated_t1_coherence(:,i), untreated_t2_coherence(:,i));
end

%% Do comparisons
columnlabels = {'Untreated1', 'Untreated2', 'p'};

%% Power
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_power < 0.05);
%sig_inds = find(p_power > 0.00);    % Get all for results table

g1_sig = untreated_t1_power(:, sig_inds);
g2_sig = untreated_t2_power(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_power(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idbands(sig_inds);

powertable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(powertable, [dir 'Results/Extra Figures/Tables/untreated1_untreated2_power.csv']);
%% Asymmetry
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_asymmetry < 0.05);
%sig_inds = find(p_asymmetry > 0.00);

g1_sig = untreated_t1_asymmetry(:, sig_inds);
g2_sig = untreated_t2_asymmetry(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_asymmetry(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idasym(sig_inds);

asymmetrytable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(asymmetrytable, [dir 'Results/Extra Figures/Tables/untreated1_untreated2_asymmetry.csv']);
%% Coherence
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_coherence < 0.05);
%sig_inds = find(p_coherence > 0.00);

g1_sig = untreated_t1_coherence(:, sig_inds);
g2_sig = untreated_t2_coherence(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_coherence(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idcoherence(sig_inds);

coherencetable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)
writetable(coherencetable, [dir 'Results/Extra Figures/Tables/untreated1_untreated2_coherence.csv']);

untreated_t1_cov = cov(untreated_t1_coherence);
untreated_t2_cov = cov(untreated_t2_coherence);

[resp_coef, resp_lat, resp_exp] = pcacov(untreated_t1_cov);
[none_coef, none_lat, none_exp] = pcacov(untreated_t2_cov);

untreated_untreated_t2_pca_p = signrank(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t1_cov.csv'], untreated_t1_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t2_cov.csv'], untreated_t2_cov);

% Overall only:
untreated_t1_coherence_overall = untreated_t1_coherence(:, 141:end);
untreated_t2_coherence_overall = untreated_t2_coherence(:, 141:end);

untreated_t1_overall_cov = cov(untreated_t1_coherence_overall);
untreated_t2_overall_cov = cov(untreated_t2_coherence_overall);

[resp_coef, resp_lat, resp_exp] = pcacov(untreated_t1_overall_cov);
[none_coef, none_lat, none_exp] = pcacov(untreated_t2_overall_cov);

untreated_t1t2_overall_pca_p = signrank(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t1_overall_cov.csv'], untreated_t1_overall_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/untreated_t2_overall_cov.csv'], untreated_t2_overall_cov);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Responders vs. Nonresponders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load data
responders = [1,2,5,6,9];
nonresponders = [3,4,7,8];

resp_power = treated_t1_power(responders,:);
resp_asymmetry = treated_t1_asymmetry(responders,:);
resp_coherence = treated_t1_coherence(responders,:);

none_power = treated_t1_power(nonresponders,:);
none_asymmetry = treated_t1_asymmetry(nonresponders,:);
none_coherence = treated_t1_coherence(nonresponders,:);

resp_t2_power = treated_t2_power(responders,:);
resp_t2_asymmetry = treated_t2_asymmetry(responders,:);
resp_t2_coherence = treated_t2_coherence(responders,:);

none_t2_power = treated_t2_power(nonresponders,:);
none_t2_asymmetry = treated_t2_asymmetry(nonresponders,:);
none_t2_coherence = treated_t2_coherence(nonresponders,:);
%% Compare responder vs. nonresponder groups

for i = 1:size(resp_power,2)
    [p_power(i), h_power(i), stats_power{i}] = ranksum(resp_power(:,i), none_power(:,i));
end

for i = 1:size(resp_asymmetry,2)
    [p_asymmetry(i), h_asymmetry(i), stats_asymmetry{i}] = ranksum(resp_asymmetry(:,i), none_asymmetry(:,i));
end

for i = 1:size(resp_coherence,2)
    [p_coherence(i), h_coherence(i), stats_coherence{i}] = ranksum(resp_coherence(:,i), none_coherence(:,i));
end

%% Do comparisons
columnlabels = {'Responder', 'NonResponder', 'p'};

%% Power
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_power < 0.05);
%sig_inds = find(p_power > 0.00);

g1_sig = resp_power(:, sig_inds);
g2_sig = none_power(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_power(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idbands(sig_inds);

powertable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)

%% Asymmetry
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_asymmetry < 0.05);
%sig_inds = find(p_asymmetry > 0.00);

g1_sig = resp_asymmetry(:, sig_inds);
g2_sig = none_asymmetry(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_asymmetry(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idasym(sig_inds);

asymmetrytable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)

%% Coherence
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_coherence < 0.05);
%sig_inds = find(p_coherence > 0.00);

g1_sig = resp_coherence(:, sig_inds);
g2_sig = none_coherence(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_coherence(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idcoherence(sig_inds);

coherencetable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)

resp_cov = cov(resp_coherence);
none_cov = cov(none_coherence);

[resp_coef, resp_lat, resp_exp] = pcacov(resp_cov);
[none_coef, none_lat, none_exp] = pcacov(none_cov);

resp_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/resp_cov.csv'], resp_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/none_cov.csv'], none_cov);

% Overall only:
resp_coherence_overall = resp_coherence(:, 141:end);
none_coherence_overall = none_coherence(:, 141:end);

resp_overall_cov = cov(resp_coherence_overall);
none_overall_cov = cov(none_coherence_overall);

[resp_coef, resp_lat, resp_exp] = pcacov(resp_overall_cov);
[none_coef, none_lat, none_exp] = pcacov(none_overall_cov);

resp_none_overall_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/resp_overall_cov.csv'], resp_overall_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/none_overall_cov.csv'], none_overall_cov);

%% Compare responder vs. nonresponder groups, T2

for i = 1:size(resp_t2_power,2)
    [p_power(i), h_power(i), stats_power{i}] = ranksum(resp_t2_power(:,i), none_t2_power(:,i));
end

for i = 1:size(resp_t2_asymmetry,2)
    [p_asymmetry(i), h_asymmetry(i), stats_asymmetry{i}] = ranksum(resp_t2_asymmetry(:,i), none_t2_asymmetry(:,i));
end

for i = 1:size(resp_t2_coherence,2)
    [p_coherence(i), h_coherence(i), stats_coherence{i}] = ranksum(resp_t2_coherence(:,i), none_t2_coherence(:,i));
end

%% Do comparisons
columnlabels = {'Responder2', 'NonResponder2', 'p'};

%% Power
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_power < 0.05);
%sig_inds = find(p_power > 0.00);

g1_sig = resp_t2_power(:, sig_inds);
g2_sig = none_t2_power(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_power(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idbands(sig_inds);

powertable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)

%% Asymmetry
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_asymmetry < 0.05);
%sig_inds = find(p_asymmetry > 0.00);

g1_sig = resp_t2_asymmetry(:, sig_inds);
g2_sig = none_t2_asymmetry(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_asymmetry(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idasym(sig_inds);

asymmetrytable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)

%% Coherence
% Get mean & SD of significantly different values:
% Present table
sig_inds = find(p_coherence < 0.05);
%sig_inds = find(p_coherence > 0.00);

g1_sig = resp_t2_coherence(:, sig_inds);
g2_sig = none_t2_coherence(:, sig_inds);


mean_g1_sig = mean(g1_sig,1);
mean_g2_sig = mean(g2_sig,1);

std_g1_sig = std(g1_sig);
std_g2_sig = std(g2_sig);

p_sig = p_coherence(sig_inds);

tablevals_g1 = cell(1,length(sig_inds));
tablevals_g2 = cell(1,length(sig_inds));

for j = 1:length(sig_inds)
    tablevals_g1{j} = [num2str(mean_g1_sig(j)) ' +/- ' num2str(std_g1_sig(j))];
    tablevals_g2{j} = [num2str(mean_g2_sig(j)) ' +/- ' num2str(std_g2_sig(j))];
end

rowlabels = RTT_idcoherence(sig_inds);

coherencetable = table(tablevals_g1', tablevals_g2', p_sig', 'RowNames', rowlabels, 'VariableNames', columnlabels)

resp_t2_cov = cov(resp_t2_coherence);
none_t2_cov = cov(none_t2_coherence);

[resp_coef, resp_lat, resp_exp] = pcacov(resp_t2_cov);
[none_coef, none_lat, none_exp] = pcacov(none_t2_cov);

resp_none_t2_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/resp_t2_cov.csv'], resp_t2_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/none_t2_cov.csv'], none_t2_cov);

% Overall only:
resp_t2_coherence_overall = resp_t2_coherence(:, 141:end);
none_t2_coherence_overall = none_t2_coherence(:, 141:end);

resp_t2_overall_cov = cov(resp_t2_coherence_overall);
none_t2_overall_cov = cov(none_t2_coherence_overall);

[resp_coef, resp_lat, resp_exp] = pcacov(resp_t2_overall_cov);
[none_coef, none_lat, none_exp] = pcacov(none_t2_overall_cov);

resp_none_t2_overall_pca_p = ranksum(resp_coef(:,1), none_coef(:,1))

csvwrite([dir 'Results/Extra Figures/Covariance/resp_t2_overall_cov.csv'], resp_t2_overall_cov);
csvwrite([dir 'Results/Extra Figures/Covariance/none_t2_overall_cov.csv'], none_t2_overall_cov);

%% Prep results for plotting
% Power:
resp_power_matrix = mean(resp_power,1);
resp_power_matrix = reshape(resp_power_matrix, 6,11);

none_power_matrix = mean(none_power,1);
none_power_matrix = reshape(none_power_matrix, 6,11);

% Asymmetry 
resp_asymmetry_matrix = mean(resp_asymmetry,1);
resp_asymmetry_matrix = reshape(resp_asymmetry_matrix, 6,5);

none_asymmetry_matrix = mean(none_asymmetry,1);
none_asymmetry_matrix = reshape(none_asymmetry_matrix, 6,5);


% Coherence:
resp_coherence_matrix = mean(resp_coherence,1);
resp_coherence_matrix_theta = resp_coherence_matrix(1:28);
resp_coherence_matrix_alpha = resp_coherence_matrix(29:56);
resp_coherence_matrix_beta = resp_coherence_matrix(57:84);
resp_coherence_matrix_delta = resp_coherence_matrix(65:112);
resp_coherence_matrix_gamma = resp_coherence_matrix(113:140);
resp_coherence_matrix_overall = resp_coherence_matrix(141:168);

resp_coherence_matrix_theta = RTT_reshapecoherence(resp_coherence_matrix_theta);
resp_coherence_matrix_alpha = RTT_reshapecoherence(resp_coherence_matrix_alpha);
resp_coherence_matrix_beta = RTT_reshapecoherence(resp_coherence_matrix_beta);
resp_coherence_matrix_delta = RTT_reshapecoherence(resp_coherence_matrix_delta);
resp_coherence_matrix_gamma = RTT_reshapecoherence(resp_coherence_matrix_gamma);
resp_coherence_matrix_overall = RTT_reshapecoherence(resp_coherence_matrix_overall);

none_coherence_matrix = mean(none_coherence,1);
none_coherence_matrix_theta = none_coherence_matrix(1:28);
none_coherence_matrix_alpha = none_coherence_matrix(29:56);
none_coherence_matrix_beta = none_coherence_matrix(57:84);
none_coherence_matrix_delta = none_coherence_matrix(65:112);
none_coherence_matrix_gamma = none_coherence_matrix(113:140);
none_coherence_matrix_overall = none_coherence_matrix(141:168);

none_coherence_matrix_theta = RTT_reshapecoherence(none_coherence_matrix_theta);
none_coherence_matrix_alpha = RTT_reshapecoherence(none_coherence_matrix_alpha);
none_coherence_matrix_beta = RTT_reshapecoherence(none_coherence_matrix_beta);
none_coherence_matrix_delta = RTT_reshapecoherence(none_coherence_matrix_delta);
none_coherence_matrix_gamma = RTT_reshapecoherence(none_coherence_matrix_gamma);
none_coherence_matrix_overall = RTT_reshapecoherence(none_coherence_matrix_overall);

%% Save data for plotting:
csvwrite([dir 'Results/Power/Data/resp_power_matrix.csv'], resp_power_matrix);
csvwrite([dir 'Results/Asymmetry/Data/resp_asymmetry_matrix.csv'], resp_asymmetry_matrix);
csvwrite([dir 'Results/Coherence/Data/resp_coherence_matrix_theta.csv'], resp_coherence_matrix_theta);
csvwrite([dir 'Results/Coherence/Data/resp_coherence_matrix_alpha.csv'], resp_coherence_matrix_alpha);
csvwrite([dir 'Results/Coherence/Data/resp_coherence_matrix_beta.csv'], resp_coherence_matrix_beta);
csvwrite([dir 'Results/Coherence/Data/resp_coherence_matrix_delta.csv'], resp_coherence_matrix_delta);
csvwrite([dir 'Results/Coherence/Data/resp_coherence_matrix_gamma.csv'], resp_coherence_matrix_gamma);
csvwrite([dir 'Results/Coherence/Data/resp_coherence_matrix_overall.csv'], resp_coherence_matrix_overall);

csvwrite([dir 'Results/Power/Data/none_power_matrix.csv'], none_power_matrix);
csvwrite([dir 'Results/Asymmetry/Data/none_asymmetry_matrix.csv'], none_asymmetry_matrix);
csvwrite([dir 'Results/Coherence/Data/none_coherence_matrix_theta.csv'], none_coherence_matrix_theta);
csvwrite([dir 'Results/Coherence/Data/none_coherence_matrix_alpha.csv'], none_coherence_matrix_alpha);
csvwrite([dir 'Results/Coherence/Data/none_coherence_matrix_beta.csv'], none_coherence_matrix_beta);
csvwrite([dir 'Results/Coherence/Data/none_coherence_matrix_delta.csv'], none_coherence_matrix_delta);
csvwrite([dir 'Results/Coherence/Data/none_coherence_matrix_gamma.csv'], none_coherence_matrix_gamma);
csvwrite([dir 'Results/Coherence/Data/none_coherence_matrix_overall.csv'], none_coherence_matrix_overall);

%% Demographics
age_treated = [10, 4, 3, 4, 3, 10, 9, 4, 6];
fu_treated = [14, 13, 11, 7, 12, 7, 15, 13, 14];
ISS1_treated = [12, 18, 21, 21, 12, 19, 19, 14, 20];
ISS2_treated = [11, 13, 21, 22, 10, 13, 19, 14, 15];
PVZ1_treated = [23, 39, 43, 35, 22, 35, 38, 33, 42];
PVZ2_treated = [20, 31, 42, 35, 21, 27, 39, 33, 32];

age_untreated = [2, 2, 8, 14, 6, 10, 12, 12, 5];
fu_untreated = [4, 11, 13, 16, 18, 12, 12, 12, 12];
ISS1_untreated = [12, 13, 20, 14, 19, 27, 20, 22, 11];
ISS2_untreated = [16, 18, 19, 13, 19, 28, 23, 22, 11];
PVZ1_untreated = [30, 44, 42, 29];
PVZ2_untreated = [28, 46, 46, 29];

age_responders = age_treated(responders);
fu_responders = fu_treated(responders);
ISS1_responders = ISS1_treated(responders);
ISS2_responders = ISS2_treated(responders);
PVZ1_responders = PVZ1_treated(responders);
PVZ2_responders = PVZ2_treated(responders);

age_nonresponders = age_treated(nonresponders);
fu_nonresponders = fu_treated(nonresponders);
ISS1_nonresponders = ISS1_treated(nonresponders);
ISS2_nonresponders = ISS2_treated(nonresponders);
PVZ1_nonresponders = PVZ1_treated(nonresponders);
PVZ2_nonresponders = PVZ2_treated(nonresponders);

