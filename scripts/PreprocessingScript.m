% EMUscript_pp_NCH

clear
clc

%% MonkeyLogic codes
% % % % Behavioral Events (eventmarker)
% % % Start_Trial             = 1;
% % % Fix_On                  = 2;
% % % Fix_Off                 = 3;
% % % Cue_On                  = 4;
% % % Cue_Off                 = 5;
% % % Left_Button_On          = 6;
% % % Right_Button_On         = 7;
% % %
% % % Instructions            = 8;
% % %
% % % % ML trial start        = 9;
% % %
% % % Cong_Left_Left          = 10;
% % % Cong_Left_Right         = 11;
% % % Cong_Left_NoResp        = 12;
% % % Cong_Right_Left         = 13;
% % % Cong_Right_Right        = 14;
% % % Cong_Right_NoResp       = 15;
% % %
% % % Abort_Early_Left       = 16;
% % % Abort_Early_Right      = 17;
% % %
% % % % ML trial end          = 18;
% % %
% % % Incong_Left_Left        = 19;
% % % Incong_Left_Right       = 20;
% % % Incong_Left_NoResp      = 21;
% % % Incong_Right_Left       = 22;
% % % Incong_Right_Right      = 23;
% % % Incong_Right_NoResp     = 24;
%%%% ML trial start = 9 or 31



%%
cfg.dataset = ('test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf')
eegData = ft_preprocessing(cfg);
%%
eegData = eegData.trial{1};
eegTrigger = eegData(145,:);
uniqueValues = unique(eegTrigger);
eegIdx = find(eegTrigger == uniqueValues(3));
count = 0;
eegStart = [];
eegEnd = [];
for a = 1:length(eegIdx)
    if a==1
        eegStartCurrent = eegIdx(a);
        eegStart = [eegStart;eegStartCurrent];
        continue
    end
    if a==length(eegIdx)
        if length(eegEnd) == length(eegStart) %if it ends with a start
            eegStartCurrent = eegIdx(a);
            eegStart = [eegStart;eegStartCurrent];
            break
        elseif length(eegStart) > length(eegEnd) %if it ends with a end
            eegEndCurrent = eegIdx(a);
            eegEnd = [eegEnd;eegEndCurrent];
            break
        end
    end
    if eegIdx(a)~= eegIdx(a+1)-1
        if count == 1;
            count = 0;
            eegStartCurrent = eegIdx(a);
            eegStart = [eegStart;eegStartCurrent];
        elseif count == 0
            count = 1;
            eegEndCurrent = eegIdx(a);
            eegEnd = [eegEnd;eegEndCurrent];
        end
    end
end

eegZeros = zeros(length(eegEnd),1);       
eegTrl = cat(2,eegStart,eegEnd,eegZeros);
%%
cfg.trl = eegTrl
cfg.channel = 'all';
% cfg.trialfun = 'ft_trialfun_general'; % this is the default
%cfg.trialdef.eventtype = 'Trig'
% cfg.trialdef.eventtype = '?'
% cfg.trialdef.prestim = -.5; % in seconds
% cfg.trialdef.poststim = 1.5; % in seconds
% cfg.trialdef.eventvalue = -7.074753948265843e+02;
cfg = ft_definetrial(cfg)
eegData = ft_preprocessing(cfg)

%% EXTRA STUFF
% 9 = [-78.6083772024140]

% for i = 1:length(unique_values)
%     dun{i} = diff(trigchan(trigchan==unique_values(i),1));
% end

% -707.475394826584 = trial start (9 or 31)
% find(ceil(trigchan)==-707

% -1179.12565804471
% -1021.90890363867
% -864.692149232627
% -78.6083772024140
