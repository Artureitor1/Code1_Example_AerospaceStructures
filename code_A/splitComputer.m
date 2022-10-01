classdef splitComputer < handle

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
        function obj = splitComputer(cParams)
            obj.init(cParams)
        end
        function compute(obj)           
            obj.conditionAsembler()
            obj.systemAsembler()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.fixNod = cParams.fixNod;
            obj.KG = cParams.KG;
            obj.Fext = cParams.Fext;
            
        end 
        function conditionAsembler(obj)
            s.fixNod = obj.fixNod;
            B = conditionComputer(s);
            B.compute()
            obj.uR = B.uR;
            obj.vR = B.vR;
            obj.vL = B.vL;

        end
        function systemAsembler(obj)
            s.KG    = obj.KG;
            s.vL    = obj.vL;
            s.vR    = obj.vR;
            s.Fext  = obj.Fext;
            B = splitKGcomputer(s);
            B.compute()
            obj.KLL = B.KLL;
            obj.KLR = B.KLR;
            obj.KRL = B.KRL;
            obj.KRR = B.KRR;
            obj.FextR = B.FextR;
            obj.FextL = B.FextL;

        end
    end
end