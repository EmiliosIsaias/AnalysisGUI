
function stims=getTriggersNew(x,minStimDistance,aboveZero)


if mean(x)<0,x=-x;end
if max(abs(x))< 10*min(abs(x)) || sum(x)==0
    stims=[];
    disp('No stimuli found');
    return
end
if islogical(x)
elseif isnumeric(x)
    m=max(x);
    x=x/m;
    
else
end
dx=zeros(size(x));
dx(2:end)=diff(x);
%dx1=[diff(x);0];
stims=find(dx>0);
stims=stims(x(stims)>aboveZero);

%THIS GETS RID OF DUPLICATE STIMS FROM THE SAME PULSE
dstims = cat(find(size(stims)~=1),1e8,diff(stims));
% dstims=[100000000;diff(stims)];
stims=stims(dstims>minStimDistance);
