function iOk = smrx2bin(fid)
iOk = -1;
impStr = 'Rhd';

try
    FileIdentifier = fopen(fid);
catch ME
    disp(ME.getReport)
    fprintf('The .smrx file might be open by some other program.\n')
    fprintf('Try closing, for example, spike2 and try again...\n')
    return
end

if isnumeric(FileIdentifier)
    [pathname, name] = fileparts(fid);
    FileInfo = SONXFileHeader(fid);
    fhand = CEDS64Open(fid);
    fclose(FileIdentifier);
else
    [pathname, name] = fileparts(FileIdentifier);
    FileInfo = SONXFileHeader(FileIdentifier);
    fhand = CEDS64Open(FileIdentifier);
    fclose(fid);
end



if ~isempty(pathname)
    outfilename = fullfile(pathname, [name, '.bin']);
    if exist(outfilename,'file')
        ovwtAns = questdlg(...
            sprintf('Warning! File %s exists. Overwrite?',outfilename),...
            'Overwrite?','Yes','No','No');
        if strcmpi(ovwtAns,'no')
            fprintf('No file written.\n')
            return
        end
    end
    fID = fopen(outfilename,'w');
end
totalTime = CEDS64TicksToSecs(fhand,FileInfo.maxFTime);
m = (2^32)/100;
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
    save(fullfile(pathname, [name, '_sampling_frequency.mat']),'fs')
    display(FileInfo)
    % Determining the necessary array size to occupy approximately the
    % 75% of the available memory given that the array is int16
    memStruct = memory;
    BuffSize = 3 * memStruct.MemAvailableAllArrays / 8;
    dataPointsExp = (BuffSize / (numel(chanList) * 2));
    if heads(1).npoints < dataPointsExp
        dataPointsExp = heads(1).npoints;
    end
    wwidth = double(dataPointsExp)/fs;
%     dataPointsExp = ceil(log10(fs)+2);
%     wwidth = 10^ceil(log10(fs)+2)/fs;
    is = 1/fs;
    cw = 0;
    if abs(totalTime-(heads(1).stop - heads(1).start))
        oldTotalTime = totalTime;
        totalTime = heads(1).stop - heads(1).start;
        fprintf(1,'The length of the signals in the file seem to ')
        fprintf(1,'differ (%.3f s \\delta (%.3f ms)).\nConsidering %.3f seconds\n',...
            oldTotalTime, 1e3*(oldTotalTime - totalTime), totalTime)
    end
    while cw < totalTime
%         if exist('Npts','var')
%             fID = fopen(outfilename,'a');
%         end
        % dataBuff = zeros(numel(chanList),10^dataPointsExp,'int16');
        dataBuff = zeros(numel(chanList),dataPointsExp,'int16');
        if cw <= totalTime - wwidth
            timeSegment = [cw, cw + wwidth];
        else
            timeSegment = [cw, totalTime];
            cw = totalTime * 2;
            dataBuff = zeros(numel(chanList),int32(diff(timeSegment)*fs),...
                'int16');
        end
        fprintf(1,'Reading... ')
        for ch = 1:numel(chanList)
            [Npts, chanAux, ~] =...
                SONXGetWaveformChannelSegment(fhand, chanList(ch), timeSegment,...
                heads(ch)); 
            dat = int16(chanAux * m);
            try
                dataBuff(ch,:) = dat;
            catch
                fprintf(1,'Introducing an untraceable delay!\n')
                dataBuff(ch,1:Npts) = dat;
            end
        end
        fprintf(1,'done!\n')
        cw = cw + wwidth + is;
        fprintf(1,'Writing... ')
        fwrite(fID,dataBuff,'int16');
        fprintf(1,'done!\n')
%         ftell(fID)
%         fclose(fID);
    end
end
fclose(fID);
fprintf('Successfully imported file!\n')
fprintf('The channels in the file are the following:\n')
for cch = 1:numel(chanList)
    fprintf('%d ',chanList(cch))
end
fprintf('\n')
iOk = CEDS64Close(fhand);
end