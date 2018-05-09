
thisfile = 'whiskerL5B_trunc'


channels=load(thisfile,'chan*');

chans=fieldnames(channels);



%%
M=[];
for i=1:numel(chans)
    eval(['thischan=channels.' chans{i} ';'])
    M(i)=size(thischan,1);
end

m=min(M);


for i=1:numel(chans)
    eval([chans{i} '=channels.' chans{i} '(1:m,:);'])
end

save(thisfile,chans{:},'-append')