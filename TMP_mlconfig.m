classdef (ConstructOnLoad = true) mlconfig
    properties  % variables related to UI
        SubjectScreenDevice
        DiagonalSize
        ViewingDistance
        FallbackScreenRect
        ForcedUseOfFallbackScreen
        VsyncSpinlock
        SubjectScreenBackground
        FixationPointImage
        FixationPointShape
        FixationPointColor
        FixationPointDeg
        EyeNumber
        EyeTracerShape
        EyeTracerColor
        EyeTracerSize
        JoystickNumber
        JoystickCursorImage
        JoystickCursorShape
        JoystickCursorColor
        JoystickCursorSize
        TouchCursorImage
        TouchCursorShape
        TouchCursorColor
        TouchCursorSize
        PhotoDiodeTrigger
        PhotoDiodeTriggerSize
        RasterThreshold
        ErrorLogic
        CondLogic
        CondSelectFunction
        BlockLogic
        BlockSelectFunction
        BlockChangeFunction
        RemoteAlert
        InterTrialInterval
        SummarySceneDuringITI
        NonStopRecording
        UserPlotFunction
        IO
        MouseKey
        Touchscreen
        USBJoystick
        Webcam
        EyeTracker
        SerialPort
        AIConfiguration
        AISampleRate
        AIOnlineSmoothing
        AIOnlineSmoothingWindow
        StrobeTrigger
        StrobePulseSpec
        RewardFuncArgs
        RewardPolarity
        EyeCalibration
        EyeTransform
        EyeAutoDriftCorrection
        JoystickCalibration
        JoystickTransform
        NumberOfTrialsToRunInThisBlock
        CountOnlyCorrectTrials
        BlocksToRun
        FirstBlockToRun
        TotalNumberOfTrialsToRun
        TotalNumberOfBlocksToRun
        ExperimentName
        Investigator
        SubjectName
        FilenameFormat
        Filetype
        SaveStimuli
        MinifyRuntime
        ControlScreenZoom
    end
    properties (Dependent = true)  % related to UI, but not edittable
        Resolution
        PixelsPerDegree
        FormattedName
    end
    properties (Transient = true)  % variables that are not saved in the config file
        MLVersion
        MLPath
        MLConditions
        DAQ
        Screen
        System
        IOList
    end
    properties (Constant = true, Hidden = true)
        Ver = 1.0;
        DependentFields = {'Resolution','PixelsPerDegree','FormattedName'}
        TransientFields = {'MLVersion','MLPath','MLConditions','DAQ','Screen','System','IOList'}
        DefaultNumberOfTrialsToRunInThisBlock = 1000;
        DefaultCountOnlyCorrectTrials = false;
    end

    methods (Static)
        function obj = loadobj(obj)
            if ~isfield(obj.RewardFuncArgs,'JuiceLine'), obj.RewardFuncArgs.JuiceLine = 1; end
            if ~isstruct(obj.Touchscreen), a = struct('On',false,'NumTouch',1); a.On = obj.Touchscreen; obj.Touchscreen = a; end
            if ~isstruct(obj.USBJoystick), a = repmat(struct('ID',''),1,2); a(1).ID = obj.USBJoystick; obj.USBJoystick = a; end
            if ~isfield(obj.USBJoystick,'NumButton'), for m=1:length(obj.USBJoystick), obj.USBJoystick(m).NumButton = 0; end, end
            if ischar(obj.EyeTracerShape), obj.EyeTracerShape = {obj.EyeTracerShape, obj.EyeTracerShape}; end
            if 1==size(obj.EyeTracerColor,1), obj.EyeTracerColor = [obj.EyeTracerColor; 1 0 1]; end
            if isscalar(obj.EyeTracerSize), obj.EyeTracerSize = [obj.EyeTracerSize obj.EyeTracerSize]; end
            if isscalar(obj.EyeCalibration), obj.EyeCalibration = [obj.EyeCalibration obj.EyeCalibration]; end
            if 1==size(obj.EyeTransform,1), obj.EyeTransform = repmat(obj.EyeTransform,2,1); end
            if ischar(obj.JoystickCursorImage), obj.JoystickCursorImage = {obj.JoystickCursorImage, obj.JoystickCursorImage}; end
            if ischar(obj.JoystickCursorShape), obj.JoystickCursorShape = {obj.JoystickCursorShape, obj.JoystickCursorShape}; end
            if 1==size(obj.JoystickCursorColor,1), obj.JoystickCursorColor = [obj.JoystickCursorColor; 0 0.5 1]; end
            if isscalar(obj.JoystickCursorSize), obj.JoystickCursorSize = [obj.JoystickCursorSize obj.JoystickCursorSize]; end
            if isscalar(obj.JoystickCalibration), obj.JoystickCalibration = [obj.JoystickCalibration obj.JoystickCalibration]; end
            if 1==size(obj.JoystickTransform,1), obj.JoystickTransform = repmat(obj.JoystickTransform,2,1); end
            if ~isfield(obj.EyeTracker,'Ver')
                if isfield(obj.EyeTracker.ViewPoint,'Source')
                    obj.EyeTracker.ViewPoint.Source(5:8,:) = obj.EyeTracker.ViewPoint.Source(3:6,:);
                    obj.EyeTracker.ViewPoint.Source(3:4,:) = obj.EyeTracker.ViewPoint.Source(1:2,:);
                    obj.EyeTracker.ViewPoint.Source(3:4,1) = 1-obj.EyeTracker.ViewPoint.Source(3:4,1);
                    obj.EyeTracker.ViewPoint.Source(3:4,2) = 1;
                end
                if isfield(obj.EyeTracker.EyeLink,'Source')
                    obj.EyeTracker.EyeLink.Source = [repmat(obj.EyeTracker.EyeLink.Source(1:2,:),2,1); obj.EyeTracker.EyeLink.Source(3:6,:)];
                    obj.EyeTracker.EyeLink.Source(3:4,2) = 1;
                end
                obj.EyeTracker.Ver = 1;
            end
        end
    end
    methods
        function field = fieldnames(obj)
            field = mlsetdiff(properties(obj),[obj.DependentFields obj.TransientFields]);
        end
        function obj = mlconfig()
            try
                obj.SubjectScreenDevice = mglgetadaptercount;
            catch
                obj.SubjectScreenDevice = size(get(0,'MonitorPositions'),1);
            end
            obj.DiagonalSize = 50.8;
            obj.ViewingDistance = 57;

            obj.FallbackScreenRect = '[0,0,1024,768]';
            obj.ForcedUseOfFallbackScreen = false;
            obj.VsyncSpinlock = 1;

            obj.SubjectScreenBackground = [0 0 0];

            obj.FixationPointImage = '';
            obj.FixationPointShape = 'Square';
            obj.FixationPointColor = [1 1 1];
            obj.FixationPointDeg = 0.2;

            obj.EyeNumber = 1;
            obj.EyeTracerShape = {'Line','Circle'};
            obj.EyeTracerColor = [1 0 0; 1 0 1];
            obj.EyeTracerSize = [5 5];

            obj.JoystickNumber = 1;
            obj.JoystickCursorImage = {'',''};
            obj.JoystickCursorShape = {'Square','Square'};
            obj.JoystickCursorColor = [0 1 0; 0 0.5 1];
            obj.JoystickCursorSize = [10 10];

            obj.TouchCursorImage = '';
            obj.TouchCursorShape = 'Circle';
            obj.TouchCursorColor = [1 1 0];
            obj.TouchCursorSize = 5;

            obj.PhotoDiodeTrigger = 1;
            obj.PhotoDiodeTriggerSize = 64;
            obj.RasterThreshold = 0.9;

            obj.ErrorLogic = 1;
            obj.CondLogic = 1;
            obj.CondSelectFunction = '';
            obj.BlockLogic = 1;
            obj.BlockSelectFunction = '';
            obj.BlockChangeFunction = '';

            obj.RemoteAlert = false;
            obj.InterTrialInterval = 2000;
            obj.SummarySceneDuringITI = true;
            obj.NonStopRecording = false;
            obj.UserPlotFunction = '';

            obj.IO = [];
            obj.MouseKey = struct('Mouse',false,'KeyCode',[37 38 39 40]);
            obj.Touchscreen = struct('On',false,'NumTouch',1);
            obj.USBJoystick = repmat(struct('ID','','NumButton',0),1,2);
            obj.Webcam = repmat(struct('ID','','Property',[]),1,4);
            obj.EyeTracker = struct('Name','None','ID','','ViewPoint',struct,'EyeLink',struct,'Ver',1);
            obj.EyeTracker.ViewPoint.IP_address = '169.254.110.159';
            obj.EyeTracker.ViewPoint.Port = '5000';
            obj.EyeTracker.ViewPoint.Source = [ 0,2,0.5,20; 0,10,0.5,-20; 1,1,0.5,20; 1,1,0.5,-20; 0,1,0,1; 0,1,0,1; 0,1,0,1; 0,1,0,1 ];
            obj.EyeTracker.EyeLink.IP_address = '100.1.1.1';
            obj.EyeTracker.EyeLink.Filter = 0;     % 0: off, 1: std, 2: extra
            obj.EyeTracker.EyeLink.PupilSize = 2;  % 1: area, 2: diameter
            obj.EyeTracker.EyeLink.Source = [ 2,2,0,-0.0005; 2,5,0,0.0005; 2,1,0,-0.0005; 2,1,0,0.0005; 2,1,0,1; 2,1,0,1; 2,1,0,1; 2,1,0,1 ];
            obj.SerialPort = struct('Port','','BaudRate',38400,'ByteSize',8,'StopBits','OneStopBit','Parity','NoParity');

            obj.AIConfiguration = 'NonReferencedSingleEnded';
            obj.AISampleRate = 1000;
            obj.AIOnlineSmoothing = 1;
            obj.AIOnlineSmoothingWindow = 5;

            obj.StrobeTrigger = 1;
            obj.StrobePulseSpec = struct('T1',125,'T2',125);
            obj.RewardFuncArgs = struct('JuiceLine',1,'Duration',100,'NumReward',1,'PauseTime',40,'TriggerVal',5,'Custom','');
            obj.RewardPolarity = 1;

            obj.EyeCalibration = [1 1];
            obj.EyeTransform = cell(2,3);
            obj.EyeAutoDriftCorrection = 0;

            obj.JoystickCalibration = [1 1];
            obj.JoystickTransform = cell(2,3);

            obj.NumberOfTrialsToRunInThisBlock = obj.DefaultNumberOfTrialsToRunInThisBlock;
            obj.CountOnlyCorrectTrials = obj.DefaultCountOnlyCorrectTrials;
            obj.BlocksToRun = [];
            obj.FirstBlockToRun = [];

            obj.TotalNumberOfTrialsToRun = 99999;
            obj.TotalNumberOfBlocksToRun = 99999;

            obj.ExperimentName = 'Experiment';
            obj.Investigator = 'Investigator';
            obj.SubjectName = '';

            obj.FilenameFormat = 'yymmdd_sname_cname';
            obj.Filetype = '.bhv2';
            obj.SaveStimuli = false;
            obj.MinifyRuntime = true;
            
            obj.ControlScreenZoom = 90;

            obj.MLPath = mlpath;
            obj.MLConditions = mlconditions;
            obj.DAQ = mldaq;
            obj.Screen = mlscreen;
            obj.System = mlsystem;
        end
        function export_to_file(obj,fobj,varname)
            if ~exist('varname','var'), varname = 'MLConfig'; end
            try
                dest = [];
                field = [mlsetdiff(properties(obj),obj.TransientFields); 'MLVersion'; 'MLPath'; 'Ver'];
                for m=1:length(field), dest.(field{m}) = obj.(field{m}); end
                if ~isopen(fobj), open(fobj,fobj.filename,'a'); end
                fobj.write(dest,varname);
            catch err
                close(fobj);
                rethrow(err);
            end
        end
        function delete(obj)
            delete(obj.DAQ);
            delete(obj.Screen);
        end
        
        function tf = isequal(obj,val)
            if ~strcmp(class(obj),class(val)), tf = false; return, end
            field = setdiff(fieldnames(obj),{'EyeNumber','JoystickNumber'});
            tf = true; for m=1:length(field), if ~isequal(obj.(field{m}),val.(field{m})), tf = false; break, end, end
        end
        
        function val = get.Resolution(obj)
            try
                [width,height,refreshrate] = mglgetadapterdisplaymode(obj.SubjectScreenDevice);
                val = sprintf('%d x %d %d Hz',width,height,refreshrate);
            catch
                val = '';
            end
        end
        function val = get.PixelsPerDegree(obj)
            try
                [width,height] = mglgetadapterdisplaymode(obj.SubjectScreenDevice);
                pixels_in_diagonal = sqrt(width^2 + height^2);
                viewing_deg = 2 * atan2(obj.DiagonalSize / 2, obj.ViewingDistance) * 180 / pi;
                val = [1 -1] * pixels_in_diagonal / viewing_deg;
            catch
                val = NaN(1,2);
            end
        end
        function val = get.FormattedName(obj)
            try
                val = obj.FilenameFormat;
                format = {'yyyy','yy','mmm','mm','ddd','dd','HH','MM','SS'};
                for m=1:length(format), val = regexprep(val,format{m},datestr(now,format{m})); end
                val = regexprep(val,'expname|ename',obj.ExperimentName);
                val = regexprep(val,'yourname|yname',obj.Investigator);
                [~,filename] = fileparts(obj.MLPath.ConditionsFile);
                val = regexprep(val,'condname|cname',filename);
                val = regexprep(val,'subjname|sname',obj.SubjectName);
            catch
                val = '';
            end
        end
    end
end
