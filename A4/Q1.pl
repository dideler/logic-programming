/* Dennis Ideler
 * April 2010
 * COSC 2P93 - Logic Programming
 * Assignment 4 -  Question 1
 * 
 * Solve the Slumber Party using Constraint Logic Programming
 *
 * Write a program which matches up:
 * (1) each girl's first name with her last name,
 * (2) the movie she brought, (3) and her favourite snack.
 *
 * http://www.puzzles.com/Projects/LogicProblems/SlumberParty/SlumberPartySol.htm
 *
 * Summary of solving logic puzzles using tools in the field of Constraint Logic Programming
 * in Finite Domain:
 *	There will be a domain of information provided by the puzzle.
 *	The information about the variables is stored in a way which allows the program to interact
 *	with the domain of each variable to narrow the possibilities as more and more information is
 *	taken into account. In solving the puzzles, the domain of each variable reduces to one possibility.
 *	When all the variables reduce to one possibility, the puzzle has been solved.
 */

:- use_module(library(clpfd)). % Constraint Logic Programming with Finite Domains
:- writeln(''), writeln('Type "solve." to solve the logic puzzle'), writeln('').

% NOTE: lib(clpfd) uses #=, #\=, #<, #>, #>=, #=< to compare values

solve:-
  % Set appropriate domain values to variables
  [Alicia, Heidi, Matilda, Rhonda, Tabitha] ins 1..5,
  [Anderson, Copperfield, Goldsmith, Silverstein, Weaver] ins 1..5,
  [GQ, CW, EE, W, SD] ins 1..5,
  [Br, Ch, Cu, Po, Pr] ins 1..5,
  
  /* OR this method also works
  [Alicia] ins 1..5, [Heidi] ins 1..5, [Matilda] ins 1..5, [Rhonda] ins 1..5, [Tabitha] ins 1..5,
  [Anderson] ins 1..5, [Copperfield] ins 1..5, [Goldsmith] ins 1..5, [Silverstein] ins 1..5, [Weaver] ins 1..5,
  [CW] ins 1..5, [EE] ins 1..5, [GQ] ins 1..5, [SD] ins 1..5, [W] ins 1..5,
  [Br] ins 1..5, [Ch] ins 1..5, [Cu] ins 1..5, [Po] ins 1..5, [Pr] ins 1..5,
  */
  
  % Puzzle indicates that each value in the list is unique
  all_different([Alicia, Heidi, Matilda, Rhonda, Tabitha]),
  all_different([Anderson, Copperfield, Goldsmith, Silverstein, Weaver]),
  all_different([CW, EE, GQ, SD, W]),
  all_different([Br, Ch, Cu, Po, Pr]),
  
  % Fill in the clues
  Alicia #\= Anderson,		% Alicia's last name is not Anderson
  Alicia #= GQ,			% Alicia brought Galaxy Quest
  Alicia #\= Cu,		% Alicia did not bring the cupcakes
  Tabitha #\= Silverstein,	% Tabitha's last name is not Silverstein
  Tabitha #\= Pr,		% Tabitha did not bring the pretzels
  EE #= Pr,			% The girl who brought Ella Enchanted also brought pretzels
  EE #\= Weaver,		% The girl who brought Ella Enchanted did not have the last name Weaver
  Rhonda #= Ch,			% Rhonda brought the chocolate
  CW #\= Tabitha,		% The girl who brought Cat Woman was not Tabitha
  Heidi #= Weaver,		% Heidi's last name is Weaver
  Heidi #\= Br,			% Heidi did not bring the brownies
  Matilda #\= Cu,		% Matilda did not bring the cupcakes
  Rhonda #\= CW,		% Rhonda did not bring Cat Woman
  Goldsmith #= W,		% Goldsmith brought Willow
  Goldsmith #\= Po,		% Goldsmith did not bring the popcorn
  Copperfield #\= Matilda,	% Copperfield's first name is not Matilda
  Copperfield #\= Br,		% Copperfield did not bring the brownies
  Br #= SD,			% Brownies were brought with Stardust
  
  % Search for solutions
  label([Alicia, Heidi, Matilda, Rhonda, Tabitha]),
  
  /* Solutions are now in raw form...
  write('Alicia: '), writeln(Alicia),
  write('Heidi: '), writeln(Heidi),
  write('Matilda: '), writeln(Matilda),
  write('Rhonda: '), writeln(Rhonda),
  write('Tabitha: '), writeln(Tabitha),
  write('Anderson: '), writeln(Anderson),
  write('Copperfield: '), writeln(Copperfield),
  write('Goldsmith: '), writeln(Goldsmith),
  write('Silverstein: '), writeln(Silverstein),
  write('Weaver: '), writeln(Weaver),
  write('Cat Woman: '), writeln(CW),
  write('Ella Enchanted: '), writeln(EE),
  write('Galaxy Quest: '), writeln(GQ),
  write('Stardust: '), writeln(SD),
  write('Willow: '), writeln(W),
  write('Brownies: '), writeln(Br),
  write('Chocolates: '), writeln(Ch),
  write('Cupcakes: '), writeln(Cu),
  write('Popcorn: '), writeln(Po),
  write('Pretzels: '), writeln(Pr),
  */
  
  % Sort the solutions so that values at matching indexes belong to the same girl
  sort([Alicia, Heidi, Matilda, Rhonda, Tabitha], SortedNames),
  sort([Anderson, Copperfield, Goldsmith, Silverstein, Weaver], SortedSurnames),
  sort([GQ, CW, EE, W, SD], SortedMovies),
  sort([Br, Ch, Cu, Po, Pr], SortedSnacks),
  
  % Write the solution
  report(SortedNames, SortedSurnames, SortedMovies, SortedSnacks,
	 Alicia, Heidi, Matilda, Rhonda, Tabitha,
	 Anderson, Copperfield, Goldsmith, Silverstein, Weaver,
	 GQ, CW, EE, W, SD,
	 Br, Ch, Cu, Po, Pr),
  
  !. % do not try any other numbering possibilities (will still be correct solution though)

report([], [], [], [], _,_,_,_,_, _,_,_,_,_, _,_,_,_,_, _,_,_,_,_). % base case
report([Name_H|Name_T], [Surname_H|Surname_T], [Movie_H|Movie_T], [Snack_H|Snack_T],
       Al, He, Ma, Rh, Ta,
       An, Co, Go, Si, We,
       GQ, CW, EE, W, SD,
       Br, Ch, Cu, Po, Pr):-
  writeName(Name_H, Al, He, Ma, Rh, Ta),	% First comes the name
  writeSurname(Surname_H, An, Co, Go, Si, We),	% then the surname
  writeMovie(Movie_H, GQ, CW, EE, W, SD),	% then the movie
  writeSnack(Snack_H, Br, Ch, Cu, Po, Pr),	% then the snack.
  report(Name_T, Surname_T, Movie_T, Snack_T,	% Iterate through the list
	 Al, He, Ma, Rh, Ta,
	 An, Co, Go, Si, We,
	 GQ, CW, EE, W, SD,
	 Br, Ch, Cu, Po, Pr).

writeName(Name, A, H, M, R, T):-
  Name == A, write('Alicia ');
  Name == H, write('Heidi ');
  Name == M, write('Matilda ');
  Name == R, write('Rhonda ');
  Name == T, write('Tabitha ').
writeSurname(Surname, A, C, G, S, W):-
  Surname == A, write('Anderson: ');
  Surname == C, write('Copperfield: ');
  Surname == G, write('Goldsmith: ');
  Surname == S, write('Silverstein: ');
  Surname == W, write('Weaver: ').
writeMovie(Movie, G, C, E, W, S):-
  Movie == G, write('Galaxy Quest, ');
  Movie == C, write('Cat Woman, ');
  Movie == E, write('Ella Enchanted, ');
  Movie == W, write('Willow, ');
  Movie == S, write('Stardust, ').
writeSnack(Snack, Br, Ch, Cu, Po, Pr):-
  Snack == Br, writeln('Brownies');
  Snack == Ch, writeln('Chocolates');
  Snack == Cu, writeln('Cupcakes');
  Snack == Po, writeln('Popcorn');
  Snack == Pr, writeln('Pretzels').