function Re = calcCauchyPressure(G,B)
% Average Cauchy’s pressure based on Wang's model
% CP/B  = -1.620*G/B + 0.955
% ref: RSC Adv., 2016, 6, 44561.

Re = -1.620*G + 0.955*B;