function iOk = SONXimport(fid)
iOk = -1;


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
    matfilename=fullfile(pathname, [name, '.mat']);
    % pathname=[pathname filesep];
end

%FileInfo=SONFileHeader(fid);
FileInfo = SONXFileHeader(FileIdentifier); %#ok<NASGU>
% ...overwriting any existing file
save(matfilename,'FileInfo',fv)

% Deal with the channels in the file
% c=SONChanList(fid);
fhand = CEDS64Open(FileIdentifier);
if fhand > 0
    recChans = 0;
    % Import the data.
    mxChans = CEDS64MaxChan(fhand);
    chanList = 1:mxChans;
    for ch=1:mxChans
        chtype = CEDS64ChanType(fhand,ch);
        % fprintf('Channel %d type: %d\n',ch,chtype)
        if chtype > 0
            % Recognized as a channel
            recChans = recChans + 1;
            header = SONXChannelInfo(fhand,ch,recChans);
            if chtype == 1 || chtype == 9
                % Waveform channel
                [Npts, chanAux, ~] =...
                    SONXGetWaveformChannel(fhand, ch,...
                    header);
                saveMATfile(Npts,matfilename,chanAux, header,fv)
            elseif chtype > 1 && chtype <= 9 && chtype ~= 5
                % Event-based channel
                [Npts, chanAux] =...
                    SONXGetEventsChannel(fhand, ch,...
                    header);
                saveMATfile(Npts,matfilename,chanAux, header,fv)
            elseif chtype == 5
                % Keyboard channel
                [Npts, chanAux] =...
                    SONXGetEventsChannel(fhand, ch,...
                    header);
                saveMATfile(Npts,matfilename,chanAux, header,fv)
            else
                % Not a channel or not used and it is suspicious how
                % did it get into here.
            end
            clearvars('header')
        else
            chanList(ch) = -1;
        end
    end
    chanList(chanList==-1) = [];
end
fprintf('Successfully imported file!\n')
fprintf('The channels in the file are the following:\n')
for cch = 1:numel(chanList)
    fprintf('%d ',chanList(cch))
end
fprintf('\n')
iOk = fhand;
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