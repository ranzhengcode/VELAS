function xy = calcIntersectCurve(p0, v, exx, eyy, ezz)

%{
        Author: Mehmet OZTURK  - KTU Electrical and Electronics Engineering, Trabzon/Turkey

        Modified by Zheng Ran
        
        Intersection points of an arbitrary surface S with an arbitrary plane P.

        Input:
             p0               - a reference point through which the "center" of plane P must pass
             v                - normal vector of the plane P
             exx, eyy and ezz - the surface S coordinates

        Output:
             xy - Intersection points of an arbitrary surface S with an arbitrary plane P
%}

v  = v./norm(v); % normalize the normal vector

mx = v(1); my=v(2); mz=v(3);

% elevation and azimuth angels of the normal of the plane
phi  = acos(mz./sqrt(mx.*mx + my.*my + mz.*mz)); % 0 <= phi <= 180
teta = atan2(my,mx);

st=sin(teta); ct=cos(teta);
sp=sin(phi); cp=cos(phi);

T=[st -ct 0; ct*cp st*cp -sp; ct*sp st*sp cp];

% transform surface such that the z axis of the surface coincides with plane normal
exx=exx-p0(1); eyy=eyy-p0(2); ezz=ezz-p0(3);
nexx = exx*T(1,1) + eyy*T(1,2) + ezz*T(1,3);
neyy = exx*T(2,1) + eyy*T(2,2) + ezz*T(2,3);
nezz = exx*T(3,1) + eyy*T(3,2) + ezz*T(3,3);

% Find the intersections
[M,c] = contour3(nexx,neyy,nezz,[0 0]);
set(c,'Visible','off');
limit = size(M,2);
i     = 1;
ncx   = []; ncy=[];
while(i < limit)
  npoints = M(2,i);
  nexti = i+npoints+1;
  ncx = [ncx M(1,i+1:i+npoints)];
  ncy = [ncy M(2,i+1:i+npoints)];
  i = nexti;
end

xy = [ncx',ncy'];
% Set less than 1e-10 to 0
xy(abs(xy)<1e-10) = 0;

% Delete the point with 0 at the end
tmpxy = any(xy,2);
ind   = ~logical(flipud(cumsum(flipud(tmpxy)~=0)));

% output
xy(ind,:) = [];


