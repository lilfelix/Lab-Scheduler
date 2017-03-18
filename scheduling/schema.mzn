% DD1361 Programmeringsparadigm, Labb L3: Redovisningsschemaläggning
% Kod-skelett av Per Austrin
%
% Lösning av Felix Liljefors
%
%teachers = 2;
%timeslots = 2;

%solutions = 4;
%solution_lab = [1, 1, 2, 2];
%solution_group = [{1,2}, {3,4}, {1,3}, {2,4}];
%
%

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
   [sum (sol in Solutions where solution_lab[sol] = l) (card(solution_group[sol])) | l in Labs]; %aggregate sum of: for every lab solution = l, take cardinality of student set to that specific lab solution

% Hur många redovisningar det borde bli per labb
array [Labs] of int: presentations_per_lab = [student_lab_count[l] div 2 | l in Labs]; % 3 div 2 ger 1?

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

% För varje redovisningsgrupp, vilken labb som ska redovisas. Ex [1,1,1,2,2] de tre första grupperna presenterar lab 1
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
% Varje student ska få redovisa exakt de labbar hen löst
%constraint forall (group in solution_group, student in group, p) ();

% Varje student ska inte behöva redovisa någon labb mer än en gång.
constraint forall (p1,p2 in Presentations where p1 != p2 /\ presentation_lab[p1] == presentation_lab[p2]) ((presentation_group[p1] intersect presentation_group[p2]) == {});
 
% Redovisningsgrupperna ska bestå av grupper om 2 studenter (i undantagsfall en grupp per labb med 3 studenter, om det är ett udda antal studenter som gjort den labben).
constraint forall (pg in presentation_group) ( card(pg) >= 1 /\ card(pg) <= 3);

% Varje student ska redovisa varje labb tillsammans med en annan student (eller två andra, i undantagsfallet med en redovisningsgrupp av storlek 3) än den/de studenter som hen gjort labben tillsammans med.
%for every presentation group, for every lab group if x is in persentation group and lab group, and y is in lab group, then y is not in presentation group
constraint
    forall (pg in presentation_group) (
        forall (sg in solution_group ) (
            %forall (s1, s2 in sg where s1 != s2) -> not(s1 in pg /\ s2 in pg)
            forall( [ not(s1 in pg /\ s2 in pg) | s1,s2 in sg where s1 != s2])
        )
    ); 
        
% En labbhandledare kan inte vara inbokad på två olika redovisningar vid samma tidpunkt.
% En student kan inte vara inbokad på två olika redovisningar vid samma tidpunkt.
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