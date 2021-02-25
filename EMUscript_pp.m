% natus debug
cd('/Users/jessica/OneDrive - University of Louisville/library/codeLibrary/github/EMU');

[hdr, record] = edfread('/Users/jessica/OneDrive - University of Louisville/library/codeLibrary/natus/test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf');

[data,MLConfig,TrialRecord,filename,varlist] = mlread('/Users/jessica/OneDrive - University of Louisville/library/codeLibrary/natus/20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');

codes = [];
times = [];

for t = 1:length(data)
    codes = [codes; data(t).BehavioralCodes.CodeNumbers];
    times = [times; data(t).BehavioralCodes.CodeTimes];
end

codes = codes';
times = times';
trigchan = record(145,:).';
figure; plot(trigchan);
%cut natus data to trial based on trigger channel output voltage
tstart_natus = find(ceil(record(145,:))==-707).'; 
idx_natus = find(diff(tstart_natus)~=1);

i = [];
for i = 2:size(idx_natus)-1
%     % loop through and put trial data into cells
 tdata_natus{1} = record(:,tstart_natus(1):idx_natus(i-1));
tdata_natus{i} = record(:,idx_natus(i):idx_natus(i+1));

end
%grab the last one
tdata_natus{size(idx_natus,1)} = record(:,idx_natus(i):idx_natus(end));
tdata_natus = reshape(tdata_natus,[32 1]); 

%sort ML codes into subsequent trials to match natus data
tstart_ml = find(codes ==9);
tend_ml = find(codes ==18); % ML code trial end
ntrials = size(tstart_ml,2);

% @ % bug check: natus and monkey logic trials should match (-2)
tdata_ml = []
for ii = 1:ntrials
    tdata_ml{ii,1} = codes(tstart_ml(1,ii):tend_ml(1,ii));
end

tdata = {tdata_natus, tdata_ml};
%% dictionary based on monkeyLogic codes

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

for j = 1:size(tdata{1,2},1)
% index the start of the trial  - - - - - - - - - - - - - - - - - - - - - 
    vec = tdata{1,2}{j,1}(1,:);
    idxStart = find(vec ==1);
    
% instructions code - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    if vec(1,idxStart+1) == 8
        baseline_trialdata = tdata{1,2}{jj,1};
        
% start trial and cue on indicataed a trial  - - - - - - - - - - - - - - - 
    elseif vec(1,idxStart+1) == 2 && vec(1,idxStart+2) == 4
        trialdata{j,1}(:) = tdata{1,2}{j,1};
        
% cue for left button press  - - - - - - - - - - - - - - - - - - - - - - - 
        if trialdata{j,1}(idxStart+3) == 6
            trialdata{j,2}(:) = tdata{1,2}{j,1};
    % congruent ==> left cue left press
            if trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) ==10
                ltd{j,1}(:) = tdata{1,2}{j,1};% Cong_Left_Left          = 10;
    % congruent ==> left right                 
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) ==11
                    ltd{j,2}(:) = tdata{1,2}{j,1};% Cong_Left_Right         = 11;
    % congruent ==> no response                    
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) ==12
                        ltd{j,3}(:) = tdata{1,2}{j,1};% Cong_Left_NoResp        = 12;
    % incongruent ==>                        
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) ==19
                            ltd{j,4}(:) = tdata{1,2}{j,1};% Incong_Left_Left        = 19;
    % incongruent ==>                               
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) ==20
                                ltd{j,5}(:) = tdata{1,2}{j,1};% Incong_Left_Right       = 20;
    % incongruent ==> no response                                  
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) ==21
                                    ltd{j,6}(:) = tdata{1,2}{j,1};% Incong_Left_NoResp      = 21;
            end % left hand trial classification
% cue for right button press  - - - - - - - - - - - - - - - - - - - - - 
        elseif trialdata{j,1}(idxStart+3) == 7
            trialdata{j,3}(:) = tdata{1,2}{j,1};

    % congruent ==> left cue right press
            if trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) == 13
                rtd{j,1}(:) = tdata{1,2}{j,1};% Cong_Right_Left         = 13;
    % congruent ==> left right                 
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) == 14
                    rtd{j,2}(:) = tdata{1,2}{j,1};% Cong_Right_Right        = 14;
    % congruent ==> no response                    
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) == 15
                        rtd{j,3}(:) = tdata{1,2}{j,1};% Cong_Right_NoResp       = 15;   
    % incongruent ==>                        
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) == 22
                            rtd{j,4}(:) = tdata{1,2}{j,1};% Incong_Right_Right      = 23;
    % incongruent ==>                               
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) == 23
                                rtd{j,5}(:) = tdata{1,2}{j,1};% Incong_Right_NoResp     = 24; 
    % incongruent ==> no response                                  
            elseif trialdata{j,1}(idxStart+3) == 6 && trialdata{j,1}(idxStart+4) == 24
                                    rtd{j,6}(:) = tdata{1,2}{j,1};% Incong_Left_NoResp      = 21;  
            end % right hand trial classification

        end % left / right button cue
    end % trial codes vector
end % trials

