function Conditions=findTriggers_helper(tL,tW,ppms,stimtype,varargin)
if numel(varargin)>0
stimWindow=varargin{1};
end


Conditions={};
switch stimtype
    case 'L'
        Conditions{1}.Triggers=tL;
        Conditions{1}.name='L';
        Conditions{1}.delay=0;
        
    case 'W'
        Conditions{1}.Triggers=tW;
        Conditions{1}.name='W';
        Conditions{1}.delay=0;
    case 'Paired'
        Conditions{1}.Triggers=tW;
        Conditions{1}.name='W';
        Conditions{1}.delay=0;
        Conditions{2}.Triggers=tL;
        Conditions{2}.name='L';
        Conditions{2}.delay=0;
    case 'Lag'
        Conditions=LagConditions(tL,tW,ppms,stimWindow);
    case 'Custom'
        itn=varargin{1};
        N=varargin{2};
        trigs=tW(1:N:end);
        numel(trigs)
        for i=1:itn
            Conditions{i}.Triggers=trigs(i:itn:end);
            Conditions{i}.name=num2str(i);
            Conditions{i}.delay=num2str(i);
        end
    case 'Frequency'
        if length(varargin)==2
            fm = varargin{1};
            cf = varargin{2};
            [tL,tM] = assignClass(tL,tW,fm);
            Conditions = getFrequencyConditions(tL,tM,ppms,cf);
        end
end

function [tLnew,tWnew] = assignClass(tL,tW,fm)
% Function to make more efficient!
lpc = fm([1,3],fm(1,:)~=0);
mpc = fm([2,3],fm(2,:)~=0);
LC = [];
for lc = 1:length(lpc)
    LC = [LC,ones(1,lpc(1,lc))*lpc(2,lc)];
end
MC = [];
for mc = 1:length(mpc)
    MC = [MC,ones(1,mpc(1,mc))*mpc(2,mc)];
end
tLnew = [tL;LC];
tWnew = [tW;MC];

function Conditions = getFrequencyConditions(tL,tM,ppms,cf)
Conditions = cell(1,length(cf));
for cc = 1:length(cf)
    % Control conditions
    if sum(tL(3,:)==cc) && sum(tM(3,:)==cc)
        % Not control
        % In order for the PSTH algorithm to work, we only need the first 
        crL = tL(1,tL(3,:)==cc)';
        crM = tM(1,tM(3,:)==cc);
        freq =...
            num2str(round(median(1./diff(crL/(ppms*1000)))));
        name = [freq,'Hz'];
        trig = crM;
    elseif sum(tM(3,:)==cc)
        % Mechanical control
        name = 'MechControl';
        trig = tM(1,tM(3,:)==cc)';
    else
        % Light control
        auxTrig =  tL(1,tL(3,:)==cc)';
        consTrig = diff(auxTrig);
        % If the light control is found only once, the initial onset is
        % taken as the condition trigger.
        if std(consTrig) < 2
            initTrig = 1;
        else
            initTrig = cat(find(size(consTrig)~=1),true,consTrig>mean(consTrig));
        end
        trig = auxTrig(initTrig);
        name = 'LaserControl';
    end
    Conditions{cc}.name = name;
    Conditions{cc}.Triggers = trig;
    Conditions{cc}.delay = 0;
end
disp(Conditions)


function Conditions=LagConditions(tL,tW,ppms,stimWindow)

%find pairstim
Conditions={};
pairs=[];
for i=1:numel(tL)
    dt=(tW-tL(i));
    index=find((dt<=stimWindow) & (dt>=-stimWindow));
    %index
    %'hi'
    if ~isempty(index)
        pairs=[pairs;[tL(i) tW(index) dt(index)]];
    end
end

if isempty(pairs)
    W=tW;
    L=tL;
else
    W=setdiff(tW,pairs(:,2));
    L=setdiff(tL,pairs(:,1));
end



if ~isempty(L) && ~isempty(W)
        Conditions{2}.name='L';
        Conditions{2}.Triggers=L;
        Conditions{2}.delay=0;
        Conditions{1}.name='W';
        Conditions{1}.Triggers=W;
        Conditions{1}.delay=0;
end

if ~isempty(pairs)
    pairs(:,3)=round(pairs(:,3)/ppms)*ppms;
    lags=flipud(unique(pairs(:,3)))
    ConditionsPaired={};
    for i=1:numel(lags)
        lag=lags(i);
        indices=find(pairs(:,3)==lag);
        if lag<=0
            name=['W' num2str(abs(lag/ppms)) 'L'];
            Triggers=pairs(indices,2);
        else
            name=['L' num2str(abs(lag/ppms)) 'W'];
            Triggers=pairs(indices,2);
        end
        ConditionsPaired{i}.name=name;
        ConditionsPaired{i}.Triggers=Triggers;
        ConditionsPaired{i}.delay=lag;
    end
    
    Conditions=[Conditions ConditionsPaired];
end
Conditions{:}
