function k = set2ones(k,teps)
k((1+k(:,1))<teps,1) = -1;
k((1-k(:,1))<teps,1) = 1;
k((1+k(:,2))<teps,2) = -1;
k((1-k(:,2))<teps,2) = 1;
k((1+k(:,3))<teps,3) = -1;
k((1-k(:,3))<teps,3) = 1;