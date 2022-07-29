clear
clc
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\KG.mat')
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\Fext.mat')
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_dir.mat')
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_iter.mat')

%% Create the objefcts
Test1 = SolverStructureDirect; %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one use.
Test2 = SolverStructureIterative; %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one use.


%% Check in Validation

valKG       = true;
valFext     = true;
valU_dir    = true;
valU_iter   = true;

%% DEFINE PROPERTIES-EXAMPLE

F = 920; %[N]
Young = 75000e6; %[Pa]
Area = 120e-6; %[m^2]
thermal_coeff = 23e-6; %[K^-1]
Inertia = 1400e-12; %[m^4]


x = [
0 0
0.5 0.2
1 0.4
1.5 0.6
0 0.5
0.5 0.6
1 0.7
1.5 0.8
];


Tn = [
1 2
2 3
3 4
5 6
6 7
7 8
1 5
1 6
2 5
2 6
2 7
3 6
3 7
3 8
4 7
4 8
];

Fdata = [
            2 2 3
            3 2 2
            4 2 1
];


fixNod = [
          1 1 0
          1 2 0
          5 1 0
          5 2 0
];

Tmat = [
 1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1
];

%% InputData
InputData(Test1,F,Young,Area,thermal_coeff,Inertia)
InputData(Test2,F,Young,Area,thermal_coeff,Inertia)


%% InputStructure
InputStructure(Test1,x,Tn,Fdata,fixNod,Tmat)
InputStructure(Test2,x,Tn,Fdata,fixNod,Tmat)


%% SolveStructure
SolveStructure(Test1)
SolveStructure(Test2)

clc
%% Validator
if valKG
    if Test1.KG == KG 
        disp('Stifness matrix OK!');
    else
        error('ERROR in Stifness matrix ');
    end
end

if valFext
    if Test1.Fext == Fext
        disp('Complete Forces OK!');
    else
        error('ERROR in Complete Forces');
    end
end

if valU_dir
    if Test1.u == u_dir
        disp('Displacement by direct method OK!');
    else
        error('ERROR in Displacement by direct method');
    end
end

if valU_iter
    if Test2.u == u_iter
        disp('Displacement by iterative method OK!');
    else
        error('ERROR in Displacement by iterative method');
    end
end
clear