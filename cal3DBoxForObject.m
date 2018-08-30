function [velo,inBox]=cal3DBoxForObject(box,cam,frame)
disp('======= KITTI DevKit Demo =======');
%��Ӧ����Բ�λ���·�ƣ����ݰ�Χ�о�ȷ���ڳ�·�������еĵ�
%��ȡ�������ݺ���������


calib = loadCalibrationCamToCam('data\2011_09_26\calib_cam_to_cam.txt');
Tr_velo_to_cam = loadCalibrationRigid('data\2011_09_26\calib_velo_to_cam.txt');
fid = fopen(sprintf('data/2011_09_26_drive_0005_sync/velodyne_points/data/%010d.bin',frame),'rb');
%data\2011_09_26_drive_0005_sync\velodyne_points\data
velo = fread(fid,[4 inf],'single')';
fclose(fid);
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam; 

img = imread(sprintf('data/2011_09_26_drive_0005_sync/image_%02d/data/%010d.png',2,0));

idx = velo(:,1)<0;
velo(idx,:) = [];
figure(1)
scatter3(velo(:,1),velo(:,2),velo(:,3),2,'filled');

cloud_size=length(velo);
x_min=box(1);
y_min=box(3);
y_max=box(4);
inBox=[];
innerVelo=[];%��Ű�Χ��������һ���ֵ���

t=1;
for i=1:cloud_size
    img_temp=project(velo(i,1:3),P_velo_to_img);
    x=img_temp(1);
    y=img_temp(2);
    if x>x_min*3/4+x_max/4 && x<x_max*3/4+x_min/4 && y>y_min*3/4+y_max/4 && y<y_max*3/4+y_min/4
        inBox(i)=1;
        innerVelo(t,:)=velo(i,:);
        t=t+1;
    elseif x>x_min && x<x_max && y>y_min && y<y_max
        inBox(i)=1;
    else
        velo(i,:)=[0,0,0,0];
        inBox(i)=0;
    end 
end
% figure(6)
% scatter3(innerVelo(:,1),innerVelo(:,2),innerVelo(:,3),2,'filled');
velo(find(inBox==0),:)=[];
%��������Ķ�ά��Χ����ʾ����
figure(2)
imshow(img); hold on;
cols = jet;
velo_img = project(velo(:,1:3),P_velo_to_img);
for i=1:size(velo_img,1)
  col_idx = round(64*5/velo(i,1));
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end
% figure(3)
% scatter3(velo(:,1),velo(:,2),velo(:,3),1,'filled');

%���ݸ߶ȴ����Ƴ������
velo(velo(:,3)<-1.7,:)=[];
figure(7)
scatter3(velo(:,1),velo(:,2),velo(:,3),2,'filled');
%�����Ƴ�Զ����
%velo(velo(:,1)>18,:)=[];

%����box���ĵ����ȷ�Χ
depth_range=max(innerVelo(:,1))-min(innerVelo(:,1));
threshold1=0.5;
threshold2=0.05;

%��������û���ڵ�
max_depth=max(innerVelo(:,1))+depth_range/2;
min_depth=min(innerVelo(:,1))-depth_range/2;
isObject=[];
for jj=1:length(velo);
    if velo(jj,1)>max_depth+threshold2 || velo(jj,1)<min_depth-threshold2
        velo(jj,:)=[0,0,0,0];
        isObject(jj)=0;
    else
        isObject(jj)=1;
    end
end
velo(isObject==0,:)=[];
figure(4)
scatter3(velo(:,1),velo(:,2),velo(:,3),2,'filled');

% figure(5)
% imshow(img); hold on;
cols = jet;
velo_img = project(velo(:,1:3),P_velo_to_img);
for i=1:size(velo_img,1)
  col_idx = round(64*5/velo(i,1));
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end
end