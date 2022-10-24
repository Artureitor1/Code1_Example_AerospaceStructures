classdef ElementalStiffnessMatricesComputer < handle
    properties (Access = private)
        geometry 
        structure
    end
    properties (Access = public)
        elementalStifnessMatrix
    end

    methods (Access = public)
        function obj = ElementalStiffnessMatricesComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeKelBar()
        end
    end

    methods (Access = private)

        function init(obj,cParams)    
            obj.geometry  = cParams.geometry;
            obj.structure = cParams.structure;
        end
        function computeKelBar(obj)
            obj.elementalStifnessMatrix=zeros(obj.geometry.degreeFredomPerElement,obj.geometry.degreeFredomPerElement,obj.geometry.numberElement);
            elementType = obj.structure.Tmat;
            typeProperties = obj.structure.mat;

            for element=1:obj.geometry.numberElement

                [lenght,se,ce] = obj.computeElementGeometry(obj.structure.coordNodes,obj.structure.nodalConectivity,element);
                
                elementArea  = (typeProperties(elementType(element),2));;
                elementElasticModule = (typeProperties(elementType(element),1));

                obj.elementalStifnessMatrix(:,:,element) = elementArea*elementElasticModule/lenght * [ce^2 ce*se -(ce)^2 -ce*se
                                                                                                      ce*se se^2 -ce*se -(se)^2
                                                                                                      -(ce)^2 -ce*se ce^2 ce*se
                                                                                                  -ce*se -(se)^2 ce*se se^2];   
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
    end 
end