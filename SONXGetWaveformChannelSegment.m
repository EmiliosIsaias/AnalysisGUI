function [oRead,rWave,oStPt] = SONXGetWaveformChannelSegment(...
    fhand,...   File handler
    ch,...      Channel identification number
    timeSeg,... Time segment to get from the channel
    chinfoStruct) % Channel information
%SONXGetWaveformChannel Reads the selected channel ch from the file with
%its corresponding handler fhand. This function starts reading from the
%start time point given startPt.

% Computing the 'ticks' to start and stop the reading procedure.
chStartPt = CEDS64SecsToTicks(fhand, chinfoStruct.start);
chStopPt = CEDS64SecsToTicks(fhand, chinfoStruct.stop);
tStartPt = CEDS64SecsToTicks(fhand, timeSeg(1)) + chStartPt;
tStopPt = CEDS64SecsToTicks(fhand, timeSeg(2)) + chStartPt;

if tStartPt < chStartPt
    tStartPt = chStartPt;
end
if tStopPt > chStopPt
    tStopPt = chStopPt;
end

chandiv = chinfoStruct.ChanDiv;
scale = chinfoStruct.scale;
offset = chinfoStruct.offset;

N = int64((tStopPt - tStartPt)/chandiv);
[oRead, oWave, oStPt] = CEDS64ReadWaveF(fhand, ch, N+1, tStartPt, tStopPt);
if oRead > 0
    rWave = oWave*scale / 6553.6 + offset;
end