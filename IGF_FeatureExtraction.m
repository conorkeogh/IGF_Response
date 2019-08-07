%{
Network Analysis: Impact of IGF-1 on Cortical Network Architecture

Script for:
Loading cleaned data
Feature extraction: power spectra, asymmetry measures, coherence measures

% Outputs 4-D structure: subjects x trials x channels x power at bands
% Bands in order: theta, alpha, beta, delta, gamma

Some discrete functions provided as separate scripts

Conor Keogh
Revised 07/08/19
%}
%% Load trial details:
dir = '/Volumes/File Storage/EEG Project/Data/';

file = [dir 'IGF_list.csv'];    % Load subject list
fid = fopen(file);

trial_details = textscan(fid, '%s', 'Delimiter', ',');

subjects = trial_details{1};
trials = trial_details{2};

%% Cycle through each trial for each subject

included_line = 1;
excluded_line = 1;

excluded_list=[]; % prevents crashing if none excluded...

for i = 1:length(subjects)

    disp(['Subject ', num2str(i)]);
    
    subj = subjects{i};
    trialnum = trials(i);
    
    for j = 1:trialnum
        
        disp(['Trial ', num2str(j)]);
        
        data = load([dir 'Pretreatment/Standardised/' subj '.mat']);
        eeg = data.eeg_standardised;

        epoch_start = 5 * 60 * 128;    % Remove first 5 minutes
        epoch_end = 15 * 60 * 128;  % Total duration 10 minutes
        
        try

            epoch = eeg(:, epoch_start:epoch_end);

            %% Calculate spectra: (requires EEGLab)
            [spectra, freqs] = spectopo(epoch, 0, 128);

            % Save spectra:
            all_spectra(i,j,:,:) = spectra;
            
            % Get average power for each frequency band for each channel:

            % Theta:
            theta_start_sample = find(freqs==3);
            theta_end_sample = find(freqs==7);

            % Alpha:
            alpha_start_sample = find(freqs==7);
            alpha_end_sample = find(freqs==14);

            % Beta:
            beta_start_sample = find(freqs==14);
            beta_end_sample = find(freqs==20);

            % Delta:
            delta_start_sample = find(freqs==0.5);
            delta_end_sample = find(freqs==3);

            % Gamma:
            gamma_start_sample = find(freqs==20);
            gamma_end_sample = find(freqs==40);

            % Get power in each band for each channel:
            for k = 1:size(spectra, 1)

                disp(['Channel ', num2str(k)]);

                theta_spectrum = spectra(k, theta_start_sample:theta_end_sample);
                [avg_theta, std_theta] = normfit(theta_spectrum);

                alpha_spectrum = spectra(k, alpha_start_sample:alpha_end_sample);
                [avg_alpha, std_alpha] = normfit(alpha_spectrum);

                beta_spectrum = spectra(k, beta_start_sample:beta_end_sample);
                [avg_beta, std_beta] = normfit(beta_spectrum);

                delta_spectrum = spectra(k, delta_start_sample:delta_end_sample);
                [avg_delta, std_delta] = normfit(delta_spectrum);

                gamma_spectrum = spectra(k, gamma_start_sample:gamma_end_sample);
                [avg_gamma, std_gamma] = normfit(gamma_spectrum);
                
                % Get proper overall:
                [avg_overall, std_overall] = normfit(spectra(k,:));

                powerbands_allsubj(i, j, k, :) = [avg_theta, avg_alpha, avg_beta, avg_delta, avg_gamma, avg_overall];
                std_powerbands_allsubj(i, j, k, :) = [std_theta, std_alpha, std_beta, std_delta, std_gamma, std_overall];
            end
            
        % Get coherence measures for all electrode pairs:
        for elecone = 1:8
            for electwo = 1:8
                [cohere_allpairs(i, j, elecone, electwo, :), cohere_freqs] = mscohere(epoch(elecone, :), epoch(electwo, :), [], [], [], 128);
            end
        end
        
        % List included trials:
        included_list(included_line,:) = [i, j];
        included_line = included_line + 1;
            
        catch
            % If failed (i.e. trial not long enough: just add zeros to
            % overall structure
            disp(['FAILED - ', subj, ' TRIAL ', num2str(j)]);
            powerbands_allsubj(i, j, k, :) = [0, 0, 0, 0, 0];
            std_powerbands_allsubj(i, j, k, :) = [0, 0, 0, 0, 0];
            
            all_spectra(i,j,:,:) = zeros(8,513);
            
            excluded_list(excluded_line,:) = [i, j];
            excluded_line = excluded_line + 1;
        end
            
    end
end

disp('DONE');

avg = powerbands_allsubj;
std = std_powerbands_allsubj;
save([dir '/Pretreatment/Results/powerbands.mat'], 'avg', 'std');
save([dir 'Pretreatment/Results/spectra.mat'], 'all_spectra', 'freqs');
save([dir 'Pretreatment/Results/coherence.mat'], 'cohere_allpairs', 'cohere_lfrontrfront', 'cohere_lfrontlocc', 'cohere_freqs', '-v7.3');
save([dir 'Pretreatment/Results/includedlist.mat'], 'included_list', 'excluded_list');
disp('Saved');

%% Asymmetry Measures
% Compare power in each band left vs. right
% For each subject, for each trial, for each band

for i = 1:size(powerbands_allsubj, 1)
    
    for j = 1:size(powerbands_allsubj, 2)
        
        for k = 1:size(powerbands_allsubj, 4)
            
            thisband = powerbands_allsubj(i, j, :, k);
            thisband = squeeze(thisband);
            
            % Get asymmetry measures for each electrode:
            % Fp1 - Fp2, C3 - C4, T3 - T4, O1 - O2
            asym_frontal = thisband(5) - thisband(1);
            asym_parietal = thisband(6) - thisband(2);
            asym_temporal = thisband(7) - thisband(4);
            asym_occipital = thisband(8) - thisband(3);
            
            % Get overall asymmetry:
            all_left = sum(thisband([5, 6, 7, 8]));
            all_right = sum(thisband([1, 2, 4, 3]));
            asym_overall = all_left - all_right;
            
            asymmetry(i, j, k, :) = [asym_frontal, asym_parietal, asym_temporal, asym_occipital, asym_overall];
            
        end
    end
end

save([dir '/Pretreatment/Results/asymmetry.mat'], 'asymmetry');
% Subject x trial x band x comparison (4 x electrode - electrode, 1 x all
% left - all right)