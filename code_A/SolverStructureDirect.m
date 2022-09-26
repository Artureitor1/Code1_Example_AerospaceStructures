classdef SolverStructureDirect < handle
    properties (Access = private)
           KLL
           KRL
           KLR
           KRR

           FextL
           FextR

           uR
           vL
           vR
    end 
    properties (Access = public)
        u
        R
    end
    methods (Access = public)
        function obj = SolverStructureDirect(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.solveSystem();
        end
    end
    
    methods (Access = protected)
        function init(obj,cParams)
            obj.KLL =cParams.KLL;
            obj.KRL =cParams.KRL;
            obj.KLR =cParams.KLR;
            obj.KRR =cParams.KRR;

            obj.FextL =cParams.FextL;
            obj.FextR =cParams.FextR;

            obj.uR =cParams.uR;
            obj.vL =cParams.vL;
            obj.vR =cParams.vR;
        end

        function solveSystem(obj)
                    
                    uL=(obj.KLL)\(obj.FextL-obj.KLR*obj.uR);
                    RR=obj.KRR*obj.uR+obj.KRL*uL-obj.FextR;
                    
                    obj.u(obj.vL,1)=uL;
                    obj.u(obj.vR,1)=obj.uR;
                    
                    obj.R(obj.vL,1) = 0;
                    obj.R(obj.vR,1) = RR;
        end
    end
end
