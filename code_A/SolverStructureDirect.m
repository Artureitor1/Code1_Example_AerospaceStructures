classdef SolverStructureDirect < SolverStructure

    methods (Access = public)
           function obj = SolverStructureDirect(cParams)
                obj.inputData(cParams);
                obj.inputStructure(cParams);
           end
    end 
    
    methods (Access = protected)
        function solveSystem(obj)
                    KLL=obj.KG(obj.vL,obj.vL);
                    KLR=obj.KG(obj.vL,obj.vR);
                    KRL=obj.KG(obj.vR,obj.vL);
                    KRR=obj.KG(obj.vR,obj.vR);
                    FextL=obj.Fext(obj.vL,1);
                    FextR=obj.Fext(obj.vR,1);
    
                    uL=KLL\(FextL-KLR*obj.uR);
                    RR=KRR*obj.uR+KRL*uL-FextR;
                    
                    obj.u(obj.vL,1)=uL;
                    obj.u(obj.vR,1)=obj.uR;
                    
                    obj.R(obj.vL,1) = 0;
                    obj.R(obj.vR,1) = RR;
        end
    end
end
