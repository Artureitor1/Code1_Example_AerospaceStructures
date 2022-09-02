classdef SolverStructureDirect < SolverStructure

    methods (Access = public)
           function obj = SolverStructureDirect(cParams)
                obj.inputData(cParams);
                obj.inputStructure(cParams);
           end
    end 
    
    methods (Access = protected)

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
