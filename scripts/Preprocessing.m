%PreProcessing Script for ML Natus Data
%clear; clc

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
root = 'C:\Users\jm68130\Box\Dept-Neurosurgery_NRGlab';
folder = 'Data\emu'
subject = 'testTmp';
file = 'test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf';
ext = '.edf';
fpath = fullfile(root, folder, subject, file);

cfg = [];
cfg.dataset = (fpath)
eegData = ft_preprocessing(cfg);

%% find trigger

eegTrigger = eegData.trial{1,1}(145,:);
uniqueValues = unique(eegTrigger);
i = [];k = [];
for k = [1 2 3 5];
    for i = 1:size(eegTrigger,2)
        if eegTrigger(:,i) == uniqueValues(k)
            eegTrigger(:,i) = 0;
            
             elseif eegTrigger(:,i) == uniqueValues(4)
                 eegTrigger(:,i) = 1;
        end
    end
end

%% overwrite tigger channel with binary trigger
    % 1 trial ongoing
    % 0 intertrial period
trial = 1;
for n = 1:size(eegTrigger,2)-1
    if eegTrigger(1,n) == 1
        etrial{trial,1}(1,n) = eegTrigger(1,n);
%     elseif eegTrigger(1,n) == 0
%         etrial{trial,1}(1,n) = eegTrigger(1,n);
    elseif eegTrigger(1,n) == 0 && eegTrigger(1,n+1) ==1
        trial = trial +1
    end
end

%%
eegData(145,:) = eegTrigger;
eegData = eegData.trial{1};
% trial definition based on trigger
% cfg.data = eegData;
% cfg.channel = 'all';
% cfg.trialfun = 'ft_trialfun_general'; % this is the default
% cfg.trialdef.eventvalue = '1';
% cfg.trialdef.ntrials = 30;
% cfg.trialdef.eventtype = 'Trig'
% cfg.trialdef.prestim = 0; % in seconds
% cfg.trialdef.poststim = 0; % in seconds
% ieeg = ft_definetrial(cfg);

%% Finds values of electrode 145 indicating a trial, records them and formats them for the cfg
count = 0;
eegStart = [];
eegEnd = [];
eegIdx = eegData(145,:);

for i = 1:length(eegIdx)
    if i==1 %if its the first value (for which there is no reference point)
        eegStartCurrent = eegIdx(i);
        eegStart = [eegStart;eegStartCurrent];
        continue
    end
    if i==length(eegIdx) %if its the last value (for which there is no reference point)
        if length(eegEnd) == length(eegStart) %if the trials end with a start
            eegStartCurrent = eegIdx(i);
            eegStart = [eegStart;eegStartCurrent];
            break
        elseif length(eegStart) > length(eegEnd) %if the trials end with a end
            eegEndCurrent = eegIdx(i);
            eegEnd = [eegEnd;eegEndCurrent];
            break
        end
    end
    if eegIdx(i)~= eegIdx(i+1)-1 %if next value isn't +1 to current value
        if count == 1; % if its a starting value
            count = 0;
            eegStartCurrent = eegIdx(i);
            eegStart = [eegStart;eegStartCurrent];
        elseif count == 0 % if its a ending value
            count = 1;
            eegEndCurrent = eegIdx(i);
            eegEnd = [eegEnd;eegEndCurrent];
        end
    end
end
eegZeros = zeros(length(eegEnd),1);       
eegTrl = cat(2,eegStart,eegEnd,eegZeros);
%% Changes trl to new trial matrix and recreates data considering new trials
eegData = eegData.trial{1};
cfg.trl = eegTrl
cfg.channel = 'all';
cfg = ft_definetrial(cfg)
eegData = ft_preprocessing(cfg)

