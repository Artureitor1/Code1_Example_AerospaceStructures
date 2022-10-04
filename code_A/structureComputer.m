classdef structureComputer < handle

    properties (Access = private)
        x              
        Tn
        F              
        Young           
        Area            
        thermalCoeff   
        Inertia   
        method 
        Fdata
        fixNod
        Tmat
        mat
        
        
        R
        eps
        sig
         
    end
    properties (Access = public)
        Fext
        u
        KG
        FB
    end
   
    methods (Access = public)
        function obj = structureComputer(cParams)
            obj.init(cParams);
        end 
        function compute(obj)
            obj.computeEquations();
            obj.computeSolveSystem(); 
            obj.computeStrainStress();
            obj.computeBucklingFailure();
        end 
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.inputData(cParams);
            obj.inputStructure(cParams);
        end
        function inputData(obj,cParams)
            obj.F               = cParams.F;
            obj.Young           = cParams.Young;
            obj.Area            = cParams.Area;
            obj.thermalCoeff    = cParams.thermal_coeff;
            obj.Inertia         = cParams.Inertia;
            obj.method          =  cParams.method;
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
        function computeEquations(obj)
            s.x      = obj.x;
            s.Tn     = obj.Tn;
            s.Fdata  = obj.Fdata;
            s.fixNod = obj.fixNod;
            s.Tmat = obj.Tmat;
            s.mat = obj.mat;
            B = equationsComputer(s);
            B.compute()
            obj.KG = B.KG;
            obj.Fext = B.Fext;
        end 
        function computeSolveSystem(obj)
            s.KG = obj.KG;
            s.Fext = obj.Fext;
            s.method = obj.method;
            s.fixNod = obj.fixNod;
            B = solverSystemComputer(s);
            B.compute()
            obj.u = B.u;
            obj.R = B.R;
        end 
    
        function computeStrainStress(obj)
            s.Tn = obj.Tn;
            s.x = obj.x;
            s.mat = obj.mat;
            s.Tmat = obj.Tmat;
            s.u = obj.u;
            B = stressStrainComputer(s);
            B.compute();
            obj.sig = B.sig;
            obj.eps = B.eps;
        end
   
        function computeBucklingFailure(obj)
            s.x = obj.x;
            s.Tn = obj.Tn;
            s.mat = obj.mat;
            s.Tmat = obj.Tmat;
            s.sig = obj.sig;
            B = bucklingFailureComputer(s);
            B.compute();
            obj.FB = B.FB;
        end
    
%         function ploter(obj)
%             s.Tn = obj.Tn;
%             s.n =obj.n;
%             s.x =obj.x;
%             s.nd =obj.nd;
%             s.u =obj.u;
%             s.sig =obj.sig;
%             B = plotCompute(s);
%             B.compute();
%         end
    end
  
end

