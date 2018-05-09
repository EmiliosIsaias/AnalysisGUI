
clear all
close all

files={}


Data=getFiles(files);
for I=1:numel(Data)
    ppms=Data{I}.spikeFindingData.ppms;
    v=Data{I}.RawResponse.data;  %need multiplier?
    timeBefore=100*ppms;
    timeAfter=200*ppms;
    for i=1:numel(Data{I}.Conditions)
         triggers=Data{I}.Conditions{i}.triggers;
    V=TriggeredSegments(v,triggers,-timeBefore, timeAfter);
    end
    t=[-timeBefore:timeAfter]/ppms;
    figure
    plot(t,V)
end
%%

