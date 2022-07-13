function [k11,k12,k13,k22,k23,k33] = getCoef1(k)

% Combination of coefficient of k

k11   = k(:,1).*k(:,1);
k12   = k(:,1).*k(:,2);
k13   = k(:,1).*k(:,3);
k22   = k(:,2).*k(:,2);
k23   = k(:,2).*k(:,3);
k33   = k(:,3).*k(:,3);