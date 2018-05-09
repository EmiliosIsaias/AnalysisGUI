% Imports Spike2 data into .mat files 
% wrapper for SONImport
% 02/06/09
% A. Groh
% function f=importSMR(fname,fdir)
% returns 0 if successful, -1 otherwise
% fname is string filename, 'example.smr', fdir is file location, 'mydir'

function f=importSMR(fname,fdir,fver)


cd(fdir);
fid=fopen(fname);
if fver == 32
    f=SONImport(fid);
    if ~f
        display(['Successfully imported ' fname]);
    else
        display(['Error importing file ' fname]);
    end
    
else
    f = SONXimport(fid);
end