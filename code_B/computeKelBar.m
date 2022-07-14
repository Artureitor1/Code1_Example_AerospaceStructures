function Kel = computeKelBar(n_d,n_el,n_el_dof,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------

Kel=zeros(n_el_dof,n_el_dof,n_el);
    for e=1:n_el
        x1e=x(Tn(e,1),1);
        y1e=x(Tn(e,1),2);
        x2e=x(Tn(e,2),1);
        y2e=x(Tn(e,2),2);
        le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
        se=(y2e-y1e)/le;
        ce=(x2e-x1e)/le;
        
        
        Ke=(mat(Tmat(e),2))*(mat(Tmat(e),1))/le * [
            ce^2 ce*se -(ce)^2 -ce*se
            ce*se se^2 -ce*se -(se)^2
            -(ce)^2 -ce*se ce^2 ce*se
            -ce*se -(se)^2 ce*se se^2
        ];
        
        
        Kel(:,:,e) = Ke(:,:);
        
    end

end