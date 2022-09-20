classdef geometry < handle
    properties (Access = private)
        x
        Tn
    end
    properties (Access = public)
        nd   
        ni  
        n  
        nDof 
        nEl  
        nNod   
        nElDof 
    end

    methods (Access = public)
        function obj = geometry(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeAdimensionalize()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.x      = cParams.x;
            obj.Tn     = cParams.Tn;
        end

        function computeAdimensionalize(obj);
            obj.nd = size(obj.x,2);
            obj.ni = obj.nd;
            obj.n = size(obj.x,1);
            obj.nDof = obj.ni*obj.n;
            obj.nEl = size(obj.Tn,1);
            obj.nNod = size(obj.Tn,2);
            obj.nElDof = obj.ni*obj.nNod;
        end
    end

end