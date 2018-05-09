

fname='test.mat'
fdir='C:\Users\rebecca\Documents\AnalysisGui' 
strs=fieldnames(open([fdir '\' fname]));

headerNames={};
channelNames={};

for i=1:numel(strs)
    if ~isempty(strfind(strs{i},'chan'))
        channelNames=[channelNames;strs{i}];
    end
    if ~isempty(strfind(strs{i},'head'))
        headerNames=[headerNames;strs{i}];
    end
end


[temp1]=AssignChannels_gui(channelNames,headerNames)
