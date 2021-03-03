% natus debug
% cd('/Users/jessica/OneDrive - University of Louisville/library/codeLibrary/github/EMU');

clear
clc

%load Natus data
[hdr, record] = edfread('test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf');

%load backend MonkeyLogic data
[data,MLConfig,TrialRecord,filename,varlist] = mlread('20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');


%% extract codes and times from monkeylogic behavioral data (282 events);
% only 9s send trigger
% list of codes:

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
trigchan = record(145,:).';

%find timepoints with signal change (signal of current time point is different from signal of previous time point
[idx,~,value] = find(diff(trigchan)~=0);


