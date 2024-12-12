%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [rotatin_matrix,new_direction]=get_rotation_matrix(plane)
% get a rotation matrix, reference plane (001), reference direction [100]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [rotatin_matrix,new_direction]=get_rotation_matrix(plane)

h=plane(1);
k=plane(2);
l=plane(3);

 hkl=[h k l];
 if l==0 && k==0
    hkldash=hkl;%/norm(hkl);
 else
 hkldash=hkl/norm(hkl);
 end

%hkldash=hkldash.';
rotaxis=cross([0 0 1],hkldash);

 if k==0 && h==0
     rotaxis=rotaxis;
 else
     rotaxis=rotaxis/norm(rotaxis);
 end

 % so we have define and axis for rotation
%rotaxis=rotaxis.';
% now to get cosine and sine of rotation
sth=norm(cross([0 0 1],hkldash));

cth=norm(dot([0 0 1],hkldash));
% this gives rotation angle
% these give the angles we that we need to rotate. so we now have
% the axis we need to rotate about and the angle about this axis.

rotmat=zeros(3,3);
vth=1-cth;
ux=rotaxis(1);
uy=rotaxis(2);
uz=rotaxis(3);

rotmat(1,1)=(ux*ux*vth)+cth;
rotmat(2,1)=(uy*ux*vth)+(uz*sth);
rotmat(3,1)=(uz*ux*vth)-(uy*sth);
rotmat(1,2)=(uy*ux*vth)-(uz*sth);
rotmat(2,2)=(uy*uy*vth)+cth;
rotmat(3,2)=(uz*uy*vth)+(ux*sth);
rotmat(1,3)=(ux*uz*vth)+(uy*sth);
rotmat(2,3)=(uz*uy*vth)-(ux*sth);
rotmat(3,3)=(uz*uz*vth)+cth;
rotatin_matrix=rotmat;%.';%transpose because we are transforming coords not rotating in same coords



dir=[1 0 0];
% for i=1:3
%     temp=0;
%     tempb=0;
%     for j=1:3
%                     temp=rotmat(i,j)*dir(j);
%                     tempb=temp+tempb;
%     end
%     new_direction(i)=tempb;
% end
new_direction=dir*rotmat.';



