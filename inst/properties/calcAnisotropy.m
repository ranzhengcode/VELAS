function Ax = calcAnisotropy(X)

%{
    Ax = Xstd/Xmean, if the sign of Xmax and Xmin is same.
    Ax = ∞         , If the sign of Xmax and Xmin is opposite.
    
%}

if max(X(:))*min(X(:)) >= 0
   % remove zero elements
   if any(X(:)==0)
      X(X==0) = []; 
   end
   Ax = std(X(:))/mean(X(:));
else
   Ax = inf;
end