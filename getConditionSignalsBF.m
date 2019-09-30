function iOk = getConditionSignalsBF(fid)
iOk = -1;

%% Parsing inputs
p = inputParser;
addRequired(p,'fid',@isnumeric);
parse(p,fid);

%%

v=version;
v=str2double(v(1:3));

if v>=7
    fv='-v6';
else
    fv='';
end

% Set up MAT-file...
try
    FileIdentifier = fopen(fid);
catch ME
    disp(ME.getReport)
    fprintf('The .smrx file might be open by some other program.\n')
    fprintf('Try closing, for example, spike2 and try again...\n')
    return
end
[pathname, name] = fileparts(FileIdentifier);
fclose(fid);

if ~isempty(pathname)
    outfilename=fullfile(pathname, [name, '_CondSig.mat']);
    if exist(outfilename,'file')
        ovwtAns = questdlg(...
            sprintf('Warning! File %s exists. Overwrite?',outfilename),...
            'Overwrite?','Yes','No','No');
        if strcmpi(ovwtAns,'no')
            fprintf('No file written.\n')
            return
        end
    end
    % pathname=[pathname filesep];
end

%FileInfo=SONFileHeader(fid);
FileInfo = SONXFileHeader(FileIdentifier); %#ok<NASGU>


% Deal with the channels in the file
% c=SONChanList(fid);
fhand = CEDS64Open(FileIdentifier);
if fhand > 0
    save(outfilename,'FileInfo',fv)
end
if fhand > 0
    recChans = 0;
    % Import the data.
    mxChans = CEDS64MaxChan(fhand);
    chanList = 1:mxChans;
    SigNames = cell(mxChans,1);
    for ch=1:mxChans
        chtype = CEDS64ChanType(fhand,ch);
        % fprintf('Channel %d type: %d\n',ch,chtype)
        if chtype > 0 && chtype ~= 3
            % Recognized as a channel
            recChans = recChans + 1;
            header = SONXChannelInfo(fhand,ch,recChans);
            SigNames(recChans) = {header.title};
        else
            chanList(ch) = -1;
        end
    end
    chanList(chanList==-1) = [];
    SigNames(cellfun(@isempty,SigNames)) = [];
    [condSig,selOk]=listdlg('ListString',SigNames,'SelectionMode','multiple',...
        'PromptString','Select the conditioning variables:');
    if selOk
        for cch = 1:numel(condSig)
            chtype = CEDS64ChanType(fhand,chanList(condSig(cch)));
            if chtype > 0
                header = SONXChannelInfo(fhand,chanList(condSig(cch)),...
                    condSig(cch));
                fprintf(1,'Importing %s...\n',header.title)
                if chtype == 1 || chtype == 9
                    % Waveform channel
                    [Npts, chanAux, ~] =...
                        SONXGetWaveformChannel(fhand, chanList(condSig(cch)),...
                        header);
                    saveMATfile(Npts,outfilename,chanAux, header,fv)
                elseif chtype > 1 && chtype <= 9 && chtype ~= 5
                    % Event-based channel
                    [Npts, chanAux] =...
                        SONXGetEventsChannel(fhand, chanList(condSig(cch)),...
                        header);
                    saveMATfile(Npts,outfilename,chanAux, header,fv)
                elseif chtype == 5
                    % Keyboard channel
                    [Npts, chanAux] =...
                        SONXGetEventsChannel(fhand, chanList(condSig(cch)),...
                        header);
                    saveMATfile(Npts,outfilename,chanAux, header,fv)
                else
                    % Not a channel or not used and it is suspicious how
                    % did it get into here.
                end
                clearvars('header')
            else
                fprintf(1,'Wrong selection...\n')
                fprintf(1,'%s is not a waveform, event, nor a keyboard\n',...
                    header.title)
            end
        end
    else
        fprintf(1,'Didn''t recognize the conditioning signals?\n');
        fprintf(1,'Check them out in Spike2 and come again later :)\n')
        return
    end
    
    iOk = fhand;
else
    fprintf(1,'Something about this file is not right. Please check it\n')
end

end

function saveMATfile(Npts, matfilename,chanAux, header,fv)
if Npts > 0
    varname = sprintf('chan%d',header.FileChannel);
    S.(varname) = chanAux;
    save(matfilename, '-struct', 'S','-append',fv)
    clearvars('S')
    varname = sprintf('head%d',header.FileChannel);
    S.(varname) = header; %#ok<STRNU>
    save(matfilename, '-struct', 'S','-append',fv)
else
    warning('There is something wrong with channel %d',header.phyChan)
end
end