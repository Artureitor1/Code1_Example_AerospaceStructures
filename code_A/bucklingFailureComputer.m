classdef BucklingFailureComputer < handle
    properties (Access = private)

        coordNodes
        nodalConectivity
        mat
        Tmat
        stress
        numberElement

    end
    properties (Access = public)
        bucklingFailure
    end
    methods (Access = public)
        function obj = BucklingFailureComputer(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.computeBuckling();
        end
    end
    methods  (Access = private)
        function init(obj,cParams)
            obj.coordNodes = cParams.coordNodes;
            obj.nodalConectivity = cParams.nodalConectivity;
            obj.mat = cParams.mat;
            obj.Tmat = cParams.Tmat;
            obj.stress = cParams.stress;
            obj.numberElement = cParams.numberElement;
        end
        function computeBuckling(obj)

            for element = 1:obj.numberElement

                [elementLenght] = obj.computeElementGeometry(obj.coordNodes,obj.nodalConectivity,element);

                elementElasticModul = obj.mat(obj.Tmat(element),1);
                elementInercia = obj.mat(obj.Tmat(element),4);
                elementArea = obj.mat(obj.Tmat(element),2);
                criticalBuclingStress = ((pi^2)*elementElasticModul*elementInercia)/((elementLenght^2)*elementArea);
                
                [obj.bucklingFailure(element,1)] = obj.checkBarFailure(obj.stress(element),criticalBuclingStress,element);
            end
        end

    end
    methods (Access = private,Static)
        function [lenght,se,ce] = computeElementGeometry(coordNodes,nodalConectivity,element)
            s.coordNode = coordNodes;
            s.nodalConectivity = nodalConectivity;
            s.element = element;
            B = ElementGeometryComputer(s);
            B.compute;
            se = B.se;
            ce = B.ce;
            lenght = B.lenght;
        end
        function [bucklingFailure] = checkBarFailure(stress,criticalBuclingStress,element)
            if stress < 0
                if abs(stress) > criticalBuclingStress
                   bucklingFailure = true;
                else
                   bucklingFailure = false;
                end 
            else
                   bucklingFailure = false;
            end
        end
    end
end