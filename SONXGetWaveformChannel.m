function [oRead,rWave,oStPt] = SONXGetWaveformChannel(...
    fhand,...   File handler
    ch,...      Channel identification number
    chinfoStruct)
%SONXGetWaveformChannel Reads the selected channel ch from the file with
%its corresponding handler fhand. This function starts reading from the
%start time point given startPt.
startPt = CEDS64SecsToTicks(fhand,chinfoStruct.start);
stopPt = CEDS64SecsToTicks(fhand,chinfoStruct.stop);
chandiv = chinfoStruct.ChanDiv;
scale = chinfoStruct.scale;
offset = chinfoStruct.offset;

N = int64((stopPt - startPt)/chandiv);
[oRead, oWave, oStPt] = CEDS64ReadWaveF(fhand, ch, N+1, startPt);
if oRead > 0
    rWave = oWave*scale / 6553.6 + offset;
end