classdef SolverStructure < handle

    properties (Access = protected)
     
        F              
        Young           
        Area            
        thermalCoeff   
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

        nd             
        ni             
        n               
        nDof           
        nEl            
        nNod           
        nElDof    
        
        
        Kel
        
        vR
        vL  

        
    end
    properties (Access = public)
        KG
        Fext
        u
        Td
        
        KLL
        KRL
        KRR
        uR
        KLR
        FextL
        FextR
        
        
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
            obj.elementStifnessMatrizComputation()
            obj.assemblyKG(); 
            obj.globalSystemEquations()
            obj.solveSystem(); %This function is defined in the subclasses!!!!
            obj.computeStrainStressBar();
            obj.bucklingFailure();
        end
        function represent(obj)
            obj.plot();
        end
        
        function inputData(obj,cParams)
            obj.F               = cParams.F;
            obj.Young           = cParams.Young;
            obj.Area            = cParams.Area;
            obj.thermalCoeff    = cParams.thermal_coeff;
            obj.Inertia         = cParams.Inertia;
        end
        
        function inputStructure(obj,cParams)
            obj.Fdata       = cParams.Fdata;
            obj.Fdata(:,3)  = cParams.Fdata(:,3) * obj.F;
            obj.x           = cParams.x;
            obj.Tn          = cParams.Tn;
            obj.fixNod      = cParams.fixNod;
            obj.Tmat        = cParams.Tmat;
            obj.mat         = [obj.Young,obj.Area,obj.thermalCoeff,obj.Inertia];
        end
        
        function dimensions(obj)


            s.x      = obj.x;
            s.Tn     = obj.Tn;
            B        = geometry(s);
            B.compute();
            obj.nd   = B.nd;
            obj.ni   = B.nd;
            obj.n    = B.n;
            obj.nDof = B.nDof;
            obj.nEl  = B.nEl;
            obj.nNod   = B.nNod;
            obj.nElDof = B.nElDof;

        end
    
        function elementStifnessMatrizComputation(obj)
            s.nEl    = obj.nEl;
            s.nNod   = obj.nNod;
            s.ni     = obj.ni;
            s.Tn     = obj.Tn;
            s.x      = obj.x;
            s.Tmat   = obj.Tmat;
            s.mat    = obj.mat;
            s.nElDof = obj.nElDof;
            B        = StifnessMatriz(s);
            B.compute();
            obj.Td   = B.Td;
            obj.Kel  = B.Kel; 
        end

        function assemblyKG(obj)

            s.nDof    = obj.nDof;
            s.nEl     = obj.nEl;
            s.Td      = obj.Td;
            s.Kel     = obj.Kel;

            B         = assemblyGloblaStiffnessMatrix(s);
            B.compute();
            obj.KG    = B.KG;

        end
        function globalSystemEquations(obj)
            s.Fdata  = obj.Fdata;
            s.nDof   = obj.nDof;
            s.fixNod = obj.fixNod;
            s.KG     = obj.KG;
            B = globalSystemEquationsAsembler(s);
            B.compute()

            obj.uR = B.uR;
            obj.vR = B.vR;
            obj.vL = B.vL;

            obj.KLL = B.KLL;
            obj.KLR = B.KLR;
            obj.KRL = B.KRL;
            obj.KRR = B.KRR;
            obj.FextR = B.FextR;
            obj.FextL = B.FextL;
            obj.Fext = B.Fext;
            
        end
        function solveSystem(obj)
                   error('SolveSystem function not implemented. This class is not for use. Try SolverStructureDirect class or SolverStructureIterative class')
        end
    
        function computeStrainStressBar(obj)
            s.nEl = obj.nEl;
            s.Tn = obj.Tn;
            s.Td = obj.Td;
            s.x = obj.x;
            s.mat = obj.mat;
            s.Tmat = obj.Tmat;
            s.u = obj.u;
            B = StressStrain(s);
            B.compute();
            obj.sig = B.sig;
            obj.eps = B.eps;
        end
   
        function bucklingFailure(obj)
            s.nEl = obj.nEl;
            s.x = obj.x;
            s.Tn = obj.Tn;
            s.mat = obj.mat;
            s.Tmat = obj.Tmat;
            B = bucklingFailureCompute(s)
            B.compute()
            obj.FB;
        end
    
        function plot(obj)
            s.Tn = obj.Tn;
            s.n =obj.n;
            s.x =obj.x;
            s.nd =obj.nd;
            s.u =obj.u;
            s.sig =obj.sig;
            B = plot(s);
            B.compute();
        end
    end
  
end



