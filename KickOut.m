function KickOut(veloFile)
%���ݾ���Э����ɶ�ģ��߳�Զ�ĵ㡣
if nargin<1
    veloFile='veloCross.mat';
end
content=load(veloFile);
velo=content.velo(:,1:3);
veloMean=mean(velo);
veloDis=velo-repmat(veloMean,[length(velo),1]);
dev=mean(mean(veloDis.*veloDis));%��������е�ķ���
threshold1=1;
devPoint=mean(veloDis.*veloDis,2);%ÿ���㵽���ĵ�ƽ������
IsInbox=devPoint<threshold1*dev;
veloOut=velo;
veloIn=velo;
veloIn(IsInbox==0,:)=[];
veloOut(IsInbox==1,:)=[];
scatter3(veloIn(:,1),veloIn(:,2),veloIn(:,3),5,'filled');
hold on
scatter3(veloOut(:,1),veloOut(:,2),veloOut(:,3),5,'*');

end