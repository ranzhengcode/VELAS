function k = set2zeros(k,teps)
len = size(k,2);
for t = 1:len
    k(abs(k(:,t))<teps,t) = 0;
end
