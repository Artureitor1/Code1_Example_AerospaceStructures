function Fext = computeF(n_i,n_dof,Fdata,Tmat,mat,deltaT,x,Tn,n_el)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i         Number of DOFs per node
%                  n_dof       Total number of DOFs
%   - Fdata  External nodal forces [Nforces x 3]
%            Fdata(k,1) - Node at which the force is applied
%            Fdata(k,2) - DOF (direction) at which the force acts
%            Fdata(k,3) - Force magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fext  Global force vector [n_dof x 1]
%            Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each force is applied.

Fext=zeros(n_dof,1); 
for i=1:length(Fdata)
    if Fdata(i,2) == 2 %Caso par
        Fext(Fdata(i,1)*2,1)=Fdata(i,3);
    else
       Fext((Fdata(i,1)*2)-1,1)=Fdata(i,3);
    end
end

for e=1:n_el
    x1e=x(Tn(e,1),1);
    y1e=x(Tn(e,1),2);
    x2e=x(Tn(e,2),1);
    y2e=x(Tn(e,2),2);
    le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
    se=(y2e-y1e)/le;
    ce=(x2e-x1e)/le;
    
    FdeltaT= mat(Tmat(e),2)*mat(Tmat(e),1)*mat(Tmat(e),3)*deltaT; % [A*E*epsilon]
    Fcos=FdeltaT*ce;
    Fsin=FdeltaT*se;

    Fext(Tn(e,2)*2-1,1)=Fext(Tn(e,2)*2-1,1)+Fcos;
    Fext(Tn(e,2)*2,1)=Fext(Tn(e,2)*2,1)+Fsin;
    Fext(Tn(e,1)*2-1,1)=Fext(Tn(e,1)*2-1,1)-Fcos;
    Fext(Tn(e,1)*2,1)=Fext(Tn(e,1)*2,1)-Fsin;
end

end