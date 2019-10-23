function iOk = msmrx2bin(dataDir, outBaseName)
iOk = -1;
impStr = 'Rhd';

smrxFiles = dir(fullfile(dataDir,'*.smrx'));
if isempty(smrxFiles)
    smrxFiles = dir(fullfile(dataDir,'*\*.smrx'));
elseif isempty(smrxFiles)
    fprintf(1,'The given directory contains no .smrx files. Please ')
    fprintf(1,'try again with another folder which do contain .smrx files.\n')
    return
end

cellSmrxFiles = {smrxFiles.name};
Nf = size(smrxFiles,1);

% Selecting files
[incFiles, iok] = listdlg('ListString',cellSmrxFiles(1,:),...
    'SelectionMode','multiple',...
    'PromptString','Select the files to join:',...
    'InitialValue',1:Nf);
if iok
    smrxFiles = smrxFiles(incFiles);
    cellSmrxFiles = {smrxFiles.name};
    Nf = size(smrxFiles,1);
else
    fprintf(1,'Cancelling...\n')
    return
end

% Merging order
fileOrder = (1:Nf)';
defInput = num2cell(num2str(fileOrder));
answr = inputdlg(cellSmrxFiles,'File order',[1, 60],defInput);
nFileOrder = str2double(answr);
nSmrxFiles = smrxFiles;
if ~isempty(answr) && sum(abs(fileOrder - nFileOrder)) ~= 0
    fprintf(1,'Changing file order...\n')
    nSmrxFiles(nFileOrder) = smrxFiles(fileOrder);
    smrxFiles = nSmrxFiles;
else
    fprintf('File order not altered\n')
end
clearvars nSmrxFiles nFileOrder
% Creating a .bin file
if ~exist('outBaseName','var') || isempty(outBaseName) ||...
        ~ischar(outBaseName)
    fprintf(1,'No outname given. Computing a name...\n')
    pathPieces = strsplit(dataDir,filesep);
    outBaseName = [pathPieces{end},'.bin'];
    fprintf(1,'File name: %s.bin\n',pathPieces{end})
end

outFullName = fullfile(dataDir,outBaseName);
if exist(outFullName,'file')
    ovwtAns = questdlg(...
        sprintf('Warning! File %s exists. Overwrite?',outFullName),...
        'Overwrite?','Yes','No','No');
    if strcmpi(ovwtAns,'no')
        fprintf('No file written.\n')
        return
    end
end
fID = fopen(outFullName,'w');
m = (2^32)/100;
for cf = 1:Nf
    cfName = fullfile(smrxFiles(cf).folder,smrxFiles(cf).name);
    FileInfo = SONXFileHeader(cfName);
    fhand = CEDS64Open(cfName);
    totalTime = CEDS64TicksToSecs(fhand,FileInfo.maxFTime);
    
    if fhand > 0
        % Import the data.
        mxChans = CEDS64MaxChan(fhand);
        chanList = 1:mxChans;
        chTypes = zeros(mxChans,1);
        try
            heads = SONXChannelInfo(fhand,1,1);
            fch = 2;
            ch1 = 2;
            chTypes(1) = 1;
        catch
            heads = SONXChannelInfo(fhand,2,2);
            fch = 3;
            ch1 = 3;
            chTypes(2) = 1;
        end
        heads = repmat(heads,mxChans,1);
        for ch = ch1:mxChans
            chTypes(ch) = CEDS64ChanType(fhand,ch);
            if chTypes(ch) == 1
                fch = fch + 1;
                heads(ch) = SONXChannelInfo(fhand,ch,fch);
            end
        end
        heads = heads(chTypes == 1);
        chanList = chanList(chTypes == 1);
        chead = numel(heads);
        while chead >= 1
            if ~xor(isnan(str2double(heads(chead).title)),...
                    ~contains(heads(chead).title,impStr))
                heads(chead) = [];
                chanList(chead) = [];
            end
            chead = chead - 1;
        end
        multiplexerFactor = heads(1).ChanDiv;
        fs = 1 / (FileInfo.usPerTime * multiplexerFactor);
        FileInfo.SamplingFrequency = fs;
        save(fullfile(dataDir,...
            [smrxFiles(cf).name, '_sampling_frequency.mat']),'fs')
        display(FileInfo)
        dataPointsExp = ceil(log10(fs)+2);
        wwidth = 10^ceil(log10(fs)+2)/fs;
        is = 1/fs;
        cw = 0;
        while cw < totalTime
            %         if exist('Npts','var')
            %             fID = fopen(outfilename,'a');
            %         end
            dataBuff = zeros(numel(chanList),10^dataPointsExp,'int16');
            if cw <= totalTime - wwidth
                timeSegment = [cw, cw + wwidth];
            else
                timeSegment = [cw, totalTime];
                cw = totalTime * 2;
                dataBuff = zeros(numel(chanList),int32(diff(timeSegment)*fs),...
                    'int16');
            end
            for ch = 1:numel(chanList)
                [Npts, chanAux, ~] =...
                    SONXGetWaveformChannelSegment(fhand, chanList(ch), timeSegment,...
                    heads(ch)); %#ok<ASGLU>
                dat = int16(chanAux * m);
                try
                    dataBuff(ch,:) = dat;
                catch
                    dataBuff(ch,1:length(dat)) = dat;
                end
            end
            cw = cw + wwidth + is;
            fwrite(fID,dataBuff,'int16');
            %         ftell(fID)
            %         fclose(fID);
        end
    end
    CEDS64Close(fhand);
end
fclose(fID);
fprintf('Successfully imported files!\n')
fprintf('The files merged are the following:\n')
for cf = 1:numel(smrxFiles)
    fprintf('%s\n',smrxFiles(cf).name)
end
iOk = CEDS64Close(fhand);
end