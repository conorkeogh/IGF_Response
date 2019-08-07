%% Get spreadsheet indices for specific subjects & trials
% Take in list of subjects x trials -> n x 2
% Output list of corresponding indices in spreadsheets

function indices = RTT_getindices(list)
%%
alltrials = xlsread('/Volumes/File Storage/EEG Project/Data/Results/includedlist.xlsx');
alltrials = alltrials(:, 1:2);

for i = 1:size(list,1)
    
    subj_ind = find(alltrials(:,1) == list(i,1));
    trial_ind = find(alltrials(:,2) == list(i,2));
    
    indices(i) = intersect(subj_ind, trial_ind);
end