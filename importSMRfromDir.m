function f=importSMRfromDir(fdir)

cd(fdir)


cellDirs=dir('c*')

for ii=1:numel(cellDirs)
    cd(cellDirs(ii).name)
    X=dir('*.smr')
    f=[];
    for i=1:numel(X)
        fname=X(i).name;
        f(i)=importSMR(fname,[fdir '\'  cellDirs(ii).name]);
    end
    cd ..
end