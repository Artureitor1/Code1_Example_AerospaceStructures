classdef bucklingFailureComputer < handle
    properties (Access = private)
        
        x
        Tn
        mat
        Tmat
        sig
        nEl
        
    end
    properties (Access = public)
        FB
    end 
    methods (Access = public)
        function obj = bucklingFailureComputer(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.computeGeometry();
            obj.computeBuckling();
        end
    end
    methods  (Access = private)
        function init(obj,cParams)
            obj.x = cParams.x;
            obj.Tn = cParams.Tn;
            obj.mat = cParams.mat;
            obj.Tmat = cParams.Tmat;
            obj.sig = cParams.sig;
        end
        function computeGeometry(obj)
            s.x  = obj.x;
            s.Tn = obj.Tn;
            B = geometryComputer(s);
            B.compute();
            obj.nEl = B.nEl;
        end
        function computeBuckling(obj)
            obj.FB = zeros(obj.nEl,1);
            
            for e = 1:obj.nEl

                s.x = obj.x;
                s.Tn = obj.Tn;
                s.e = e;
                B = matrixRotationComputer(s);
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