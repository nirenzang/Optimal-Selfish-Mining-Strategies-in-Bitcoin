global maxForkLen;
global numOfStates; numOfStates = (maxForkLen+1) * (maxForkLen+1) * 3;
disp(['numOfStates: ' num2str(numOfStates)]);
% a and h can be 0 to maxForkLen, altogether maxForkLen + 1 values
global alphaPower gammaRatio;
% fork: 0 means irrelevant: match is not feasible, either last block is
% selfish OR honest branch is empty
% 1 means relevant: if a>=h now, match is feasible, e.g. last block is honest
% 2 means active (just perfomed a match)
global irrelevant relevant active; 
irrelevant = 0; relevant = 1; active = 2;
% actions: 1 adopt, 2 override, 3 match, 4 wait
choices = 4;
adopt = 1; override = 2; match = 3; wait = 4;
global rou Wrou lowerBoundRou;
global P Rs Rh;

P = cell(1,choices);
% Rs is the reward for selfish miner
Rs = cell(1,choices);
% Rh is the reward for honest miners
Rh = cell(1,choices);
Wrou = cell(1,choices);
for i = 1:choices
    P{i} = sparse(numOfStates, numOfStates);
    Rs{i} = sparse(numOfStates, numOfStates);
    Rh{i} = sparse(numOfStates, numOfStates);
    Wrou{i} = sparse(numOfStates, numOfStates);
end

% define adopt
P{adopt}(:, st2stnum(1, 0, irrelevant)) = alphaPower;
P{adopt}(:, st2stnum(0, 1, irrelevant)) = 1 - alphaPower;
for i = 1:numOfStates
    if mod(i, 2000)==0
        disp(['processing state: ' num2str(i)]);
    end
    [a h fork] = stnum2st(i);
    Rh{adopt}(i,st2stnum(1, 0, irrelevant)) = h;
    Rh{adopt}(i,st2stnum(0, 1, irrelevant)) = h;
    % define override
    if a > h
        P{override}(i, st2stnum(a-h, 0, irrelevant)) = alphaPower;
        Rs{override}(i, st2stnum(a-h, 0, irrelevant)) = h+1;
        P{override}(i, st2stnum(a-h-1, 1, relevant)) = 1-alphaPower;
        Rs{override}(i, st2stnum(a-h-1, 1, relevant)) = h+1;
    else % just for completeness
        P{override}(i, 1) = 1;
        Rh{override}(i, 1) = 10000;
    end
    % define wait
    if fork ~= active && a+1 <= maxForkLen && h+1 <= maxForkLen
        P{wait}(i, st2stnum(a+1, h, irrelevant)) = alphaPower;
        P{wait}(i, st2stnum(a, h+1, relevant)) = 1-alphaPower;
    elseif fork == active && a > h && h > 0 && a+1 <= maxForkLen && h+1 <= maxForkLen
        P{wait}(i, st2stnum(a+1, h, active)) = alphaPower;
        P{wait}(i, st2stnum(a-h, 1, relevant)) = gammaRatio*(1-alphaPower);
        Rs{wait}(i, st2stnum(a-h, 1, relevant)) = h;
        P{wait}(i, st2stnum(a, h+1, relevant)) = (1-gammaRatio)*(1-alphaPower);
    else
        P{wait}(i, 1) = 1;
        Rh{wait}(i, 1) = 10000;
    end
    % define match: match if feasible only when the last block is honest
    % and the selfish miner has more blocks before the last block is mined
    if fork == relevant && a >= h && h > 0 && a+1 <= maxForkLen && h+1 <= maxForkLen
        P{match}(i, st2stnum(a+1, h, active)) = alphaPower;
        P{match}(i, st2stnum(a-h, 1, relevant)) = gammaRatio * (1-alphaPower);
        Rs{match}(i, st2stnum(a-h, 1, relevant)) = h;
        P{match}(i, st2stnum(a, h+1, relevant)) = (1-gammaRatio) * (1-alphaPower);
    else
        P{match}(i, 1) = 1;
        Rh{match}(i, 1) = 10000;
    end
end

disp(mdp_check(P, Rs))

epsilon = 0.0001;

lowRou = 0;
highRou = 1;
while(highRou - lowRou > epsilon/8)
    rou = (highRou + lowRou) / 2;
    for i = 1:choices
        Wrou{i} = (1-rou).*Rs{i} - rou.*Rh{i};
    end
    [lowerBoundPolicy reward cpuTime] = mdp_relative_value_iteration(P, Wrou, epsilon/8);
    if(reward > 0)
        lowRou = rou;
    else
        highRou = rou;
    end
end
disp('lowerBoundReward: ')
format long
disp(rou)

lowerBoundRou = rou;
lowRou = rou;
highRou = min(rou + 0.1, 1);
while(highRou - lowRou > epsilon/8)
    rou = (highRou + lowRou) / 2;
    for i=1:numOfStates
        [a h fork] = stnum2st(i);
        if a == maxForkLen
            mid1 = (1-rou)*alphaPower*(1-alphaPower)/(1-2*alphaPower)^2+0.5*((a-h)/(1-2*alphaPower)+a+h);
            Rs{adopt}(i, st2stnum(1, 0, irrelevant)) = mid1;
            Rs{adopt}(i, st2stnum(0, 1, irrelevant)) = mid1;
            Rh{adopt}(i, st2stnum(1, 0, irrelevant)) = 0;
            Rh{adopt}(i, st2stnum(0, 1, irrelevant)) = 0;
        elseif h == maxForkLen
            mid1=alphaPower*(1-alphaPower)/((1-2*alphaPower)^2);
            mid2=(alphaPower/(1-alphaPower))^(h-a);
            mid3=(1-mid2)*(0-rou)*h+mid2*(1-rou)*(mid1+(h-a)/(1-2*alphaPower));
            Rs{adopt}(i, st2stnum(1, 0, irrelevant)) = mid3;
            Rs{adopt}(i, st2stnum(0, 1, irrelevant)) = mid3;
            Rh{adopt}(i, st2stnum(1, 0, irrelevant)) = 0;
            Rh{adopt}(i, st2stnum(0, 1, irrelevant)) = 0;
        end
    end
    for i = 1:choices
        Wrou{i} = (1-rou).*Rs{i} - rou.*Rh{i};
    end
    rouPrime = max(lowRou-epsilon/4, 0);
    [upperBoundPolicy reward cpuTime] = mdp_relative_value_iteration(P, Wrou, epsilon/8);
    if(reward > 0)
        lowRou = rou;
    else
        highRou = rou;
    end
end
disp('upperBoundReward: ')
disp(rou)
