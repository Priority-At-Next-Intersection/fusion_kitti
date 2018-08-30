function box=transferBox(boxOrigin)
%深度学习得到的包围盒格式转化为我写代码的格式
box=[];
box(1)=boxOrigin(1)-boxOrigin(3)/2;
box(2)=boxOrigin(1)+boxOrigin(3)/2;
box(3)=boxOrigin(2)-boxOrigin(4)/2;
box(4)=boxOrigin(2)+boxOrigin(4)/2;
end