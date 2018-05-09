function Head = SONXFileHeader(fname)

fhand = CEDS64Open(fname);
if fhand < 0
    warning('There is something wrong with this file')
    return;
else
    Head.FileIdentifier = fname;
    Head.systemID = CEDS64Version(fhand);           % 6
    Head.copyright = '(C) CED 14';% Where is the copyright?! fscanf(fid,'%c',10);
    [iOK, Creator] = CEDS64AppID(fhand);
    if iOK == 0
        Head.Creator = sprintf('%s',Creator);
    end
    Head.usPerTime = CEDS64TimeBase(fhand); % The units are seconds.
    %     Head.timePerADC = 1;% Not found in the function list-fread(fid,1,'int16');
    if iOK == 0
        Head.filestate=1;
    end
    % Head.firstdata=fread(fid,1,'int32'); Don't knwo what it refers to.
    Head.channels = CEDS64MaxChan(fhand);
    % These three fileds are not to be found in the
    %     Head.chansize=fread(fid,1,'int16');
    %     Head.extraData=fread(fid,1,'int16');
    %     Head.buffersize=fread(fid,1,'int16');
    Head.osFormat = 0;% Assuming its always windows (0) fread(fid,1,'int16');
    Head.maxFTime = CEDS64MaxTime(fhand);
    % Head.dTimeBase=fread(fid,1,'float64'); I don't know the difference
    % between this dTimeBase and the usPerTime.
    if Head.systemID<6
        Head.dTimeBase=1e-6;
    end
    [~, timeVect] = CEDS64TimeDate(fhand);
    Head.timeDate.Detail = timeVect(1:6)';
    Head.timeDate.Year = timeVect(7);
    if Head.systemID<6
        Head.timeDate.Detail=zeros(6,1);
        Head.timeDate.Year=0;
    end
    % These two are most probably not going to be used.
    %     Head.pad=fread(fid,52,'char=>char');
    %     Head.fileComment=cell(5,1);
    CEDS64Close(fhand);
end
end