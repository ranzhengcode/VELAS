% 
function [nx,ny] = head2Tail(X,Y)

% Realize the end to end connection of data points

[m,n] = size(X);
validateattributes(Y,{'numeric'},{'size',[m,n]});
if m < n
    nx = [X,X(1)];
    ny = [Y,Y(1)];
else
    nx = [X;X(1)];
    ny = [Y;Y(1)];    
end