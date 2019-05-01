function Head = SONXFileHeader(fname)

fhand = CEDS64Open(fname);
Head = struct();
switch fhand
    case 0
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
    case -1 %NO_FILE
        fprintf(1,'Attempt to use when file not open, or use of an ')
        fprintf(1,'invalid file handle, or no spare file handle.\n')
        fprintf(1,'Some functions that return a time will return -1 to ')
        fprintf(1,'mean nothing found, so this is not necessarily an error.\n')
        fprintf(1,'Check the function description.')
    case -2 %NO_BLOCK
        disp('Failed to allocate a disk block when writing to the file.')
        disp('The disk is probably full, or there was a disk error.')
    case -3 %CALL_AGAIN
        disp('This is a long operation, call again.')
        disp('If you see this, something has gone wrong as this if for internal SON library use, only.')
    case -5 %NO_ACCESS
        disp('This operation was not allowed.')
        disp('Bad access (privilege violation), file in use by another process.')
    case -8 %NO_MEMORY
        disp('Out of memory reading a 32-bit son file')
    case -13 %WRONG_FILE
        disp('Attempt to open a wrong file type')
    case -17 %BAD_READ
        disp('A read (disk) error was detected. This is an OS error')
    case -19 %CORRUPT_FILE
        disp('The file is bad!')
    case -21 %READ_ONLY
        disp('Attempt to write to a read-only file')
    case -22 %BAD_PARAMS
        disp('A bad parameter to a call into the SON library')
    case -23 %OVER_WRITE
        disp('An attempt was made to over-write data when not allowed')
    case -24 %MORE_DATA
        disp('A file is bigger than the header says; maybe not closed')
        disp('correctly. Use S64Fix on it.')
    otherwise
        disp('Something is seriously wrong with this file...')
end
end