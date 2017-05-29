addpath('/users/cosic/rzhang/Desktop/matlab/MDPtoolbox/fsroot/MDPtoolbox');

clear

% alphaPower is the mining power share of the attacker
% gammaRatio is the proportion of honest miners that would mine on the
%     attacker's chain during a tie
% maxForkLen is the maximum length of a block fork
global alphaPower gammaRatio maxForkLen;

alphaPower = 0.475;
gammaRatio = 0;

% Please note that for larger alpha, the gap between uppper and lower bound
%     would be larger. It takes a larger maxForkLen for these two bounds to
%     converge. Even 160 is not always enough.
if alphaPower >= 0.45
    maxForkLen = 160;
else
    maxForkLen = 80;
end

SolveStrategy;
