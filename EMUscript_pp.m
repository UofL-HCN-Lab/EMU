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

%cut natus data to trial based on trigger channel output voltage
tstart = find(ceil(record(145,:))==-707).'; 
idx = find(diff(tstart)~=1);
tend = find(codes ==18); % ML code trial end

for i = 2:size(idx)-1
    % loop through and put trial data into cells
tdata{1} = record(:,tstart(1):idx(i-1));
tdata{i} = record(:,idx(i):idx(i+1));

end
%grab the last one
tdata{size(idx,1)} = record(:,idx(i):idx(end));
tdata = reshape(tdata,[32 1]); 

%dictionary
