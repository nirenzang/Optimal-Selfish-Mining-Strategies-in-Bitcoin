# Optimal-Selfish-Mining-Strategies-in-Bitcoin
This is an implementation of the Financial Crypto 2016 paper "Optimal Selfish Mining Strategies in Bitcoin" by Ayelet Sapirshtein, Yonatan Sompolinsky, and Aviv Zohar. It computes the optimal selfish mining strategy and the maximum relative revenue of the selfish miner under a give set of parameters: selfish miner's mining power share, the proportion of honest mining power that would work on the selfish chain during a tie. As the program can only compute block races up to a certain length, the relative revenue is approached by a pair of strict lower and upper bounds. Check [Yonatan Sompolinsky's homepage](http://www.cs.huji.ac.il/~yoni_sompo/) to download the paper for more details.

If you are implementing a selfish mining defense, the coder Ren Zhang would appreciate if you can compare the performance of your defense with my "Publish or Perish" defense and future defenses, whose code can be found in my github repository, and the paper(s) should be reachable from [my google scholar page](https://scholar.google.be/citations?user=JB1uRvQAAAAJ&hl=en).

## Quick Start
If you only need the results:
1. Makesure you have matlab.
2. Download the [MDP toolbox for matlab](https://nl.mathworks.com/matlabcentral/fileexchange/25786-markov-decision-processes--mdp--toolbox), decompress it, put it in a directory such as '/users/yourname/Desktop/matlab/MDPtoolbox/fsroot/MDPtoolbox'.
3. Download the code, open Matlab, change the working dir to the dir of the code.
3. Open Init.m, paste your MDP toolbox dir in the first line addpath('/users/yourname/Desktop/matlab/MDPtoolbox/fsroot/MDPtoolbox');
4. Modify the alphaPower (>0, <=0.49)and gammaRatio (>=0, <=1) in the file.
5. Run Init.m.


## Implementation

## Citation
Sapirshtein A., Sompolinsky Y., Zohar A. (2017) Optimal Selfish Mining Strategies in Bitcoin. In: Grossklags J., Preneel B. (eds) Financial Cryptography and Data Security. FC 2016. Lecture Notes in Computer Science, vol 9603. Springer, Berlin, Heidelberg

@inproceedings{sapirshtein2015optimal,
  title={Optimal Selfish Mining Strategies in {B}itcoin},
  author={Sapirshtein, Ayelet and Sompolinsky, Yonatan and Zohar, Aviv},
  booktitle={International Conference on Financial Cryptography and Data Security},
  pages={515--532},
  year={2016},
  organization={Springer}
}

Chadès, I., Chapron, G., Cros, M. J., Garcia, F., & Sabbadin, R. (2014). MDPtoolbox: a multi‐platform toolbox to solve stochastic dynamic programming problems. Ecography, 37(9), 916-920.

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

## Disclaimer
Any mistake in the code is due to the coder.
