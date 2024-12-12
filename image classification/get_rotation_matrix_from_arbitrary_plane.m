%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [rotatin_matrix_from_arbitrary_plane,new_direction_from_arbitrary_plane]=get_rotation_matrix_from_arbitrary_plane(plane,reference_plane)
% get a rotation matrix, reference plane , reference direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [rotatin_matrix_from_arbitrary_plane,new_direction_from_arbitrary_plane]=get_rotation_matrix_from_arbitrary_plane(plane,reference_plane)

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
rotaxis=cross(reference_plane,hkldash);

 if k==0 && h==0
     rotaxis=rotaxis;
 else
     rotaxis=rotaxis/norm(rotaxis);
 end

 % so we have define and axis for rotation
%rotaxis=rotaxis.';
% now to get cosine and sine of rotation
sth=norm(cross(reference_plane,hkldash));

cth=norm(dot(reference_plane,hkldash));
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
rotatin_matrix_from_arbitrary_plane=rotmat;%.';%transpose because we are transforming coords not rotating in same coords



[rotation_matrix_from_001, dir_from_001]=get_rotation_matrix(reference_plane);
% for i=1:3
%     temp=0;
%     tempb=0;
%     for j=1:3
%                     temp=rotmat(i,j)*dir_from_001(j);
%                     tempb=temp+tempb;
%     end
%     new_direction_from_arbitrary_plane(i)=tempb;
% end
new_direction_from_arbitrary_plane=dir_from_001*rotmat.';


