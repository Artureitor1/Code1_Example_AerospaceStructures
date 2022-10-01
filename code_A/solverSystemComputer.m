classdef solverSystemComputer < handle 

    properties (Access = public)
        u
        R

        KLL
        KLR
        KRL
        KRR
        FextR
        FextL

        Fext

        vL
        vR
        uR
    end
    properties (Access = private)


        KG
        
        method
        nDof
        fixNod   
    end

    methods (Access = public)
        function obj = solverSystemComputer(cParams)
           obj.init(cParams);
        end

        function compute(obj)
           obj.computeSplit();
           obj.solveSystem();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.KG = cParams.KG;
            obj.Fext = cParams.Fext;
            obj.method = cParams.method;
            obj.nDof = cParams.nDof;
            obj.fixNod = cParams.fixNod;
        end
        function computeSplit(obj)
            s.fixNod = obj.fixNod;
            s.KG     = obj.KG;
            s.Fext = obj.Fext;
            B = splitComputer(s);
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
        end
        function solveSystem(obj)
            s.method = obj.method;
            s.KLL = obj.KLL;
            s.KRL = obj.KRL;
            s.KLR = obj.KLR ;
            s.KRR = obj.KRR;
            s.FextL = obj.FextL;
            s.FextR = obj.FextR;
            s.uR = obj.uR ;
            s.vL = obj.vL;
            s.vR = obj.vR;
            B = solverMethodCompute(s);
            B.compute()
            obj.u = B.u;
            obj.R = B.R;
        end
    end 
end