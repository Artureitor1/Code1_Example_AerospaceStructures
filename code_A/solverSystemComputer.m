classdef solverSystemComputer < handle 

    properties (Access = public)
        u
        R
    end
    properties (Access = private)
        KG
        method
        fixNod   

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
            B = solverMethodComputer(s);
            B.compute()
            obj.u = B.B;
            obj.R = B.D;
        end
    end 
end