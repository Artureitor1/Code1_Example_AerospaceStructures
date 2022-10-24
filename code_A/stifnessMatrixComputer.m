classdef StifnessMatrixComputer < handle
    properties (Access = private)
        geometry
        structure
        elementalStifnessMatrix
    end
    properties (Access = public)
        stifnessMatrix
    end

    methods (Access = public)
        function obj = StifnessMatrixComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeElementalStiffnessMatrices()
            obj.computeGlobalStifnessMatrix()
        end
    end

    methods (Access = private)
        function init(obj,cParams)   
            obj.geometry  = cParams.geometry;
            obj.structure = cParams.structure;
        end
        function computeElementalStiffnessMatrices(obj)
            s.geometry =  obj.geometry;
            s.structure = obj.structure;
            B = ElementalStiffnessMatricesComputer(s);
            B.compute();
            obj.elementalStifnessMatrix = B.elementalStifnessMatrix;
        end 
        function computeGlobalStifnessMatrix(obj)
            stifnessMatrix=zeros(obj.geometry.totalDegresFredom,obj.geometry.totalDegresFredom);
            degressConectivity = obj.geometry.degressConectivity;
            elementalStifnessMatrix = obj.elementalStifnessMatrix;
            
            for element=1:obj.geometry.numberElement
                for rowPositionLocalStifnessMatrix=1:4
                    rowPositionGlobalStifnessMatrix= degressConectivity(element,rowPositionLocalStifnessMatrix);
                    for columPositionLocalStifnessMatrix=1:4
                        columPositionGlobalStifnessMatrix=degressConectivity(element,columPositionLocalStifnessMatrix);
                        stifnessMatrix(rowPositionGlobalStifnessMatrix,columPositionGlobalStifnessMatrix)=stifnessMatrix(rowPositionGlobalStifnessMatrix,columPositionGlobalStifnessMatrix)+elementalStifnessMatrix(rowPositionLocalStifnessMatrix,columPositionLocalStifnessMatrix,element);
                    end
                end
            end
            obj.stifnessMatrix = stifnessMatrix;
        end
    end
end