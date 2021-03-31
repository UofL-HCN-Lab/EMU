% fieldtrip tutorial for trigger-based trial selection
% https://www.fieldtriptoolbox.org/tutorial/preprocessing/


%% boilerplate
clear
clc

% add path to fieldtrip installation
addpath('~/Documents/GitHub/fieldtrip');
ft_defaults


%% Do the trial definition for the all conditions together:
cfg                         = [];
cfg.dataset                 = '~/Documents/GitHub/TutorialData_fieldtrip/Subject01/Subject01.ds';
cfg.trialfun                = 'ft_trialfun_general'; % this is the default
cfg.trialdef.eventtype      = 'backpanel trigger';
cfg.trialdef.eventvalue     = [3 5 9]; % the values of the stimulus trigger for the three conditions
% 3 = fully incongruent (FIC), 5 = initially congruent (IC), 9 = fully congruent (FC)
cfg.trialdef.prestim        = 1; % in seconds
cfg.trialdef.poststim       = 2; % in seconds

cfg = ft_definetrial(cfg);


%% The output of ft_definetrial can be used for ft_preprocessing
cfg.channel    = {'MEG' 'EOG'};
cfg.continuous = 'yes';
data_all = ft_preprocessing(cfg);

% Save the data to disk
save ~/Documents/GitHub/TutorialData_fieldtrip/PreprocData data_all


%% Visualize the data
plot(data_all.time{1}, data_all.trial{1}(130,:))


%% Split up the conditions by selecting trials according to their trigger value (in data_all.trialinfo).
cfg=[];
cfg.trials = data_all.trialinfo==3;
dataFIC = ft_selectdata(cfg, data_all);

cfg.trials = data_all.trialinfo==5;
dataIC = ft_selectdata(cfg, data_all);

cfg.trials = data_all.trialinfo==9;
dataFC = ft_selectdata(cfg, data_all);

% Save the preprocessed data to disk
save ~/Documents/GitHub/TutorialData_fieldtrip/PreprocData dataFIC dataIC dataFC -append

