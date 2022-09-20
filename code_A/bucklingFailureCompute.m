classdef bucklingFailureCompute < handle
    properties (Access = private)
        nEl
        x
        Tn
        mat
        Tmat
    end
    properties (Access = public)
        FB
    end 
    methods (Access = public)
        function obj = bucklingFailureCompute(obj,cParams)
            obj.init()
        end

        function compute(obj)
            obj.buckling();
        end
    end
    methods  (Access = private)
        function init(obj)
        end
        function buckling(obj)
            obj.FB = zeros(obj.nEl,1);
            for e = 1:obj.nEl

                s.x = obj.x;
                s.Tn = obj.Tn;
                s.e = e;
                B = matrixRotationAsembler(s);
                B.compute()
                L   = B.le;

                E = obj.mat(obj.Tmat(e),1);
                I = obj.mat(obj.Tmat(e),4);
                A = obj.mat(obj.Tmat(e),2);

                sigPan = ((pi^2)*E*I)/((L^2)*A);

                if obj.sig(e)<-1
                    if abs(obj.sig(e)) > sigPan
                        obj.FB(e) = 1;
                    end
                end
            end
        end

    end 
end