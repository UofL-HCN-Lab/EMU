% clear; clc

%% set path add dependencies
cd 'C:\Users\jm68130\OneDrive - University of Louisville\library\codeLibrary\github\'
addpath(genpath('C:\Users\jm68130\OneDrive - University of Louisville\library\codeLibrary\github\EMU\'))
%monkey logic
[MLdata,MLConfig,TrialRecord,filename,varlist] = mlread('C:\Users\jm68130\Box\Dept-Neurosurgery_NRGlab\Data\emu\testTmp\20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');
%define ML trials for a bug check 

%field trip
addpath('C:\Users\jm68130\OneDrive - University of Louisville\library\codeLibrary\github\fieldtrip');
ft_defaults
%% Loads in edf file
root = 'C:\Users\jm68130\Box\Dept-Neurosurgery_NRGlab\Data\emu';
subj = 'testTmp';
file = 'test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf';
ext = '.edf';
fpath = fullfile(root, subj,file)
cfg.dataset = (fpath)
eegData = ft_preprocessing(cfg);
%% Creates necessary variables for creating trials
eegData = eegData.trial{1};
eegTrigger = eegData(145,:);
uniqueValues = unique(eegTrigger);
eegIdx = find(eegTrigger == uniqueValues(3));
count = 0;
eegStart = [];
eegEnd = [];
%% Finds values of electrode 145 indicating a trial, records them and formats them for the cfg
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
        if count == 1; % if its a starting value
            count = 0;
            eegStartCurrent = eegIdx(a);
            eegStart = [eegStart;eegStartCurrent];
        elseif count == 0 % if its a ending value
            count = 1;
            eegEndCurrent = eegIdx(a);
            eegEnd = [eegEnd;eegEndCurrent];
        end
    end
end
eegZeros = zeros(length(eegEnd),1);       
eegTrl = cat(2,eegStart,eegEnd,eegZeros);
%% Changes trl to new trial matrix and recreates data considering new trials
cfg.trl = eegTrl
cfg.channel = 'all';
cfg = ft_definetrial(cfg)
eegData = ft_preprocessing(cfg)

