function calNormalVector()
%�㷨���������ȵ�����ǰ�������������Բ׶�彻���ĺ�����������Եĵ���
%�ڴ��Եĵ����У������ȡ��������㷨��������x���򳬱꣬���ʾ����ǰ�����ߺ�
%����ǰ�������������㣬�����ж��ڵ���
%BUTTTTTTTTTTT
%����������ʧ��
[velo,~]=calBoxCross();
save('veloCross.mat','velo');
veloSortRow=sortrows(velo,1);
lengthVelo=length(velo);

%NearestPoint=veloSortRow(1:10,:);
OutTimes=zeros(lengthVelo,1);
for i=1:200
randNum1=round(lengthVelo*rand(1));
if randNum1==0
    randNum=1;
end
randNum2=round(lengthVelo*rand(1));
if randNum2==0
    randNum2=1;
end
randNum3=round(10*rand(1));
if randNum3==0
    randNum3=1;
end
if randNum1==randNum2 || randNum1==randNum3 ||randNum2==randNum3
    continue
end
p1=veloSortRow(randNum1,:);
p2=veloSortRow(randNum2,:);
p3=veloSortRow(randNum3,:);

a = ((p2(2)-p1(2))*(p3(3)-p1(3))-(p2(3)-p1(3))*(p3(2)-p1(2)));
b = ((p2(3)-p1(3))*(p3(1)-p1(1))-(p2(1)-p1(1))*(p3(3)-p1(3))); 
c = ((p2(1)-p1(1))*(p3(2)-p1(2))-(p2(2)-p1(2))*(p3(1)-p1(1))); 
r=sqrt(a^2+b^2+c^2);
c=c/r;
disp(c);
if c>0.2
    OutTimes([randNum1,randNum2,randNum3],1)=OutTimes([randNum1,randNum2,randNum3],1)+1;
end
end
veloInBox=velo;
veloOutBox=velo;
veloInBox(find(OutTimes>2),:)=[];
veloOutBox(find(OutTimes<3),:)=[];
scatter3(veloInBox(:,1),veloInBox(:,2),veloInBox(:,3),3,'filled');
hold on
scatter3(veloOutBox(:,1),veloOutBox(:,2),veloOutBox(:,3),3,'*');
end