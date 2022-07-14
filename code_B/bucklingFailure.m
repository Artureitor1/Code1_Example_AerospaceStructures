function [FB] = bucklingFailure(mat,Tmat,x,Tn,n_el, sig)
    %  Tn(e,a) = global nodal number associated to node a of element e
    %  x(a,j) = coordinate of node a in the dimension j
    %  Total number of elements
    %  Tmat(e) = Row in mat corresponding to the material associated to element e 
    
    % Material data
    %  mat(m,1) = Young modulus of material m
    %  mat(m,2) = Section area of material m
        
   
    FB = zeros(n_el,1); %Bars that have failed
    for e = 1:n_el

        x1e = x(Tn(e,1),1);
        y1e = x(Tn(e,1),2);
        x2e = x(Tn(e,2),1);
        y2e = x(Tn(e,2),2);
        L = sqrt((x2e-x1e)^2+(y2e-y1e)^2);

        E = mat(Tmat(e),1);
        I = mat(Tmat(e),4);
        A = mat(Tmat(e),2);

        sigPan = ((pi^2)*E*I)/((L^2)*A); % Formula of buckling failure tension
        
        if sig(e) > sigPan
            FB(e) = 1; %If the bars fails because buckling effect, 1 will appear
        end
    end
end