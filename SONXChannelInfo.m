function chHead = SONXChannelInfo(fhand,ch,fch)
chHead.system = ['SON', num2str(CEDS64Version(fhand))];
chHead.phyChan = ch;
chType = CEDS64ChanType(fhand,ch);
chHead.kind = chType;
[~,cmnt] = CEDS64ChanComment(fhand,ch);
chHead.comment = cmnt;
[~, sTitle]  = CEDS64ChanTitle(fhand,ch);
chHead.title = sTitle;
chHead.TickInterval = CEDS64TimeBase(fhand);
chHead.MaxTicks = CEDS64MaxTime(fhand);
[~, doffset] = CEDS64ChanOffset(fhand,ch);
[~, dScale] = CEDS64ChanScale(fhand, ch);
chHead.scale = dScale;
chHead.offset = doffset;
[~, chLow, chHigh] = CEDS64ChanYRange(fhand,ch);
chHead.min = chLow;
chHead.max = chHigh;
mxTime = CEDS64ChanMaxTime(fhand,ch);
chHead.maxticks = mxTime;
chHead.FileChannel = fch;
dTicks = CEDS64ChanDiv(fhand,ch);
chHead.ChanDiv = dTicks;
chHead.sampleinterval = CEDS64TicksToSecs(fhand,dTicks)*10^6; % ms
switch chType
    case {1,9}
        % dTicks = CEDS64ChanDiv(fhand,ch);
        % chHead.ChanDiv = dTicks;
        % chHead.sampleinterval = CEDS64TicksToSecs(fhand,dTicks)*10^6; % ms
        [~, chUnits] = CEDS64ChanUnits(fhand,ch);
        chHead.Units = chUnits;
        [~,~,strtPt] = CEDS64ReadWaveS(fhand,ch,1,1);
        chHead.start = CEDS64TicksToSecs(fhand,strtPt);
        chHead.stop = CEDS64TicksToSecs(fhand,mxTime);
        chHead.SamplingFrequency =...
            1/CEDS64TicksToSecs(fhand,CEDS64ChanDiv(fhand,ch));
        chHead.npoints = (mxTime - strtPt)/dTicks;
    case {2,3}
        chHead.IdealRate = CEDS64IdealRate(fhand,ch);
    case 4
    case 5
    case 6
    case 7
    case 8
    otherwise
end

end