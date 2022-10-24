classdef StressStrainComputer < handle

    properties (Access = private)
        numberElement 
        nodalConectivity
        degressConectivity
        coordNodes
        mat
        Tmat
        displacement
    end
    properties (Access = public)
        stress
        strain
    end 

    methods (Access = public)
        function obj = StressStrainComputer(cParams)
                obj.init(cParams);
        end

        function compute(obj)
            obj.computeStresStrain()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.nodalConectivity = cParams.nodalConectivity;
            obj.coordNodes =   cParams.coordNodes;
            obj.mat = cParams.mat;
            obj.Tmat = cParams.Tmat;  
            obj.displacement = cParams.displacement;
            obj.numberElement = cParams.numberElement;
            obj.degressConectivity = cParams.degressConectivity;
        end 

        function computeStresStrain(obj)
            strain=zeros(obj.numberElement,1);
            stress=zeros(obj.numberElement,1);
            degressConectivity = obj.degressConectivity;
            displacement = obj.displacement;
            typesArea = obj.mat(:,1);
            elementType = obj.Tmat;


            for element=1:obj.numberElement
                elementGlobalDisplacement=zeros(4,1);
                [elementLength,rotationMatrix] = obj.computeMatrixRotation(obj.coordNodes,obj.nodalConectivity,element);
                
                for i=1:4
                    postionGlobalDisplacement=degressConectivity(element,i);
                    elementGlobalDisplacement(i,1)=displacement(postionGlobalDisplacement);
                end
                elementLocalDisplacement=rotationMatrix*elementGlobalDisplacement;
                strain(element,1)=(1/elementLength)*[-1 0 1 0]*elementLocalDisplacement;
                stress(element,1)=typesArea(elementType(element))*strain(element,1);
            end
            obj.strain = strain;
            obj.stress = stress;

        end

    end 
    methods (Access = private,Static)
        function  [elementLength,rotationMatrix]  = computeMatrixRotation(coordNodes,nodalConectivity,element)
                
                s.coordNode = coordNodes;
                s.nodalConectivity = nodalConectivity;
                s.element = element;
                B = ElementGeometryComputer(s);
                B.compute()
                ce = B.ce;
                se = B.se;
                elementLength = B.lenght;
                
                rotationMatrix=[ce se 0 0
                -se ce 0 0
                0 0 ce se
                0 0 -se ce];
        end 
    end 
end