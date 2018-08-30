function ttt=isInBox(img_temp,box)
length=img_temp;
x=img_temp(1);
y=img_temp(2);
x_min=box(1);
x_max=box(2);
y_min=box(3);
y_max=box(4);
if x>x_min && x<x_max && y>y_min && y<y_max
    ttt=1;
else
    ttt=0;
end 

end