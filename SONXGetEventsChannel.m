function [oRead, outstr] = SONXGetEventsChannel(...
    fhand,...   File handler
    ch,...      Channel identification number
    chinfoStruct)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% stopPt = chinfoStruct.Stop;
N =...
    int32(...
    CEDS64TicksToSecs(fhand,...
    CEDS64MaxTime(fhand))*CEDS64IdealRate(fhand,ch));
switch chinfoStruct.kind
    case {2,3}  % Rise or fall edges
        [oRead, outstr] = CEDS64ReadEvents(fhand, ch, N, 0);
    case 4      % Both rise and fall
    case 5      % Marker
        [oRead, mrkObj] = CEDS64ReadMarkers(fhand, ch, N, 0);
        outstr = mrkObj;
    case 6      % WaveMark
    case 7      % RealMark
    case 8      % TextMark
    otherwise
        warning('Unrecognized channel type')
        return
end
if oRead <= 0
    outstr = 0;
end