%{
Network Analysis: Impact of IGF-1 on Cortical Network Architecture

Script for:
Loading raw data
Cleaning data
Applying filters etc.
Preparing for feature extraction

Some discrete functions provided as separate scripts

Conor Keogh
Revised 07/08/19
%}

dir = '/Volumes/File Storage/EEG Project/Data/';

file = 'Pretreatment/responder_list.csv';
fid = fopen(file);

trial_details = textscan(fid, '%s', 'Delimiter', ',');

subjects = trial_details{1};
trials = trial_details{2};

for i = 1:length(subjects)
    subj = subjects{i};
    disp(['Processing subject: ' subj]);
    

    file = [dir 'Pretreatment/Decimal/' subj '.csv'];
    eeg = csvread(file);
    eeg = eeg';
    
    %disp(['Trial ' num2str(j)]);
    eeg = IGF_Preprocess(eeg);
    
    save([dir 'Pretreatment/Preprocessed/' subj '.mat'], 'eeg');
    disp('Saved');
    
end

disp('DONE');