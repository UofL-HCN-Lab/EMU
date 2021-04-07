clear
clc

%% Loads in edf file
cfg.dataset = ('test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf')
eegData = ft_preprocessing(cfg);
%% Creates necessary variables for creating trials
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
eegDifferences = find(eegDifferences > 500);
eegStart = eegStart(eegDifferences(:));
eegEnd = eegEnd(eegDifferences(:));
%% Generates offset and the nx3 matrix used for the trials
eegZeros = zeros(length(eegEnd),1);       
eegTrl = cat(2,eegStart,eegEnd,eegZeros);
%% Changes trl to new trial matrix and recreates data considering new trials
cfg.trl = eegTrl
cfg.channel = 'all';
cfg = ft_definetrial(cfg)
eegData = ft_preprocessing(cfg)

