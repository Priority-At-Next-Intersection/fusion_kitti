function [velo,inBox]=calBoxCross(dir,cam1,cam2,pic1,pic2)
%计算两块点云的交集

box1=[120,155,220,285];
box2=[70,105,215,285];
[velo1,inBox1]=cutConeBy2DBox(box1,dir,cam1,pic1);
figure(1111)
scatter3(velo1(:,1),velo1(:,2),velo1(:,3),2,'filled');

[velo2,inBox2]=cutConeBy2DBoxe(box2,dir,cam1,pic1);
figure(2222)
scatter3(velo2(:,1),velo2(:,2),velo2(:,3),2,'filled');

inBox=double(inBox1&inBox2);

fid = fopen(sprintf('transfer/2011_09_26_drive_0005_sync/velodyne_points/data/%010d.bin',0),'rb');
velo = fread(fid,[4 inf],'single')';
idx = velo(:,1)<1;
velo(idx,:) = [];
idx2=find(inBox==0);
velo(idx2,:)=[];
idx3 = velo(:,3)<-1.5;
velo(idx3,:) = [];
idx4 = velo(:,4)==0;
velo(idx4,:) = [];
figure(3333)
scatter3(velo(:,1),velo(:,2),velo(:,3),2,'filled');
save(sprintf('veloCross%s%02d%02d%02d%02d.mat',dir,cam1,pic1,cam2,pic2),'velo');
end