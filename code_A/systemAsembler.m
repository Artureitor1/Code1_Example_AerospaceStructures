classdef systemAsembler < handle

    properties (Access = public)
        KG
        vL
        vR
        Fext
        
    end
    properties (Access = public)
        KLL
        KLR
        KRL
        KRR
        FextR
        FextL
    end 

    methods (Access = public)
        function obj = systemAsembler(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.constructSystem()
        end
    end
    methods  (Access = protected)
        function init(obj,cParams)
            obj.KG   = cParams.KG;
            obj.vL   = cParams.vL;
            obj.vR   = cParams.vR;
            obj.Fext = cParams.Fext;
        end

        function constructSystem(obj)
            obj.KLL=obj.KG(obj.vL,obj.vL);
            obj.KLR=obj.KG(obj.vL,obj.vR);
            obj.KRL=obj.KG(obj.vR,obj.vL);
            obj.KRR=obj.KG(obj.vR,obj.vR);
            obj.FextL=obj.Fext(obj.vL,1);
            obj.FextR=obj.Fext(obj.vR,1);
        end
    end
end