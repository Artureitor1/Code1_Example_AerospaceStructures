classdef assemblyGloblaStiffnessMatrix < handle
    
    properties (Access = private)
        nDof
        nEl
        Td
        Kel
    end
    properties (Access = public)
        KG
    end

    methods (Access = public)
        function obj = assemblyGloblaStiffnessMatrix(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.assemblyKG()
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.nDof = cParams.nDof;
            obj.nEl  = cParams.nEl;
            obj.Td   = cParams.Td;
            obj.Kel  = cParams.Kel;        
        end
        function assemblyKG(obj)
            obj.KG=zeros(obj.nDof,obj.nDof);
            for e=1:obj.nEl
                for i=1:2*2
                    I=obj.Td(e,i);
                    for j=1:2*2
                        J=obj.Td(e,j);
                        obj.KG(I,J)=obj.KG(I,J)+obj.Kel(i,j,e);
                    end
                end
            end
        end
    end
end