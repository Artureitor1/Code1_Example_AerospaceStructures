classdef SolverStructure < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties (Access = public)
        % INPUT DATA
        F               %[N]
        Young           %[Pa]
        Area            %[m^2]
        thermal_coeff   %[K^-1]
        Inertia         %[m^4]

        %NODES
        x              
        Tn
        Fdata
        fixNod
        Tmat
        mat

        %Results

        eps
        sig
        FB
        u
        R

        
    end

    properties (Access = private)
        n_d             % Number of dimensions
        n_i             % Number of DOFs for each node
        n               % Total number of nodes
        n_dof           % Total number of degrees of freedom
        n_el            % Total number of elements
        n_nod           % Number of nodes for each element
        n_el_dof        % Number of DOFs for each element 

    end

        methods (Access = public)

            function obj = InputData(obj,F,Young,Area,thermal_coeff,Inertia)
                obj.F               = F;
                obj.Young           = Young;
                obj.Area            = Area;
                obj.thermal_coeff   = thermal_coeff;
                obj.Inertia         = Inertia;
            end
            function obj = InputStructure(obj,x,Tn,Fdata,fixNod,Tmat)
                if isempty(obj.F) == 1 || isempty(obj.Young) == 1 || isempty(obj.Area) == 1 ||isempty(obj.thermal_coeff) == 1 || isempty(obj.Inertia) == 1
                    warning("InputData is not filled in")
                else
                    Fdata(:,3)  = Fdata(:,3) * obj.F;
                    obj.x       = x;
                    obj.Tn      = Tn;
                    obj.Fdata   = Fdata;
                    obj.fixNod  = fixNod;
                    obj.Tmat    = Tmat;
                    obj.mat     = [obj.Young,obj.Area,obj.thermal_coeff,obj.Inertia];

                end
            end
            function obj = SolveStructure(obj)
                obj.Dimensions()
                
                Td = connectDOFs(obj.n_el,obj.n_nod,obj.n_i,obj.Tn);
                
                Kel = computeKelBar(obj.n_d,obj.n_el,obj.n_el_dof,obj.x,obj.Tn,obj.mat,obj.Tmat);
               
                
                KG = assemblyKG(obj.n_el,obj.n_el_dof,obj.n_dof,Td,Kel); 
                Fext = computeF(obj.n_i,obj.n_dof,obj.Fdata);
                
                [vL,vR,uR] = applyCond(obj.n_i,obj.n_dof,obj.fixNod);
                
                
                [obj.u,obj.R] = obj.SolveSystem(vL,vR,uR,KG,Fext); %This function is defined in the subclasses!!!!
               
                [obj.eps,obj.sig] = computeStrainStressBar(obj.n_d,obj.n_el,obj.u,Td,obj.x,obj.Tn,obj.mat,obj.Tmat);
                [obj.FB] = bucklingFailure(obj.mat,obj.Tmat,obj.x,obj.Tn,obj.n_el, obj.sig);
            end

            function obj = Represent(obj)
                plotDisp(obj.n_d,obj.n,obj.u,obj.x,obj.Tn,15);
                plotStrainStress(obj.n_d,obj.eps,obj.x,obj.Tn,{'Strain'});
                plotStrainStress(obj.n_d,obj.sig,obj.x,obj.Tn,{'Stress';'(Pa)'});
                plotBarStressDef(obj.x,obj.Tn,obj.u,obj.sig,15)
            end

        end
        methods (Access = private)

            function obj = Dimensions(obj)
                obj.n_d = size(obj.x,2);              
                obj.n_i = obj.n_d;                    
                obj.n = size(obj.x,1);                
                obj.n_dof = obj.n_i*obj.n;                
                obj.n_el = size(obj.Tn,1);            
                obj.n_nod = size(obj.Tn,2);           
                obj.n_el_dof = obj.n_i*obj.n_nod;         
            end
        end
end
