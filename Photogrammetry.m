function [flag,p]=Photogrammetry(pic1_path,pic2_path,pic1_pos,pic2_pos)
pic1=imread(pic1_path);
pic2=imread(pic2_path);
f1=0.05;
f2=0.05;
imshow(pic1);
hold on;
%��һ�����������ⷽλԪ�أ���ô���㵽���ʵ���������ת����rotate1,rotate2
calib = loadCalibrationCamToCam('data\2011_09_26\calib_cam_to_cam.txt');
%��һ�����
rotate = eye(4);
rotate(1:3,1:3) = calib.R_rect{3};
pic_size=calib.S_rect{3};
height1=pic_size(1);
width1=pic_size(2);
rotate(1:3,4)=calib.T{3};
cam1_pos=calib.T{3}';
rotate(4,4)=1;
rotate1=rotate;
%�ڶ������
rotate = eye(4);
rotate(1:3,1:3) = calib.R_rect{4};
pic_size=calib.S_rect{4};
height2=pic_size(1);
width2=pic_size(2);
rotate(1:3,4)=calib.T{4};
cam2_pos=calib.T{4}';
rotate(4,4)=1;
rotate2=rotate;

%�ڶ�����������������ⷽλԪ�ؼ�������ڿռ�ֱ������ϵ�е�����
%������Ĳ������Ϊ��x�ҡ�y�¡�zǰ�����ɴ˼�����������������ϵ�е�λ��
pic1_x=pic1_pos(1);
pic1_y=pic1_pos(2);
pic2_x=pic2_pos(1);
pic2_y=pic2_pos(2);
%�ȸ������غͽ�����������������ϵ�е�����
pt1_pic_pos=[pic1_y-width1/2,pic1_x-height1/2,f1,1];
pt2_pic_pos=[pic2_y-width2/2,pic2_x-height2/2,f2,1];
%��ת�������ڴ������ϵ�е�����
pt1_real_pos=rotate1*pt1_pic_pos';
pt2_real_pos=rotate2*pt2_pic_pos';

%�����������������꣬�Ա�֤�ĵ㹲�ߣ����������
%�������ĵ㹲���������ʽ
temp1=cam1_pos-cam2_pos;
temp2=cam1_pos-pt1_real_pos(1:3)';
temp3=cross(temp1,temp2);
temp4=pt2_real_pos(1:3)'-cam2_pos;
temp4(3)=-(temp3(1)*temp4(1)+temp3(2)+temp4(2))/temp3(3);
n2=temp4;

%���Ĳ�����������һ�ߡ������ཻ���ʵ������
n1=pt1_real_pos(1:3)'-cam1_pos;
[flag,p] = LineLine2Point(n1,cam1_pos,n2,cam2_pos);

%���岽�����飺����project��������ʵ�ʵ㷴ͶӰ��ͼƬ�ϣ����Ƿ��غ�
% load calibration
Tr_velo_to_cam = loadCalibrationRigid('data\2011_09_26\calib_velo_to_cam.txt');
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{3};
P_velo_to_img = calib.P_rect{3}*R_cam_to_rect*Tr_velo_to_cam;
point_img = project(p,P_velo_to_img);
plot(point_img(1),point_img(2),'o','LineWidth',4,'MarkerSize',1);
end