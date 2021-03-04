% EMUscript_pp_NCH

clear
clc

%% Load datasets
%load Natus data
[hdr, record] = edfread('test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf');

%load backend MonkeyLogic data
[data,MLConfig,TrialRecord,filename,varlist] = mlread('20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');


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


%% extract codes and times from monkeylogic behavioral data
%create variables for trigger codes and trigger times
codes = [];
times = [];
for t = 1:length(data)
    codes = [codes; data(t).BehavioralCodes.CodeNumbers];
    times = [times; data(t).BehavioralCodes.CodeTimes];
end
codes = codes';
times = times';

%trigger channel is row 145 of the natus data
trigchan = record(145,:)';

%identify unique values in trigchan
unique_values = unique(trigchan);

%find trigchan timepoints with signal change (signal of current time point is different from signal of previous time point)
idx_temp = find(diff(trigchan)~=0); 
idx = idx_temp + 1;
values = trigchan(idx);

%create a "mock" trigger channel with zeros everywhere except the start of each trial
trigchan_mock = zeros(length(trigchan),1);
trigchan_mock([489485 498598 502113 505661 508835 510001 513307 517573 522999 523544 525866 529658 532863 540238 544228 547472 551261 555492 560137 561446 563684 568325 571737 575391 580815 586143 590919 596584 600819 605460 610887 615559])=-750;

%plot trigchan and trigchan_mock as overlay
plot(trigchan);
hold on
plot(trigchan_mock);


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
