function oA = roundN(A,N)
  
  %{
      oA = round(A,N) rounds to N digits:

      N > 0: round to N digits to the right of the decimal point.
      N = 0: round to the nearest integer.
      N < 0: round to N digits to the left of the decimal point.
  %}
  
  oA = round(A*10^N)/10^N;