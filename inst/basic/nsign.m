function re = nsign(A,B)
if B>=0
    re = abs(A);
else
    re = -abs(A);
end