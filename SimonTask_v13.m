% SimonTask_v13.m

%% Simon Task  |  PMK, SS, GO, AG, NVW - 05/01/18
% This will execute a basic Simon task, with fixation point, Right and Left "GO" cues, with two patient buttons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change History
% SimonTast_v13 Change History:

% Added instructions/reminder slide to to conditions file and set up timing
% script to incorporate instructions

% Added ability to counter-balance hands

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimonTast_v12 Change History:

% Replaced red screen time-out for early press with visual text display
% "TOO EARLY"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimonTast_v11 Change History:

% Removed unused behavioral codes that ML never uses in timing script and
% included codes that identify trial type and trial outcome

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimonTask_v8 Change History:

% Added trialerror codes and determinations for each trial outcome
% Augmented correct & incorrect trial codes to reflect trial type
% (congruent vs. non-congruent)
% Added lines to record trial congruence in TrialRecord once congruence is
% given behavioral code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The txt file (conditions) has been modified to include 4 blocks for the experiment;
% In this way it automatically shows up in the main window when the conditions file is loaded.

% Voltage changed from 4.8 to 2 V to test buttons!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimonTask_v7 Change History:

% Pre recording period has been removed

% Post recording period has been removed

% Updated max cue duration to 1250 (in accordance with Nelleke's document)

% Fixation point never goes off so that the participant doesn't lose focus
% on the screen

% The problem might actually be identifying any kind of button presses that
% happen before the cue comes up!!
% As of now I have fixed this by having one eyejoytrack before the cue
% comes up. So if there is a button press before cue comes up, then that
% gets recorded and then the system idles at fixation point before moving
% on to the cue. There are 2 issues that needs to be addressed:
%                   1) This setup will only listen to one button press
%                   before cue comes and then idles. So multiple button
%                   presses cannot be recorded. But is there a need to
%                   record multiple presses? The data is anyways not going
%                   to be used even if there is one early press!
%                   2) The possibility of leakage of the early press onto
%                   the ontarget during cue presentation. This might cause
%                   the cue presentation to terminate prematurely. This
%                   scenario did not happen when I tested but it is more
%                   probable if the early press very close to the
%                   cue-presentation. Again if we are not going to use the
%                   data where they press the button early, then this
%                   shouldn't be a problem but the participants might need
%                   to be informed in advance so that they don't get
%                   confused.
%
% Also, during my testing of this code, I was able to record 2 distinct
% button presses (eg.: Early_left_on and Right_Button_On). Hence the 2nd
% issue mentioned above might not be a problem.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimonTask_v6 Change History:

% The late response error contingency has been removed due to the leakage of
% button press voltage during the post recording time.

% Pre recording and Post Recording duration = 1500ms

% Additional temporary behavioral codes are added in order to maintain
% continuity of numbers as it in important for I/O.
% Codes 9 and 18 are reserved (they are used to mark the beginning and end of
% each trial), and so should not be over-written or coded into the task.
% Codes in this file must be listed consecutively, starting from number one,
% without breaks, but not all need to be used in an experiment.

%% To-do list


%% Setup Parameters

% Behavioral Events (eventmarker)
Start_Trial             = 1;
Fix_On                  = 2;
Fix_Off                 = 3;
Cue_On                  = 4;
Cue_Off                 = 5;
Left_Button_On          = 6;
Right_Button_On         = 7;

Instructions            = 8;

% ML trial start        = 9;

Cong_Left_Left          = 10;
Cong_Left_Right         = 11;
Cong_Left_NoResp        = 12;
Cong_Right_Left         = 13;
Cong_Right_Right        = 14;
Cong_Right_NoResp       = 15;

Abort_Early_Left       = 16;
Abort_Early_Right      = 17;

% ML trial end          = 18;

Incong_Left_Left        = 19;
Incong_Left_Right       = 20;
Incong_Left_NoResp      = 21;
Incong_Right_Left       = 22;
Incong_Right_Right      = 23;
Incong_Right_NoResp     = 24;

End_Trial               = 25;

% Error Codes (trialerror)
correct_con_response_code       = 0;
correct_incon_response_code     = 0.2;
no_response_code                = 1;
late_response_code              = 2;
break_fix_code                  = 3;
no_fix                          = 4;
early_response_code             = 5;
incorrect_con_response_code     = 6;
incorrect_incon_response_code   = 6.2;
lever_break                     = 7;
ignored                         = 8;
aborted                         = 9;

% Task Object Names from Condition Files
Fixation_Point  = 1;
Cue             = 2;
Too_Early       = 3;

% Task Object Names for instructions
Green_Left      = 1;
Blue_Left       = 2;
foo             = 3;

% Define Buttons
subj = MLConfig.SubjectName;
undrscridx = strfind(subj,'_');
if ~isempty(undrscridx)
    subjNum = str2double(subj(1:(undrscridx(1)-1)));
else
    subjNum = str2double(subj);
end
if mod(subjNum,2) % if is odd, use default GREEN = LEFT = port 1
    button_left     = 1;
    button_right    = 2;
    
    instructions = Green_Left;
else % if is odd, use default GREEN = RIGHT = port 2
    button_left     = 2;
    button_right    = 1;
    
    instructions    = Blue_Left;
end

% Define Time Intervals (in ms):
fixation_point_duration = randi([0,500],1)+rand;
% time to cue on is 0 - 750.
max_cue_duration        = 1250;
timeout_duration = 500;
max_instruct_duration = 100000000;

% Conditions File:
% Condition	Info	Frequency	Block	Timing File	TaskObject#1	TaskObject#2
% 1	'Stim1', 'Fix', 'Stim2', 'Blue_L' 	1 	1 	SimonTask_v10	Fix(0.000,0.000)	Crc(0.600,[0.000 138.000 255.000 ],1.000,-1.340,0.000)	
% 26	'Stim1', 'Fix', 'Stim2', 'Blue_R' 	1 	1 	SimonTask_v10	Fix(0.000,0.000)	Crc(0.600,[0.000 138.000 255.000 ],1.000,1.340,0.000)	
% 51	'Stim1', 'Fix', 'Stim2', 'Green_L' 	1 	1 	SimonTask_v10	Fix(0.000,0.000)	Crc(0.600,[0.000 155.000 116.000 ],1.000,-1.340,0.000)	
% 76	'Stim1', 'Fix', 'Stim2', 'Green_R' 	1 	1 	SimonTask_v10	Fix(0.000,0.000)	Crc(0.600,[0.000 155.000 116.000 ],1.000,1.340,0.000)	
% ...
% conditions file continues for 100 conditions, equally represented by
% these 4
%
% In the conditions file above,
%   1. The frequency of occurence is equal for all conditions.
%   2. Fixation point is at position (0,0);
%   3. Objects are 4 circles:
%       3.1. Radius = 0.6 degrees (The circle diameter should be 2.1 cm (visual angle = 1.20°);hence angle of radius is 0.6)
%       3.2. RGB (Blue or Green)
%       3.3. 1 = Filled circle
%       3.4. X and Y coordinates. (circle appears 0.6 cm (0.34° visual angle) to the left or to the right of the fixation point)
%               So total angle of displacement from the centre = 0.2 deg (Radius of the fixation point - Need to confirm this though)
%                                                                + 0.34 deg
%                                                                + 0.6 deg
%                                                                (radius)
%% Task
condition = TrialRecord.CurrentCondition;
if mod(subjNum,2) % if is odd, use default GREEN = LEFT
    cong_left = 8:10;
    cong_right = 5:7;
    
    incong_left = 11:13;
    incong_right = 2:4;
else % if is even, use GREEN = RIGHT
    incong_right = 8:10;
    incong_left = 5:7;
    
    cong_right = 11:13;
    cong_left = 2:4;
end
cong_conds = [cong_left cong_right];
incong_conds = [incong_left incong_right];

if ismember(condition,cong_conds)
    trial_congruent = 1;  
else
    trial_congruent = 0;
end

eventmarker(Start_Trial);

if TrialRecord.CurrentBlock == 1
    toggleobject(instructions, 'status', 'on', 'eventmarker', Instructions);
    % Start displaying instructions
    
    [ontarget,~] = eyejoytrack('acquiretouch', button_left, 1.4, 'acquiretouch', button_right, 1.4,max_instruct_duration);
    % starts 'listening' to button presses during the fixation point
    
    if any(ontarget)
        if ontarget(1)==1
            eventmarker(Left_Button_On);
        else
            eventmarker(Right_Button_On);
        end
        toggleobject(instructions, 'status', 'off');
        trialerror(ignored);
    end
else
    if TrialRecord.CurrentTrialNumber == 2
        pause(2)
    end
    toggleobject(Fixation_Point, 'status', 'on', 'eventmarker', Fix_On);
    % Start displaying the fixation point; The position of the fixation
    % point can be controlled from the conditions file and the features can
    % be controlled from the Monkeylogic window.
    
    
    [ontarget,~] = eyejoytrack('acquiretouch', button_left, 1.4, 'acquiretouch', button_right, 1.4,fixation_point_duration);
    % starts 'listening' to button presses during the fixation point
    % duration.
    if any(ontarget)
        if ontarget(1)==1
            em = Abort_Early_Left;
        elseif ontarget(2)==1
            em = Abort_Early_Right;
        end
        toggleobject(Too_Early, 'status', 'on', 'eventmarker', em);
        idle(timeout_duration);
        trialerror(early_response_code);
        toggleobject(Too_Early, 'status', 'off');
        return
        % The above if statement terminates the trial if there are any button
        % presses during the fixation point duration.
    end
    
    toggleobject(Cue, 'status', 'on', 'eventmarker', Cue_On); tic
    % Start displaying the cue.
    [ontarget,rt] = eyejoytrack('acquiretouch', button_left, 1.4, 'acquiretouch', button_right, 1.4, max_cue_duration);
    % starts 'listening' to button presses during the cue display.
    
    if all(ontarget==0) % this is a no-response condition
        if ismember(condition,cong_left)
            eventmarker(Cong_Left_NoResp);
        elseif ismember(condition,cong_right)
            eventmarker(Cong_Right_NoResp);
        elseif ismember(condition,incong_left)
            eventmarker(Incong_Left_NoResp);
        else
            eventmarker(Incong_Right_NoResp);
        end
        toggleobject(Cue, 'status', 'off', 'eventmarker', Cue_Off);
        trialerror(no_response_code);
    elseif any(ontarget) % this is a yes-response condition
        if ontarget(1)==1
            eventmarker(Left_Button_On);
            if ismember(condition,cong_left) % correct
                eventmarker(Cong_Left_Left);
                trialerror(correct_con_response_code);
            elseif ismember(condition,cong_right)
                eventmarker(Cong_Right_Left);
                trialerror(incorrect_con_response_code);
            elseif ismember(condition,incong_left) % correct
                eventmarker(Incong_Left_Left);
                trialerror(correct_incon_response_code);
            else
                eventmarker(Incong_Right_Left);
                trialerror(incorrect_incon_response_code);
            end
        elseif ontarget(2)==1
            eventmarker(Right_Button_On);
            if ismember(condition,cong_left) % incorrect
                eventmarker(Cong_Left_Right);
                trialerror(incorrect_con_response_code);
            elseif ismember(condition,cong_right)
                eventmarker(Cong_Right_Right);
                trialerror(correct_con_response_code);
            elseif ismember(condition,incong_left) % incorrect
                eventmarker(Incong_Left_Right);
                trialerror(incorrect_incon_response_code);
            else
                eventmarker(Incong_Right_Right);
                trialerror(correct_incon_response_code);
            end
        end
        toggleobject(Cue, 'status', 'off', 'eventmarker', Cue_Off);
    end
end
eventmarker(End_Trial);



