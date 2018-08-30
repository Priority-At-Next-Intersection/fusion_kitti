function [flag,p] = LineLine2Point(n1,p1,n2,p2)
%---------------------------------------------------------
%   determine the relation between two straight lines and
%   calulate the intersection point if they are intersecting
%
%   input:
%   n1  direction vector of line one
%   p1  any point in line one
%   n2  direction vector of line two
%   p2  any point in line two
%
%   output:
%   flag the relation of the two line
%        flag = 0   the two line are on different plane 
%        flag = 1   the two line are on the same  plane and they are parallel
%        flag = 2   the two line are on the same  plane and they are intersecting
%   p    the point shared by the two intersecting line
%
%   author: Lai Zhenzhou from Harbin Institute of Technology
%   email:  laizhenzhou@126.com
%   date:   2014.1.17
%   reference: http://wenku.baidu.com/link?url=5V7FCC_RIg0cUR8lydTOGmvZXuHtI8S0bZ63-24CLIxwewglLzQ9Cq8MrV4l5uHqNBzJOQQ7IyjN0iCFPAUEoRLsJK57Kb-2aPjQ_rOgPDC
%----------------------------------------------------------
if(~(isvector(n1) && isvector(p1) && isvector(n2) && isvector(p2)))
   error('LineLine2Point: the parameter is not vector');  
end
   
    
if((length(n1)~=3)||(length(p1)~=3)||(length(n2)~=3)||(length(p2)~=3))
   error('LineLine2Point: the parameter is not 3d vector');  
end 
 
A = [p2(1)-p1(1)  p2(2)-p1(2) p2(3)-p1(3);
         n1(1)         n1(2)      n1(3)  ;
         n2(1)         n2(2)      n2(3)  ;];
    
if(det(A)~=0)
  flag = 0;
else
    if(rank(A(2:3,:))<2)
        flag = 1;
    else
        flag = 2;
    end
end
 
if(flag == 2)
    
   B = rref(A(2:3,:));  
   
   index(1) = find(B(1,:),1,'first');
   index(2) = find(B(2,:),1,'first');
   
   for i=1:3
       if(i~=index(1) && i~=index(2))
           index(3) = i;
       end
   end
 
   Y(1,1) = -p1(index(1)) + p2(index(1));
   Y(2,1) = -p1(index(2)) + p2(index(2)); 
   
   D = [n1(index(1)) -n2(index(1));n1(index(2)) -n2(index(2))];
   
   t = inv(D)*Y;
   
   p(1) = p1(1) + n1(1)*t(1);
   p(2) = p1(2) + n1(2)*t(1);
   p(3) = p1(3) + n1(3)*t(1);
   
    
else
    p = [];
end
 
end
 
 
%-----------for test------------------
 
% [flag p] = LineLine2Point([1 0 0],[0 0 0],[0 1 0],[1 1 0])
% [flag p] = LineLine2Point([1 1 0],[0 0 0],[0 1 0],[1 1 0])
% [flag p] = LineLine2Point([1 1 -1],[0 0 1],[0 1 0],[1 1 0])
% [flag p] = LineLine2Point([1 1 -1],[0 0 1],[1 1 -1],[1 1 0])
% [flag p] = LineLine2Point([1 1 1],[0 0 0],[2 0 0],[2 1 1])
%  [flag p] = LineLine2Point([ 0 -42050  -21025],[-100 0 0],[0 0 145],[0 0 0])
