function box=transferBox(boxOrigin)
%���ѧϰ�õ��İ�Χ�и�ʽת��Ϊ��д����ĸ�ʽ
box=[];
box(1)=boxOrigin(1)-boxOrigin(3)/2;
box(2)=boxOrigin(1)+boxOrigin(3)/2;
box(3)=boxOrigin(2)-boxOrigin(4)/2;
box(4)=boxOrigin(2)+boxOrigin(4)/2;
end