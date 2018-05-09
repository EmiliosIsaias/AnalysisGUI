function Data=getFiles(datafiles,varargin);

Data={};

for i=1:numel(datafiles)
    if ~isempty(varargin)
        
            Data{i}=load(datafiles{i},'EEG','spikeFindingData','spikeFindingData2','upT','HandUp','halfshift','Conditions','DepressionState','DepressionState2');
    else
    Data{i}=load(datafiles{i});
    end
end