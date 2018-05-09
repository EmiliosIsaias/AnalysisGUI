function [avSign,infPts] = averageEvokedSignal(timePulse,signal)
%averageEvokedSignal Summary of this function goes here
%   Detailed explanation goes here
safeDuration = ceil(mean(abs(timePulse(1,:)-timePulse(2,:))) * 1.25);
[~,N] = size(timePulse);
signalArray = zeros(N,safeDuration);
for idx = 1:N
    signalArray(idx,:) =...
        signal(timePulse(1,idx):timePulse(1,idx)+safeDuration-1);
end
avSign = mean(signalArray,1);
infPts = inputArg2;
end

