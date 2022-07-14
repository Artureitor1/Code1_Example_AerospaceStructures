function Fext = computeF(n_i,n_dof,Fdata)
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
    if Fdata(i,2) == 2 % even case
        Fext(Fdata(i,1)*2,1)=Fdata(i,3);
    else
       Fext((Fdata(i,1)*2)-1,1)=Fdata(i,3); %odd case
    end
end


end