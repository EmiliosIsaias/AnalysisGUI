function splitData(fname,starts,ends);



load(fname)
x=whos('chan*');
X={};

ppms=1/head2.sampleinterval*1000;
starts=ceil(starts*ppms*1000);
ends=ceil(ends*ppms*1000);
for i=1:numel(x)
    eval(['X{i}=' x(i).name ';'])
end

for i=1:numel(starts)
    indices=starts(i):ends(i);
    i
    for j=1:numel(X)
         eval([x(j).name '=X{j}(indices);']);
    end
    newname=[fname(1:end-4) 'part' num2str(i) '.mat'];
    save(newname, 'chan*', 'head*', 'FileInfo')
    clear chan*
end

