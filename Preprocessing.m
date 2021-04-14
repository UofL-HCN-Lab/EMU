clear
clc

%% Loads in edf file
% cfg.dataset = ('test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf')
% eegData = ft_preprocessing(cfg);
%% set path add dependencies
cd 'C:\Users\jm68130\OneDrive - University of Louisville\library\codeLibrary\github\'
addpath(genpath('C:\Users\jm68130\OneDrive - University of Louisville\library\codeLibrary\github\EMU\'))

%monkey logic
[MLdata,MLConfig,TrialRecord,filename,varlist] = mlread('C:\Users\jm68130\Box\Dept-Neurosurgery_NRGlab\Data\emu\testTmp\20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');

%define ML trials for a bug check - - - - - - - - - - - - - - - - - - - - -
    %sort ML codes into subsequent trials to match natus data
codes = [];times = [];

for t = 1:length(MLdata)
    codes = [codes; MLdata(t).BehavioralCodes.CodeNumbers];
    times = [times; MLdata(t).BehavioralCodes.CodeTimes];
end
codes = codes';times = times';

tstart_ml = find(codes ==9);
tend_ml = find(codes ==18); % ML code trial end
ntrials = size(tstart_ml,2);

% field trip - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
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
%plot([1:length(eegTrigger)],eegTrigger(:))
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
eegDifferences = find(eegDifferences > 100);
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

for n = 1:ntrials
    eegData.MLcodes{n}(:,1) = MLdata(n).BehavioralCodes.CodeNumbers;
    %MLcodes{n}(:,1) = MLdata(n).BehavioralCodes.CodeNumbers;
    %eegData.MLcodes = MLcodes';
end

%% dictionary based on monkeyLogic codes
%{
% % Behavioral Events (eventmarker)
% Start_Trial             = 1;
% Fix_On                  = 2;
% Fix_Off                 = 3;
% Cue_On                  = 4;
% Cue_Off                 = 5;
% Left_Button_On          = 6;
% Right_Button_On         = 7;
% 
% Instructions            = 8;
% 
% % ML trial start        = 9;
% 
% Cong_Left_Left          = 10;
% Cong_Left_Right         = 11;
% Cong_Left_NoResp        = 12;
% Cong_Right_Left         = 13;
% Cong_Right_Right        = 14;
% Cong_Right_NoResp       = 15;
% 
% Abort_Early_Left       = 16;
% Abort_Early_Right      = 17;
% 
% % ML trial end          = 18;
% 
% Incong_Left_Left        = 19;
% Incong_Left_Right       = 20;
% Incong_Left_NoResp      = 21;
% Incong_Right_Left       = 22;
% Incong_Right_Right      = 23;
% Incong_Right_NoResp     = 24;
% 
% End_Trial               = 25;
% 
% % Error Codes (trialerror)
% correct_con_response_code       = 0;
% correct_incon_response_code     = 0.2;
% no_response_code                = 1;
% late_response_code              = 2;
% break_fix_code                  = 3;
% no_fix                          = 4;
% early_response_code             = 5;
% incorrect_con_response_code     = 6;
% incorrect_incon_response_code   = 6.2;
% lever_break                     = 7;
% ignored                         = 8;
% aborted                         = 9;
% 
% % Task Object Names from Condition Files
% Fixation_Point  = 1;
% Cue             = 2;
% Too_Early       = 3;
% 
% % Task Object Names for instructions
% Green_Left      = 1;
% Blue_Left       = 2;
% foo             = 3;
%}
%-------------------------------------------------------------------------
% seperate instruction (baseline data) and trials data (net, left, right)
% based on conditions of ML codes

for i = 1:ntrials
    
    % find location of trial start index
    idx = find(eegData.MLcodes{1,i}==1);
    
% instructions code - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    if eegData.MLcodes{1,i}(idx+1) == 8
        eegData.instruction.MLcodes = eegData.MLcodes{1,i};
        eegData.instruction.trial = eegData.trial{1,i};
        eegData.instruction.time = eegData.time{1,i};
        
% start trial and cue on indicataed a trial  - - - - - - - - - - - - - - -
    elseif eegData.MLcodes{1,i}(idx+1) == 2 && eegData.MLcodes{1,i}(idx+2) == 4
        eegData.trialdata.MLcodes{i,1} = eegData.MLcodes{1,i};
        eegData.trialdata.trial{i,1} = eegData.trial{1,i};
        eegData.trialdata.time{i,1} = eegData.time{1,i};
    end
    
% cue for left button press  - - - - - - - - - - - - - - - - - - - - - - -
    if eegData.MLcodes{1,i}(idx+3) == 6
        %         eegData.trialdata.leftPress.codes{i,1} = eegData.MLcodes{1,i};
        %         eegData.trialdata.leftPress.trl{i,1} = eegData.trial{1,i};
        %         eegData.trialdata.leftPress.tme{i,1} = eegData.time{1,i};
        eegData.trialdata.MLcodes{i,2} = eegData.MLcodes{1,i};
        eegData.trialdata.trial{i,2} = eegData.trial{1,i};
        eegData.trialdata.time{i,2} = eegData.time{1,i};
        
% cue for right button press  - - - - - - - - - - - - - - - - - - - - -
    elseif eegData.MLcodes{1,i}(idx+3) == 7
        %         eegData.trialdata.rightPress.codes{i,1} = eegData.MLcodes{1,i};
        %         eegData.trialdata.rightPress.trl{i,1} = eegData.trial{1,i};
        %         eegData.trialdata.rightPress.tme{i,1} = eegData.time{1,i};
        eegData.trialdata.MLcodes{i,3} = eegData.MLcodes{1,i};
        eegData.trialdata.trial{i,3} = eegData.trial{1,i};
        eegData.trialdata.time{i,3} = eegData.time{1,i};
    end
end

% seperate congruent and incongruent trial data (left, right, norespone)
% based on conditions of ML codes    
idx = []; i = [];
for i = 1:ntrials
    
    % find location of trial start index
    idx = find(eegData.MLcodes{1,i}==1);
% left - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % congruent ==>  | [Cong_Left_Left = 10]
    if eegData.MLcodes{1,i}(idx+3) == 6 && eegData.MLcodes{1,i}(idx+4) ==10
        eegData.trialdata.cong.cds{i,1} = eegData.MLcodes{1,i};
        eegData.trialdata.cong.trl{i,1} = eegData.trial{1,i};
        eegData.trialdata.cong.tme{i,1} = eegData.time{1,i};
        
        % congruent ==>  | [Cong_Left_Right  = 11]
    elseif eegData.MLcodes{1,i}(idx+3) == 6 && eegData.MLcodes{1,i}(idx+4) ==11
        eegData.trialdata.cong.cds{i,2} = eegData.MLcodes{1,i};
        eegData.trialdata.cong.trl{i,2} = eegData.trial{1,i};
        eegData.trialdata.cong.tme{i,2} = eegData.time{1,i};
        
        % congruent ==>  no response | [Cong_Left_noResp  = 12]
    elseif eegData.MLcodes{1,i}(idx+3) == 6 && eegData.MLcodes{1,i}(idx+4) ==12
        eegData.trialdata.cong.cds{i,3} = eegData.MLcodes{1,i};
        eegData.trialdata.cong.trl{i,3} = eegData.trial{1,i};
        eegData.trialdata.cong.tme{i,3} = eegData.time{1,i};
% right - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -        
        % congruent ==> left cue right press  | [Cong_Right_Left = 13]
    elseif eegData.MLcodes{1,i}(idx+3) == 7 && eegData.MLcodes{1,i}(idx+4) == 13
        eegData.trialdata.cong.cds{i,4}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.cong.trl{i,4} = eegData.trial{1,i};
        eegData.trialdata.cong.tme{i,4} = eegData.time{1,i};
        
        % congruent ==> left right  | [Cong_Right_Right = 14]
    elseif eegData.MLcodes{1,i}(idx+3) == 7 && eegData.MLcodes{1,i}(idx+4) == 14
        eegData.trialdata.cong.cds{i,5}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.cong.trl{i,5} = eegData.trial{1,i};
        eegData.trialdata.cong.tme{i,5} = eegData.time{1,i};
        
        % congruent ==> no response  | [Cong_Right_NoResp = 15]
    elseif eegData.MLcodes{1,i}(idx+3) == 7 && eegData.MLcodes{1,i}(idx+4) == 15
        eegData.trialdata.cong.cds{i,6}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.cong.trl{i,6} = eegData.trial{1,i};
        eegData.trialdata.cong.tme{i,6} = eegData.time{1,i};
% incongruent - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -        
        % incongruent ==> | [Incong_Left_Left = 19]
    elseif eegData.MLcodes{1,i}(idx+3) == 6 && eegData.MLcodes{1,i}(idx+4) ==19
        eegData.trialdata.incong.cds{i,1}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.incong.trl{i,1} = eegData.trial{1,i};
        eegData.trialdata.incong.tme{i,1} = eegData.time{1,i};
        
        % incongruent ==>  | [Incong_Left_Right = 20]
    elseif eegData.MLcodes{1,i}(idx+3) == 6 && eegData.MLcodes{1,i}(idx+4) ==20
        eegData.trialdata.incong.cds{i,2}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.incong.trl{i,2} = eegData.trial{1,i};
        eegData.trialdata.incong.tme{i,2} = eegData.time{1,i};
        
        % incongruent ==> no response  | [Incong_Left_NoResp = 21]
    elseif eegData.MLcodes{1,i}(idx+3) == 6 && eegData.MLcodes{1,i}(idx+4) ==21
        eegData.trialdata.incong.cds{i,3}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.incong.trl{i,3} = eegData.trial{1,i};
        eegData.trialdata.incong.tme{i,3} = eegData.time{1,i};

        
        % incongruent ==>  | [Incong_Right_Right = 23]
    elseif eegData.MLcodes{1,i}(idx+3) == 7 && eegData.MLcodes{1,i}(idx+4) == 23
        %rtd{j,4}(:) = tdata{1,2}{j,1};
        eegData.trialdata.incong.cds{i,4}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.incong.trl{i,4} = eegData.trial{1,i};
        eegData.trialdata.incong.tme{i,4} = eegData.time{1,i};
        
        % incongruent ==>  | [Incong_Right_NoResp = 24]
    elseif eegData.MLcodes{1,i}(idx+3) == 7 && eegData.MLcodes{1,i}(idx+4) == 24
        eegData.trialdata.incong.cds{i,5}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.incong.trl{i,5} = eegData.trial{1,i};
        eegData.trialdata.incong.tme{i,5} = eegData.time{1,i};
        
        % incongruent ==> no response  | [Incong_Right_NoResp = 24]
    elseif eegData.MLcodes{1,i}(idx+3) == 7 && eegData.MLcodes{1,i}(idx+4) == 24
        eegData.trialdata.incong.cds{i,6}(:) = eegData.MLcodes{1,i};
        eegData.trialdata.incong.trl{i,6} = eegData.trial{1,i};
        eegData.trialdata.incong.tme{i,6} = eegData.time{1,i};
    else
        continue
    end % congruent / incongruent condition
    
end % end trial loop