classdef SolverStructure < handle

    properties (Access = protected)
     
        F              
        Young           
        Area            
        thermal_coeff   
        Inertia         

        x              
        Tn
        Fdata
        fixNod
        Tmat
        mat


        eps
        sig
        FB
        R

        n_d             
        n_i             
        n               
        n_dof           
        n_el            
        n_nod           
        n_el_dof        

        
    end
    properties (Access = public)
        KG
        Fext
        u
    end
   
    methods (Access = public)
        function solver(obj,cParams)
            obj.init(cParams);
        end
        function Grahps(obj)
            obj.Represent()
        end  
    end
    methods (Access = protected)

        function init(obj,cParams)
            obj.InputData(cParams);
            obj.InputStructure(cParams);
            obj.SolveStructure();
        end
        
        function SolveStructure(obj)
            obj.Dimensions()
            Td = obj.connectDOFs(obj.n_el,obj.n_nod,obj.n_i,obj.Tn);
            Kel = obj.computeKelBar(obj.n_d,obj.n_el,obj.n_el_dof,obj.x,obj.Tn,obj.mat,obj.Tmat);
            obj.KG = obj.assemblyKG(obj.n_el,obj.n_el_dof,obj.n_dof,Td,Kel); 
            obj.Fext = obj.computeF(obj.n_i,obj.n_dof,obj.Fdata);
            [vL,vR,uR] = obj.applyCond(obj.n_i,obj.n_dof,obj.fixNod);
            [obj.u,obj.R] = obj.SolveSystem(vL,vR,uR,obj.KG,obj.Fext); %This function is defined in the subclasses!!!!
            [obj.eps,obj.sig] = obj.computeStrainStressBar(obj.n_d,obj.n_el,obj.u,Td,obj.x,obj.Tn,obj.mat,obj.Tmat);
            [obj.FB] = obj.bucklingFailure(obj.mat,obj.Tmat,obj.x,obj.Tn,obj.n_el, obj.sig);
        end
        function Represent(obj)
            obj.plotDisp(obj.n_d,obj.n,obj.u,obj.x,obj.Tn,15);
            obj.plotStrainStress(obj.n_d,obj.eps,obj.x,obj.Tn,{'Strain'});
            obj.plotStrainStress(obj.n_d,obj.sig,obj.x,obj.Tn,{'Stress';'(Pa)'});
            obj.plotBarStressDef(obj.x,obj.Tn,obj.u,obj.sig,15)
        end
        function InputData(obj,cParams)
            obj.F               = cParams.F;
            obj.Young           = cParams.Young;
            obj.Area            = cParams.Area;
            obj.thermal_coeff   = cParams.thermal_coeff;
            obj.Inertia         = cParams.Inertia;
        end
        function InputStructure(obj,cParams)
            obj.Fdata       = cParams.Fdata;
            obj.Fdata(:,3)  = cParams.Fdata(:,3) * obj.F;
            obj.x           = cParams.x;
            obj.Tn          = cParams.Tn;
            obj.fixNod      = cParams.fixNod;
            obj.Tmat        = cParams.Tmat;
            obj.mat         = [obj.Young,obj.Area,obj.thermal_coeff,obj.Inertia];
        end
        function Dimensions(obj)
            obj.n_d = size(obj.x,2);              
            obj.n_i = obj.n_d;                    
            obj.n = size(obj.x,1);                
            obj.n_dof = obj.n_i*obj.n;                
            obj.n_el = size(obj.Tn,1);            
            obj.n_nod = size(obj.Tn,2);           
            obj.n_el_dof = obj.n_i*obj.n_nod; 
        end
    end
    methods (Access = protected, Static)
        function Td = connectDOFs(n_el,n_nod,n_i,Tn)
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
                
        function Kel = computeKelBar(n_d,n_el,n_el_dof,x,Tn,mat,Tmat)
        
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
        
        function KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel)
                    KG=zeros(n_dof,n_dof);
                            for e=1:n_el
                                for i=1:2*2 
                                    I=Td(e,i);
                                    for j=1:2*2
                                        J=Td(e,j);
                                        KG(I,J)=KG(I,J)+Kel(i,j,e);
                                    end
                                end
                            end
                end
                
        function Fext = computeF(n_i,n_dof,Fdata)
                    Fext=zeros(n_dof,1); 
                            for i=1:length(Fdata)
                                if Fdata(i,2) == 2 % even case
                                    Fext(Fdata(i,1)*2,1)=Fdata(i,3);
                                else
                                   Fext((Fdata(i,1)*2)-1,1)=Fdata(i,3); %odd case
                                end
                            end
                end
        
        function [vL,vR,uR] = applyCond(n_i,n_dof,fixNod)
                    uR = zeros(size(fixNod,1),1);
                    vR = zeros(size(fixNod,1),1);
                    v = linspace(1,16,16);
                        for i = 1:size(uR,1)
                            if (fixNod(i,2))== 2
                                vR(i,1) = 2*fixNod(i,1);
                                uR(i,1) = fixNod(i,3);
                            else
                                vR(i,1) = 2*(fixNod(i,1))-1;
                                uR(i,1) = fixNod(i,3);
                            end
                        end 
                    vL = transpose (setdiff(v,vR));
                end
        
        function [u,R] = SolveSystem(vL,vR,uR,KG,Fext)
                   error('SolveSystem function not implemented. This class is not for use. Try SolverStructureDirect class or SolverStructureIterative class')
                end
        
        function [eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat)
                            eps=zeros(n_el,1);
                            sig=zeros(n_el,1);
                            
                            for e=1:n_el
                                ue=zeros(2*2,1);
                                x1e=x(Tn(e,1),1);
                                y1e=x(Tn(e,1),2);
                                x2e=x(Tn(e,2),1);
                                y2e=x(Tn(e,2),2);
                                le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
                                se=(y2e-y1e)/le;
                                ce=(x2e-x1e)/le;
                                Re=[ce se 0 0 
                                    -se ce 0 0 
                                    0 0 ce se
                                    0 0 -se ce];
                                for i=1:2*2
                                    I=Td(e,i);
                                    ue(i,1)=u(I);
                                end
                                uep=Re*ue;
                                eps(e,1)=(1/le)*[-1 0 1 0]*uep;
                                sig(e,1)=mat(Tmat(e),1)*eps(e,1);
                            end
                end
        
        function [FB] = bucklingFailure(mat,Tmat,x,Tn,n_el, sig)
                   FB = zeros(n_el,1); 
                        for e = 1:n_el
                    
                            x1e = x(Tn(e,1),1);
                            y1e = x(Tn(e,1),2);
                            x2e = x(Tn(e,2),1);
                            y2e = x(Tn(e,2),2);
                            L = sqrt((x2e-x1e)^2+(y2e-y1e)^2);
                    
                            E = mat(Tmat(e),1);
                            I = mat(Tmat(e),4);
                            A = mat(Tmat(e),2);
                    
                            sigPan = ((pi^2)*E*I)/((L^2)*A); 
                            
                            if sig(e)<-1
                                if abs(sig(e)) > sigPan
                                    FB(e) = 1; 
                                end
                            end
                        end
                end
    
        function plotStrainStress(n_d,s,x,Tn,title_name)

                for i = 1:n_d
                    X0{i} = reshape(x(Tn,i),size(Tn))';
                end
                S = repmat(s',size(Tn,2),1);
                
                figure('color','w');
                hold on;       
                box on;        
                axis equal;    
                colormap jet;  
                
                xlabel('x (m)')
                ylabel('y (m)')
                title(title_name{1});
                
                patch(X0{:},S,'edgecolor','flat','linewidth',2);
                
                caxis([min(S(:)),max(S(:))]);
                cbar = colorbar;
                set(cbar,'Ticks',linspace(min(S(:)),max(S(:)),5));
                title(cbar,title_name);
        end
    
        function plotDisp(n_d,n,u,x,Tn,fact)

                U = reshape(u,n_d,n);
                for i = 1:n_d
                    X0{i} = reshape(x(Tn,i),size(Tn))';
                    X{i} = X0{i}+fact*reshape(U(i,Tn),size(Tn))';
                end
                D = reshape(sqrt(sum(U(:,Tn).^2,1)),size(Tn))';
                
                figure('color','w');
                hold on;       
                box on;        
                axis equal;    
                colormap jet;  
                
                xlabel('x (m)')
                ylabel('y (m)')
                title('Displacement');
                
                patch(X0{:},zeros(size(D)),'edgecolor',[0.5,0.5,0.5],'linewidth',2);
                
                patch(X{:},D,'edgecolor','interp','linewidth',2);
                
                caxis([min(D(:)),max(D(:))]);
                cbar = colorbar;              
                set(cbar,'Ticks',linspace(min(D(:)),max(D(:)),5))
                end
    
        function plotBarStressDef(x,Tn,u,sig,scale)
                n_d = size(x,2);
                X = x(:,1);
                Y = x(:,2);
                ux = u(1:n_d:end);
                uy = u(2:n_d:end);
                
                figure('color','w');
                hold on
                box on
                axis equal;
                colormap jet;
                
                plot(X(Tn)',Y(Tn)','-k','linewidth',0.5);
                
                patch(X(Tn)'+scale*ux(Tn)',Y(Tn)'+scale*uy(Tn)',[sig';sig'],'edgecolor','flat','linewidth',2);
                
                xlabel('x (m)')
                ylabel('y (m)')
                
                title(sprintf('Deformed structure (scale = %g)',scale));
                
                caxis([min(sig(:)),max(sig(:))]);
                cbar = colorbar;
                set(cbar,'Ticks',linspace(min(sig(:)),max(sig(:)),5));
                title(cbar,{'Stress';'(Pa)'});
                
        end
    end   
end

