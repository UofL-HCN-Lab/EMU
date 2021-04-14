clear
clc

%% Loads in edf file
cfg.dataset = ('NRG~ test_dcb22a20-320f-4d7a-ab4c-ee61522e4b49.eeg')
eegData = ft_preprocessing(cfg);
%% Loads in MonkeyLogic data
[data,MLConfig,TrialRecord,filename,varlist] = mlread('20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');

%% Creates necessary variables for creating trials
plot(eegData.trial{1, 1}(1,:))
eegData = eegData.trial{1};
eegTrigger = eegData(145,:);
uniqueValues = unique(eegTrigger);
%% Establishes eegTrigger as a binary system. 1 = ongoing trial. 0 = inbetween trials.
eegTrigger(eegTrigger~=uniqueValues(4))=0;
eegTrigger(eegTrigger==uniqueValues(4))=1;
%% establishes necessary variables
eegIdx = find(eegTrigger == 1);
count = 0;
eegStart = [];
eegEnd = [];
%% Finds values of electrode 145 indicating a trial, records them and formats them for the cfg
plot([1:length(eegTrigger)],eegTrigger(:))
for a = 1:length(eegIdx)
    if a==1 %if its the first value (for which there is no reference point)
        eegStartCurrent = eegIdx(a);
        eegStart = [eegStart;eegStartCurrent];
        continue
    end
    if a==length(eegIdx) %if its the last value (for which there is no reference point)
        if length(eegEnd) == length(eegStart) %if the trials end with a start
            eegStartCurrent = eegIdx(a);
            eegStart = [eegStart;eegStartCurrent];
            break
        elseif length(eegStart) > length(eegEnd) %if the trials end with a end
            eegEndCurrent = eegIdx(a);
            eegEnd = [eegEnd;eegEndCurrent];
            break
        end
    end
    if eegIdx(a)~= eegIdx(a+1)-1 %if next value isn't +1 to current value
            eegStartCurrent = eegIdx(a+1);
            eegStart = [eegStart;eegStartCurrent];
            eegEndCurrent = eegIdx(a);
            eegEnd = [eegEnd;eegEndCurrent];
        end
end
%% Finds and eliminates flawed trials
eegDifferences = eegEnd-eegStart;
eegDifferencesIdx = find(eegDifferences > 100);
eegStart = eegStart(eegDifferencesIdx(:));
eegEnd = eegEnd(eegDifferencesIdx(:));
eegDifferences = eegDifferences(eegDifferencesIdx(:));
%% Generates offset and the nx3 matrix used for the trials
eegZeros = zeros(length(eegEnd),1);       
eegTrl = cat(2,eegStart,eegEnd,eegZeros);
%% Changes trl to new trial matrix and recreates data considering new trials
cfg.trl = eegTrl
cfg.channel = 'all';
cfg = ft_definetrial(cfg)
eegData = ft_preprocessing(cfg)

%%
eegStartDifferences = diff(eegStart)*2.048;
monkeyLogicStartTimes = diff([data.AbsoluteTrialStartTime])';
figure(1)
plot(eegStartDifferences(2:end))
hold on
plot(monkeyLogicStartTimes(2:end))
%%

% %% ASR
% %Clean data using Automatic Subspace Reconstruction (ASR)
% % EEG = clean_rawdata(EEG, arg_flatline, arg_highpass, arg_channel, arg_noisy, arg_burst, arg_window)
% EEG = clean_artifacts(eegData);
% % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% 
% EEG = clean_rawdata(eegData, 5, [-1], 0.8, 4, 5, -1);
% vis_artifacts(clean,raw);
% %%
% EEG = pop_interp(eegData, cpyEEG.chanlocs, 'spherical');
% pop_eegplot(cleanedEEG, 1, 1, 1);