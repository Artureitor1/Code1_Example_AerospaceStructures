classdef matrixRotationCompute < handle
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
        function obj = matrixRotationCompute(cParams)
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
            s.x = obj.x;
            s.Tn =obj.Tn;
            s.e = obj.e;
            B = lenghtCompute(s);
            B.compute;
            se = B.se;
            ce = B.ce;
            obj.le = B.le;

            obj.Re=[ce se 0 0
                -se ce 0 0
                0 0 ce se
                0 0 -se ce];
        end
    end
end