
%% code mostly from this tutorial -- http://www.fieldtriptoolbox.org/getting_started/edf/
clear
clc


%%  add paths locally
% restoredefaultpath
% addpath('~/Dropbox/CogMem/Projects/DRM/Ecog/fieldtrip');
% ft_defaults


%%  add paths on crc
restoredefaultpath
addpath('/scratch/global/nilcamp/hindylab/tools/fieldtrip');
ft_defaults


%%  cycle through trigger channel to find trigger events
cfg = [];
cfg.dataset = '/scratch/global/nilcamp/hindylab/ECOG/RAW_DATA/NATUS/Sub1/pilotData/compressedFile.edf';
cfg.continuous = 'yes';
cfg.channel = 'TRIG'; % or select channel name

t=40;
c1=1;
c2 = 1;
thresh = 1;
trigsFound = [];
trigTimeStarts = [];
while (t-1)*5*60*2048+1<= 176745472
    disp(['iteration ' num2str(t) '. time = ' num2str(((t-1)*5*60*2048+1)/2048/60)]);
    if t*5*60*2048>176745472
        t = 176745472;
    end
    cfg.trl = [(t-1)*5*60*2048+1 t*5*60*2048 0];
    data = ft_preprocessing(cfg);
    
    if any(abs(diff(data.trial{1})))
        trigsFound(c2) = 1;
        trigTimeStarts(c1) = (t-1)*5*60*2048+1;
        display(['trigger found at ' num2str(trigTimeStarts(c1))]);
        c1=c1+1;
    else
        trigsFound(t) = 0;
    end
    t =t+ 1;
    c2=c2+1;
end


%%  Select desired time segment (of ALL channels) and save to edf file
cfg = [];
cfg.dataset = '/scratch/global/nilcamp/hindylab/ECOG/RAW_DATA/NATUS/Sub1/pilotData/Meredith~ Mari_a6da79b4-09a9-4aaa-aaae-0dc3dc23d5e9.edf';
cfg.continuous = 'yes';
cfg.channel = 'all'; % or select channel name
% trigTimeStarts = 24576001;
% trigTimeStarts = 26673153; % beginning of day1 practice
trigTimeStarts = 29081601; % beginning of day1 run2



% cfg.trl = [trigTimeStarts(1) trigTimeStarts(end)+50*60*2048 0]; % 50 minutes
% cfg.trl = [trigTimeStarts trigTimeStarts+50*60*2048 0]; % 50 minutes

cfg.trl = [trigTimeStarts(1) trigTimeStarts(end)+7.5*60*2048 0]; % 7.5 minutes
cfg.trl = [trigTimeStarts trigTimeStarts+7.5*60*2048 0]; % 7.5 minutes


data = ft_preprocessing(cfg);
dataToSave = data.trial{1};
savefilename = '/scratch/global/nilcamp/hindylab/ECOG/RAW_DATA/NATUS/Sub1/pilotData/sub1_day1_run2.edf';

cd /scratch/global/nilcamp/hindylab/tools/fieldtrip/fileio/private/
hdr = ft_read_header('/scratch/global/nilcamp/hindylab/ECOG/RAW_DATA/NATUS/Sub1/pilotData/Meredith~ Mari_a6da79b4-09a9-4aaa-aaae-0dc3dc23d5e9.edf','headerformat','edf');
write_edf(savefilename, hdr, dataToSave);


%%  Try reading events using default method
% event = ft_read_event(datafilepath,'detect flank',[],'dataformat','edf','chanindx',145);

