% DD1361 Programmeringsparadigm, Labb L3: Redovisningsschemaläggning
% Kod-skelett av Per Austrin
%
% Lösning av...

include "globals.mzn";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VÄRDEN SOM DEFINIERAS I DATAFILERNA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Antal labb-lösningar som ska redovisas
int: solutions;

% Vilken labb som ska redovisas för varje labb-lösning
array [Solutions] of int: solution_lab;

% Vilken grupp av studenter som gjort varje labb-lösning
array [Solutions] of set of int: solution_group;

% Antal labbhandledare
int: teachers;

% Antal redovisningstider per handledare
int: timeslots;


%%%%%%%%%%%%%%%%%
% HJÄLPVARIABLER
%%%%%%%%%%%%%%%%%

% Mängden av alla labb-lösningar som ska redovisas
set of int: Solutions = 1..solutions;

% Mängd med samtliga studenter som ska redovisa något
set of int: Students = array_union(solution_group);

% Mängd med samtliga labbar som lösts
set of int: Labs = {lab | lab in solution_lab};

% Mängden av alla labbhandledare
set of int: Teachers = 1..teachers;

% Mängden av alla redovisningstider
set of int: Timeslots = 1..timeslots;

% Hur många studenter som vill redovisa varje labb
array [Labs] of int: student_lab_count = 
   [sum (sol in Solutions where solution_lab[sol] = l) (card(solution_group[sol])) | l in Labs];

% Hur många redovisningar det borde bli per labb
array [Labs] of int: presentations_per_lab = [student_lab_count[l] div 2 | l in Labs];

% Hur många redovisningar det borde bli totalt
int: presentations = sum(presentations_per_lab);

% Mängden av alla redovisningar
set of int: Presentations = 1..presentations;

% Funktion för att beräkna vilken presentation from ska hantera vilken lab
function array[int] of Labs: compute_presentations(set of Labs: labs) =
          if card(labs) == 0 then
             []
          else
             let {
               int: next_lab = min(labs),               
               array[int] of Labs: result = [next_lab | i in 1..presentations_per_lab[next_lab]] ++ 
                                            compute_presentations(labs diff {next_lab})
             } in
             result
          endif;

% För varje redovisningsgrupp, vilken labb som ska redovisas
array [Presentations] of Labs: presentation_lab = compute_presentations(Labs);



%%%%%%%%%%%%%%%%%%%%
% LÖSNINGSVARIABLER
%%%%%%%%%%%%%%%%%%%%

% För varje redovisningsgrupp, vilka studenter som ingår i den
array [Presentations] of var set of Students: presentation_group;

% För varje redovisningsgrupp, vilken handledare som redovisningen är för
array [Presentations] of var Teachers: presentation_teacher;

% För varje redovisningsgrupp, vilken tid redovisningen är
array [Presentations] of var Timeslots: presentation_time;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VILLKOR FÖR ATT LÖSA PROBLEMET HÄR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SÖKSPECIFIKATION FÖR ATT LÖSA PROBLEMET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Man kan om man vill speca sökningen mer detaljerat, t.ex. vilken
% sökstrategi som ska användas.
solve satisfy;

%%%%%%%%%%%%%%%%%%%%%%
% UTSKRIFT AV LÖSNING
%%%%%%%%%%%%%%%%%%%%%%

output
 [show(presentations), " redovisningar:\n",
	"    Tid  Handl.  Labb  Studenter\n"] ++
 [ show_int(2, p) ++ ": " ++
   show_int(-3, presentation_time[p]) ++ "  " ++
   show_int(-6, presentation_teacher[p]) ++ "  " ++
   show_int(-4, presentation_lab[p]) ++ "  " ++
   show(presentation_group[p]) ++ "\n"
     | p in Presentations ];
