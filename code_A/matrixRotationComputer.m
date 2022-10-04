classdef matrixRotationComputer < handle
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
        function obj = matrixRotationComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeMatrixRotation()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.x = cParams.x;
            obj.Tn = cParams.Tn;
            obj.e = cParams.e;
                
        end 
        function computeMatrixRotation(obj)
            s.x = obj.x;
            s.Tn =obj.Tn;
            s.e = obj.e;
            B = lenghtComputer(s);
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