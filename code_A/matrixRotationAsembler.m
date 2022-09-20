classdef matrixRotationAsembler < handle
    properties (Access = private)
        x
        Tn
        e
        
    end
    properties (Access = public)

        le
        Re
    end

    methods (Access = public)
        function obj = matrixRotationAsembler(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.matrixRotation()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.x = cParams.x;
            obj.Tn = cParams.Tn;
            obj.e = cParams.e;
                
        end 
        function matrixRotation(obj)
            x1e = obj.x(obj.Tn(obj.e,1),1);
            y1e = obj.x(obj.Tn(obj.e,1),2);
            x2e = obj.x(obj.Tn(obj.e,2),1);
            y2e = obj.x(obj.Tn(obj.e,2),2);
            obj.le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
            se=(y2e-y1e)/obj.le;
            ce=(x2e-x1e)/obj.le;
            obj.Re=[ce se 0 0
                -se ce 0 0
                0 0 ce se
                0 0 -se ce];
        end
    end
end