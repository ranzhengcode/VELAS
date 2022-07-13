function flag = isOctave()

%Determine if the current compilation environment is Octave or MATLAB

env = ver;
if sum(strcmp({env.Name},'Octave'))
    flag = true;
else
    flag = false;
end