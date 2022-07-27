classdef SolverStructureIterative < SolverStructure

    methods (Access = public, Static)
           function [u,R] = SolveSystem(vL,vR,uR,KG,Fext)
                KLL=KG(vL,vL);
                KLR=KG(vL,vR);
                KRL=KG(vR,vL);
                KRR=KG(vR,vR);
                FextL=Fext(vL,1);
                FextR=Fext(vR,1);
                
                uL = pcg(KLL,(FextL-KLR*uR));
                RR=KRR*uR+KRL*uL-FextR;
                
                u(vL,1)=uL;
                u(vR,1)=uR;
                
                R(vL,1) = 0;
                R(vR,1) = RR;
            end
    end
end