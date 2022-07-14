function Td = connectDOFs(n_el,n_nod,n_i,Tn)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_el     Total number of elements
%                  n_nod    Number of nodes per element
%                  n_i      Number of DOFs per node
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering.

Td=zeros(n_el,n_nod*n_i);
for i=1:n_el
   for j=1:n_nod*n_i
       if (-1)^j==1
            Td(i,j)=2*Tn(i,j-j/2);
       end
       
       if (-1)^j==-1
            Td(i,j)=2*Tn(i,j-j*(j-1)/(2*j))-1;
       end
   end
end

end