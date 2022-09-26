classdef globalSystemEquationsAsembly < handle

    properties (Access = public)
        Fext

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
        Fdata
        nDof
        fixNod
        KG
    end 

    methods (Access = public)
        function obj = globalSystemEquationsAsembly(cParams)
            obj.init(cParams)
        end
        function compute(obj)           
            obj.forceAsembler()
            obj.conditionAsembler()
            obj.systemAsembler()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.Fdata = cParams.Fdata;
            obj.nDof  = cParams.nDof;
            obj.fixNod = cParams.fixNod;
            obj.KG = cParams.KG;
            
        end 
        function forceAsembler(obj)
            s.nDof = obj.nDof;
            s.Fdata = obj.Fdata;
            B = forceAsembler(s);
            B.compute()
            obj.Fext = B.Fext;
        end 
        function conditionAsembler(obj)
            s.fixNod = obj.fixNod;
            B = conditionAsembler(s);
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
            B = systemAsembler(s);
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