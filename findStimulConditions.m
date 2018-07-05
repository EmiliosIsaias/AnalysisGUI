function [fm,condRep,tp1,tp2] = findStimulConditions(stim1,stim2)
%findStimulConditions Returns the pulse density and their classification
%for both stimuli taking into account the longest pulse as the condition
%duration. This could be modified in the future.
% GitHub Comment
if verifyStimulus(stim1) && verifyStimulus(stim2)
    [r1,f1] = getRiseFall(stim1);
    [r2,f2] = getRiseFall(stim2);
    if numel(stim1) == numel(stim2)
        tx = 1:numel(stim1);
        % Rising and falling edges, and pulse duration
        tr1 = tx(r1);tf1 = tx(f1);pd1 = abs(tr1-tf1);
        tp1 = cat(find(size(tr1)==1),tr1,tf1);
        tr2 = tx(r2);tf2 = tx(f2);pd2 = abs(tr2-tf2);
        tp2 = cat(find(size(tr2)==1),tr2,tf2);
        tr = sort([tr1,tr2],'ascend');
        same_edge = diff(tr);
        tr(~same_edge) = 0;
        % Pulse-pulse distance
        ppd1 = abs(tf1(1:end-1)-tr1(2:end));
        ppd2 = abs(tf2(1:end-1)-tr2(2:end));
        % Assumed condition duration: (td)
        td = (max(max(pd1),max(pd2)) + min(min(ppd1),min(ppd2)));
        % Flags and counters
        ce = 1;
        sm = 0;
        fm_counter = 1;
        while ce <= numel(tr)
            if tr(ce)
                idxStim1 = tr(ce) <= tr1 & tr(ce)+td > tr1;
                idxStim2 = tr(ce) <= tr2 & tr(ce)+td > tr2;
                pulse_density1 = sum(idxStim1);
                pulse_density2 = sum(idxStim2);
                fm(1,fm_counter) = pulse_density1; %#ok<AGROW>
                fm(2,fm_counter) = pulse_density2; %#ok<AGROW>
                fm_counter = fm_counter + 1;
                if sm
                    a = max(pulse_density1,pulse_density2);
                else
                    a = pulse_density1 + pulse_density2;
                end
                ce = ce + a;
                sm = 0;
            else
                ce = ce + 1;
                sm = 1;
            end
        end
        if sum(fm(1,:)) ~= numel(tr1)
            % We need to think what to do.
            error(['There was a misscalculation in stimulus 1.',...
                'We need to take a closer look at these signals'])
        end
        if sum(fm(2,:)) ~= numel(tr2)
            % We need to think what to do.
            error(['There was a misscalculation in stimulus 2.',...
                'We need to take a closer look at these signals'])
        end
        [clss, condRep] = KNNinit(fm);
        fm = [fm;clss];
    else
        warning('The size of the stimuli is different for each array\n')
        return;
    end
else
    warning('Further verify the stimulus: length, amplitude, etc.')
    return
end
end

%% Auxiliary functions

function iok = verifyStimulus(stim)
if sum(stim)~=0
    iok = true;
else
    iok = false;
end
end

function [clsses, condRep] = KNNinit(featureMatrix)
% Find and assign a class to each condition.
[~, obs] = size(featureMatrix);
clsses = zeros(1,obs);
condRep = clsses;
Conds = 0;
for cObs = 1:obs
    if clsses(cObs)
        if sum(~clsses)
            continue;
        else
            break;
        end
    else
        ptDist = distmatrix(featureMatrix(:,cObs)',featureMatrix');
        kClassCondN = sum(~ptDist);
        if kClassCondN
            Conds = Conds + 1;
            condRep(Conds) = kClassCondN;
            clsses(~ptDist) = Conds;
        end
    end
end
condRep(~condRep) = [];
end

function  [rise, fall] = getRiseFall(stim)
rise = [];
fall = [];
if isnumeric(stim)
    ds = diff(stim);
    rise = false(size(stim));    % Rising edge times
    fall = rise;                    % Falling edge times
    % Maximum value divided by three
    rise(2:end) = ds > max(abs(ds))/3;
    rise = cleanEdges(rise);
    fall(1:end-1) = ds < min(ds)/3;
    fall = cleanEdges(fall);
    if sum(rise) ~= sum(fall)
        warning('The cardinality of the rising edges is different for the falling edges\n')
    end
elseif isa(stim,'logical')
    aux = stim(1:end-1) - stim(2:end);
    rise = find(aux == -1)' + 1;
    fall = find(aux == 1)';
    if (~isempty(rise) && isempty(fall)) || (numel(rise) ~= numel(fall))
        fall = [fall;length(stim)];
    end
else
    fprintf('Unrecognised data type for a trigger signal!\n')
    fprintf('Returning empty variables...\n')
end
end


function edgeOut = cleanEdges(edgeIn)
doubleEdge = edgeIn(1:end-1) + edgeIn(2:end);
repeatIdx = doubleEdge > 1;
edgeOut = edgeIn;
if sum(repeatIdx)
    edgeOut(repeatIdx) = false;
end
end