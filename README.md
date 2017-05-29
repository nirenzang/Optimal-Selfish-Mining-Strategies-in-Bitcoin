# Optimal-Selfish-Mining-Strategies-in-Bitcoin
This is an implementation of the Financial Crypto 2016 paper "Optimal Selfish Mining Strategies in Bitcoin" by Ayelet Sapirshtein, Yonatan Sompolinsky, and Aviv Zohar. It computes the optimal selfish mining strategy and the maximum relative revenue of the selfish miner under a given set of parameters: *alphaPower*, selfish miner's mining power share, *gammaRatio*, the proportion of honest mining power that would work on the selfish chain during a tie. As the program can only compute block races up to a certain length, the relative revenue is approached by a pair of strict lower and upper bounds. Check [Yonatan Sompolinsky's homepage](http://www.cs.huji.ac.il/~yoni_sompo/) to download the paper for more details.

If you are implementing a selfish mining defense, the coder Ren Zhang would appreciate if you can compare the performance of your defense with my "Publish or Perish" defense and future defenses, whose code can be found in my github repository, and the papers should be reachable from [my google scholar page](https://scholar.google.be/citations?user=JB1uRvQAAAAJ&hl=en).

## Quick Start
If you only need the results:
1. Makesure you have matlab.
2. Download the [MDP toolbox for matlab](https://nl.mathworks.com/matlabcentral/fileexchange/25786-markov-decision-processes--mdp--toolbox), decompress it, put it in a directory such as '/users/yourname/Desktop/matlab/MDPtoolbox/fsroot/MDPtoolbox', copy the path.
3. Download the code, open Matlab, change the working dir to the dir of the code.
4. Open Init.m, paste your MDP toolbox path in the first line 
```
addpath('/users/yourname/Desktop/matlab/MDPtoolbox/fsroot/MDPtoolbox');
```
5. Modify *alphaPower* and *gammaRatio* in Init.m, make sure 0\<*alphaPower*<=0.49, 0<=*gammaRatio*<=1.
6. Run Init.m.

## Implementation

### Structure
* `Init.m`
The portal of the program. The parameters are defined here.
* `st2stnum.m`
A state in the paper is denoted as a tuple (a, h, fork). However in MDP, a state needs to be number. This function converts a state tuple into the relevant number. 
* `stnum2st.m` 
This function does the reverse conversion.
* `SolveStrategy.m`
The code that actually computes the optimal selfish mining strategies. The structure of the code follows the paper.

### Variants
Some simple modifications of the code allow us to compute the maximum relative revenue of some certain strategies, or within certain defenses.
* SM1 strategy outlined in the FC'13 paper "Majority is not Enough: Bitcoin Mining is Vulnerable" by Ittay Eyal and Emin Gun Sirer: force the attacker to **override** when h>1 and a-h=1, force the attacker to **adopt** when h>a.
* The uniform tie breaking defense in the FC'13 paper: fix *gammaRatio*=0.5, allow the attacker to **match** even if `fork~=relevant`.


## Citation
Sapirshtein A., Sompolinsky Y., Zohar A. (2017) Optimal Selfish Mining Strategies in Bitcoin. In: Grossklags J., Preneel B. (eds) Financial Cryptography and Data Security. FC 2016. Lecture Notes in Computer Science, vol 9603. Springer, Berlin, Heidelberg
```
@inproceedings{sapirshtein2015optimal,
  title={Optimal Selfish Mining Strategies in {B}itcoin},
  author={Sapirshtein, Ayelet and Sompolinsky, Yonatan and Zohar, Aviv},
  booktitle={International Conference on Financial Cryptography and Data Security},
  pages={515--532},
  year={2016},
  organization={Springer}
}
```
Chadès, I., Chapron, G., Cros, M. J., Garcia, F., & Sabbadin, R. (2014). MDPtoolbox: a multi‐platform toolbox to solve stochastic dynamic programming problems. Ecography, 37(9), 916-920.
```
@article{chades2014mdptoolbox,
  title={MDPtoolbox: a multi-platform toolbox to solve stochastic dynamic programming problems},
  author={Chad{\`e}s, Iadine and Chapron, Guillaume and Cros, Marie-Jos{\'e}e and Garcia, Fr{\'e}d{\'e}rick and Sabbadin, R{\'e}gis},
  journal={Ecography},
  volume={37},
  number={9},
  pages={916--920},
  year={2014},
  publisher={Wiley Online Library}
}
```
## Disclaimer
Any mistake in the code is due to the coder.

## License
This code is licensed under GNU GPLv3.
