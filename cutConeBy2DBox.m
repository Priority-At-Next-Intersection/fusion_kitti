function velo=cutConeBy2DBox(box,dir,cam,frame)
base_dir =sprintf('./%s/2011_09_26_drive_0005_sync',dir);
calib_dir =sprintf('./%s/2011_09_26',dir);

% load calibration
calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt'));

% compute projection matrix velodyne->image plane
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;

% load and display image
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
fig = figure('Position',[20 100 size(img,2) size(img,1)]); axes('Position',[0 0 1 1]);
figure(1)
imshow(img); hold on;

% load velodyne points
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');
velo = fread(fid,[4 inf],'single')';
velo = velo(1:end,:); % remove every 5th point for display speed
fclose(fid);

% remove all points behind image plane (approximation
idx = velo(:,1)<1;
velo(idx,:) = [];

cloud_size=length(velo);
x_min=box(1);
x_max=box(2);
y_min=box(3);
y_max=box(4);

inBox=[];
for i=1:cloud_size
    img_temp=project(velo(i,1:3),P_velo_to_img);
    x=img_temp(1);
    y=img_temp(2);
    if x>x_min && x<x_max && y>y_min && y<y_max
        inBox(i)=1;
    else
        velo(i,:)=[0,0,0,0];
        inBox(i)=0;
    end 
end
velo(find(inBox==0),:)=[];
velo_img = project(velo(:,1:3),P_velo_to_img);

%inBox(find(isInBox(project(velo(:,1:3),P_velo_to_img))==1))=1;
%inBox(find(isInBox(project(velo(:,1:3),P_velo_to_img))==0))=0;



%plot points
cols = jet;
for i=1:size(velo_img,1)
  col_idx = round(64*5/velo(i,1));
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end
figure(2)
scatter3(velo(:,1),velo(:,2),velo(:,3),1,'filled');

end