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
        
        Td
        Kel
        
        vR
        vL  

        KLL

        KRL
        KRR
        uR
        KLR
        FextL
        FextR
        
    end
    properties (Access = public)
        KG
        Fext
        u
        
        
    end
   
    methods (Access = public)
        function solver(obj)
           solveStructure(obj)
        end
        function grahp(obj)
            obj.represent()
        end  
    end
    methods (Access = protected)
        
        function solveStructure(obj)
            obj.dimensions();
            obj.connectDOFs();
            obj.computeKelBar();
            obj.assemblyKG(); 
            obj.computeF();
            obj.applyCond();
            obj.constructSystem()
            obj.solveSystem(); %This function is defined in the subclasses!!!!
            obj.computeStrainStressBar();
            obj.bucklingFailure();
        end
        function represent(obj)
            obj.plotDisp(obj.n_d,obj.n,obj.u,obj.x,obj.Tn,15);
            obj.plotStrainStress(obj.n_d,obj.eps,obj.x,obj.Tn,{'Strain'});
            obj.plotStrainStress(obj.n_d,obj.sig,obj.x,obj.Tn,{'Stress';'(Pa)'});
            obj.plotBarStressDef(obj.x,obj.Tn,obj.u,obj.sig,15)
        end
        
        function inputData(obj,cParams)
            obj.F               = cParams.F;
            obj.Young           = cParams.Young;
            obj.Area            = cParams.Area;
            obj.thermal_coeff   = cParams.thermal_coeff;
            obj.Inertia         = cParams.Inertia;
        end
        
        function inputStructure(obj,cParams)
            obj.Fdata       = cParams.Fdata;
            obj.Fdata(:,3)  = cParams.Fdata(:,3) * obj.F;
            obj.x           = cParams.x;
            obj.Tn          = cParams.Tn;
            obj.fixNod      = cParams.fixNod;
            obj.Tmat        = cParams.Tmat;
            obj.mat         = [obj.Young,obj.Area,obj.thermal_coeff,obj.Inertia];
        end
        
        function dimensions(obj)
            obj.n_d = size(obj.x,2);              
            obj.n_i = obj.n_d;                    
            obj.n = size(obj.x,1);                
            obj.n_dof = obj.n_i*obj.n;                
            obj.n_el = size(obj.Tn,1);            
            obj.n_nod = size(obj.Tn,2);           
            obj.n_el_dof = obj.n_i*obj.n_nod; 
        end
    
        function connectDOFs (obj)
                        obj.Td=zeros(obj.n_el,obj.n_nod*obj.n_i);
                        for i=1:obj.n_el
                           for j=1:obj.n_nod*obj.n_i
                               if (-1)^j==1
                                    obj.Td(i,j)=2*obj.Tn(i,j-j/2);
                               end
                               
                               if (-1)^j==-1
                                    obj.Td(i,j)=2*obj.Tn(i,j-j*(j-1)/(2*j))-1;
                               end
                           end
                        end                        
        end

        function computeKelBar(obj)
        
                        obj.Kel=zeros(obj.n_el_dof,obj.n_el_dof,obj.n_el);
                            for e=1:obj.n_el
                                x1e=obj.x(obj.Tn(e,1),1);
                                y1e=obj.x(obj.Tn(e,1),2);
                                x2e=obj.x(obj.Tn(e,2),1);
                                y2e=obj.x(obj.Tn(e,2),2);
                                le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
                                se=(y2e-y1e)/le;
                                ce=(x2e-x1e)/le;
                                
                                
                                Ke=(obj.mat(obj.Tmat(e),2))*(obj.mat(obj.Tmat(e),1))/le * [
                                    ce^2 ce*se -(ce)^2 -ce*se
                                    ce*se se^2 -ce*se -(se)^2
                                    -(ce)^2 -ce*se ce^2 ce*se
                                    -ce*se -(se)^2 ce*se se^2
                                ];
                                
                                
                                obj.Kel(:,:,e) = Ke(:,:);
                                
                            end
                end
        
        function assemblyKG(obj)
                    obj.KG=zeros(obj.n_dof,obj.n_dof);
                            for e=1:obj.n_el
                                for i=1:2*2 
                                    I=obj.Td(e,i);
                                    for j=1:2*2
                                        J=obj.Td(e,j);
                                        obj.KG(I,J)=obj.KG(I,J)+obj.Kel(i,j,e);
                                    end
                                end
                            end
         end
        
        function computeF(obj)
                    obj.Fext=zeros(obj.n_dof,1); 
                            for i=1:length(obj.Fdata)
                                if obj.Fdata(i,2) == 2 % even case
                                    obj.Fext(obj.Fdata(i,1)*2,1)=obj.Fdata(i,3);
                                else
                                   obj.Fext((obj.Fdata(i,1)*2)-1,1)=obj.Fdata(i,3); %odd case
                                end
                            end
         end
    
        function applyCond(obj)
                    obj.uR = zeros(size(obj.fixNod,1),1);
                    obj.vR = zeros(size(obj.fixNod,1),1);
                    v = linspace(1,16,16);
                        for i = 1:size(obj.uR,1)
                            if (obj.fixNod(i,2))== 2
                                obj.vR(i,1) = 2*obj.fixNod(i,1);
                                obj.uR(i,1) = obj.fixNod(i,3);
                            else
                                obj.vR(i,1) = 2*(obj.fixNod(i,1))-1;
                                obj.uR(i,1) = obj.fixNod(i,3);
                            end
                        end 
                    obj.vL = transpose (setdiff(v,obj.vR));
        end
        
        function constructSystem(obj)
                    obj.KLL=obj.KG(obj.vL,obj.vL);
                    obj.KLR=obj.KG(obj.vL,obj.vR);
                    obj.KRL=obj.KG(obj.vR,obj.vL);
                    obj.KRR=obj.KG(obj.vR,obj.vR);
                    obj.FextL=obj.Fext(obj.vL,1);
                    obj.FextR=obj.Fext(obj.vR,1);
   
        end
    
        function solveSystem(obj)
                   error('SolveSystem function not implemented. This class is not for use. Try SolverStructureDirect class or SolverStructureIterative class')
        end
    
        function computeStrainStressBar(obj)
                            obj.eps=zeros(obj.n_el,1);
                            obj.sig=zeros(obj.n_el,1);
                            
                            for e=1:obj.n_el
                                ue=zeros(2*2,1);
                                x1e=obj.x(obj.Tn(e,1),1);
                                y1e=obj.x(obj.Tn(e,1),2);
                                x2e=obj.x(obj.Tn(e,2),1);
                                y2e=obj.x(obj.Tn(e,2),2);
                                le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
                                se=(y2e-y1e)/le;
                                ce=(x2e-x1e)/le;
                                Re=[ce se 0 0 
                                    -se ce 0 0 
                                    0 0 ce se
                                    0 0 -se ce];
                                for i=1:2*2
                                    I=obj.Td(e,i);
                                    ue(i,1)=obj.u(I);
                                end
                                uep=Re*ue;
                                obj.eps(e,1)=(1/le)*[-1 0 1 0]*uep;
                                obj.sig(e,1)=obj.mat(obj.Tmat(e),1)*obj.eps(e,1);
                            end
                end
   
        function bucklingFailure(obj)
                   obj.FB = zeros(obj.n_el,1); 
                        for e = 1:obj.n_el
                    
                            x1e = obj.x(obj.Tn(e,1),1);
                            y1e = obj.x(obj.Tn(e,1),2);
                            x2e = obj.x(obj.Tn(e,2),1);
                            y2e = obj.x(obj.Tn(e,2),2);
                            L = sqrt((x2e-x1e)^2+(y2e-y1e)^2);
                    
                            E = obj.mat(obj.Tmat(e),1);
                            I = obj.mat(obj.Tmat(e),4);
                            A = obj.mat(obj.Tmat(e),2);
                    
                            sigPan = ((pi^2)*E*I)/((L^2)*A); 
                            
                            if obj.sig(e)<-1
                                if abs(obj.sig(e)) > sigPan
                                    obj.FB(e) = 1; 
                                end
                            end
                        end
                end
    
        function plotStrainStress(obj)

                for i = 1:obj.n_d
                    X0{i} = reshape(obj.x(obj.Tn,i),size(Tobj.n))';
                end
                S = repmat(obj.s',size(obj.Tn,2),1);
                
                figure('color','w');
                hold on;       
                box on;        
                axis equal;    
                colormap jet;  
                
                xlabel('x (m)')
                ylabel('y (m)')
                title(obj.title_name{1});
                
                patch(X0{:},S,'edgecolor','flat','linewidth',2);
                
                caxis([min(S(:)),max(S(:))]);
                cbar = colorbar;
                set(cbar,'Ticks',linspace(min(S(:)),max(S(:)),5));
                title(cbar,obj.title_name);
        end
    
        function plotDisp(obj)

                U = reshape(obj.u,obj.n_d,obj.n);
                for i = 1:obj.n_d
                    X0{i} = reshape(obj.x(obj.Tn,i),size(obj.Tn))';
                    X{i} = X0{i}+obj.fact*reshape(U(i,obj.Tn),size(obj.Tn))';
                end
                D = reshape(sqrt(sum(U(:,obj.Tn).^2,1)),size(obj.Tn))';
                
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
    
        function plotBarStressDef(obj)
                n_d = size(obj.x,2);
                X = obj.x(:,1);
                Y = obj.x(:,2);
                ux = obj.u(1:n_d:end);
                uy = obj.u(2:n_d:end);
                
                figure('color','w');
                hold on
                box on
                axis equal;
                colormap jet;
                
                plot(X(obj.Tn)',Y(obj.Tn)','-k','linewidth',0.5);
                
                patch(X(obj.Tn)'+obj.scale*ux(obj.Tn)',Y(obj.Tn)'+obj.scale*uy(obj.Tn)',[obj.sig';obj.sig'],'edgecolor','flat','linewidth',2);
                
                xlabel('x (m)')
                ylabel('y (m)')
                
                title(sprintf('Deformed structure (scale = %g)',obj.scale));
                
                caxis([min(obj.sig(:)),max(obj.sig(:))]);
                cbar = colorbar;
                set(cbar,'Ticks',linspace(min(obj.sig(:)),max(obj.sig(:)),5));
                title(cbar,{'Stress';'(Pa)'});
                
        end
    end
  
end



