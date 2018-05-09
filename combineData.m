function combineData(fname1,fname2, newname);
copyfile(fname1,newname)
X={};
load(fname1,'chan*')
x=whos('chan*');

for i=1:numel(x)
    eval(['X{i}=' x(i).name ';'])
end

clear chan*
load(fname2, 'chan*');
x=whos('chan*');

for i=1:numel(x)
    eval(['X{i}=[X{i};' x(i).name '];'])
end



for i=1:numel(x)
    eval([x(i).name '=X{i};']);
end
    
save(newname, 'chan*','-append')