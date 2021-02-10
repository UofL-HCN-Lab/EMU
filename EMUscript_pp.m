% natus debug
cd('C:\Users\jm68130\OneDrive - University of Louisville\library\codeLibrary\natus');
[hdr, record] = edfread('test_ monkeylo_2c734bac-e3b4-4c96-8c1f-a4fb94ca2357.edf');

 [data,MLConfig,TrialRecord,filename,varlist] = mlread('20201211_1121_0000000_test2_SimonTask_v13_ML.bhv2');

codes = [];
times = [];

for t = 1:length(data)
    codes = [codes; data(t).BehavioralCodes.CodeNumbers];
    times = [times; data(t).BehavioralCodes.CodeTimes];
end

codes = codes';
times = times';

%cut natus data to trial
for a = size(record,2)
    
    if record(145,a) < -706 &&  record(145,a) > -708
        I(1,a) = record(145,a);
    end
end