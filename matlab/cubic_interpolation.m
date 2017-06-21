


x = -3 + 6 * rand(50, 1);
y = -3 + 6 * rand(50, 1);
v = zeros(50, 1);

[xq,yq] = meshgrid(-3:0.1:3);

z4 = griddata(x,y,v,xq,yq,'cubic');
figure
plot3(x,y,v,'mo')
hold on
mesh(xq,yq,z4)
title('Cubic')
legend('Sample Points','Interpolated Surface','Location','NorthWest')