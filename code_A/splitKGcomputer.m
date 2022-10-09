classdef SplitKGcomputer < handle
    properties (Access = private)
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
        function obj = SplitKGcomputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.split();
        end
    end
    methods (Access = private)
        function init (obj,cParams)
            obj.Fext = cParams.Fext;
            obj.KG = cParams.KG;
            obj.vL = cParams.vL;
            obj.vR = cParams.vR;
        end
        function split(obj)
            obj.KLL=obj.KG(obj.vL,obj.vL);
            obj.KLR=obj.KG(obj.vL,obj.vR);
            obj.KRL=obj.KG(obj.vR,obj.vL);
            obj.KRR=obj.KG(obj.vR,obj.vR);
            obj.FextL=obj.Fext(obj.vL,1);
            obj.FextR=obj.Fext(obj.vR,1);
        end 
    end 
end