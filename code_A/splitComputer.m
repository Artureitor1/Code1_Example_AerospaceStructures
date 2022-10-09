classdef SplitComputer < handle

    properties (Access = public)
        uR
        vR
        vL

        KLL
        KLR
        KRL
        KRR
        FextR
        FextL
    end
    properties (Access = private)
        
        Fext
        nDof
        fixNod
        KG
    end 

    methods (Access = public)
        function obj = SplitComputer(cParams)
            obj.init(cParams)
        end
        function compute(obj)           
            obj.SplitConditions()
            obj.splitKG()
            obj.splitFext()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.fixNod = cParams.fixNod;
            obj.KG = cParams.KG;
            obj.Fext = cParams.Fext;
            
        end 
        function SplitConditions(obj)
            s.fixNod = obj.fixNod;
            B = SplitConditionComputer(s);
            B.compute()
            obj.uR = B.uR;
            obj.vR = B.vR;
            obj.vL = B.vL;

        end
        function splitKG(obj)
            s.KG    = obj.KG;
            s.vL    = obj.vL;
            s.vR    = obj.vR;
            s.Fext  = obj.Fext;
            B = SplitKGcomputer(s);
            B.compute()
            obj.KLL = B.KLL;
            obj.KLR = B.KLR;
            obj.KRL = B.KRL;
            obj.KRR = B.KRR;
            obj.FextR = B.FextR;
            obj.FextL = B.FextL;
        end
        function splitFext(obj)
            s.KG    = obj.KG;
            s.vL    = obj.vL;
            s.vR    = obj.vR;
            s.Fext  = obj.Fext;
            B = SplitFextComputer(s);
            B.compute()
            obj.FextR = B.FextR;
            obj.FextL = B.FextL;
        end
    end
end