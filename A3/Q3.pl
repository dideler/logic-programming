/* @author Dennis Ideler
 * @date March 2010
 * COSC 2P93 - A3 - Q3
 * Integer Knapsack with no infinite items (i.e. no duplicate items unless given)
 * Solved with brute force algorithm.
 *
 * NOTE: must have the input file closed when reading input!
 * NOTE: item data from input file must be in this order -> Name, Weight, Value
 */

knapsack(Capacity):-
	abolish(sack/1),
	asserta(sack([])),	% contents of the best sack
	abolish(capacity/1),
	asserta(capacity(Capacity)),
	abolish(maxW/1),
	asserta(maxW(0)),	% the weight of the most valuable loot
	abolish(maxV/1),
	asserta(maxV(0)),	% the most valuable loot
	abolish(item/3),	% get rid of all traces left behind from previous runs
	%readFile('C:/Users/Dennis Ideler/Documents/Prolog/2p93_A3/A3/input.txt'), % Home (Windows)
	%readFile('C:/Documents and Settings/di07ty/My Documents/Prolog/2p93_A3/A3/input.txt'), % Labs (Windows)
	readFile(input),	% Linux
	write('Data loaded.'),nl,write('Finding optimal loot...'),nl,nl,	% friendly message to the user
	bruteForce,
	maxV(V), maxW(W), sack(S),
	write('The most valuable loot is worth $'),write(V),write(' and weighs '),write(W),write(' lbs.'),nl,
	write('Contents:'),nl,write(S),nl,!.
	
	
readFile(X):-
	see(X),
	seeing(InStream),nl,
	repeat,
	read_line_to_codes(InStream, String),
	%write(String),nl,
	tokenize(String), 
	String = end_of_file,	% if true, then close the stream, else repeat
	!,
	seen.					% close stream

tokenize(end_of_file).		% terminal condition
tokenize(String):-
  String \= end_of_file,	% ensure you don't tokenize eof
  parse(String,[],[]).

parse([],ListOfTokens,CurrentToken):-	% Base case
  reverse(CurrentToken,CompleteToken),	% need to add the last token to the list, thus reverse it first
  name(Token, CompleteToken),			% convert the ASCII list into an atom (i.e. into characters)
  Tmp = [Token|ListOfTokens],			% then add it
  reverse(Tmp,Output),					% now need to reverse the list as a whole
  addToKB(Output),						% add items to the knowledge base
  !.
parse([H|T], ListOfTokens, CurrentToken):-
  H \= 9,								% IF not the delimiter, build up the token
  parse(T, ListOfTokens, [H|CurrentToken]); % place character in current list, recursively check the next character
  H = 9,								% ELSE if delimiter...
  reverse(CurrentToken,CompleteToken),	% reverse current list (to put in original order)
  name(Token, CompleteToken),			% convert the ASCII list into an atom (i.e. into characters)
  parse(T, [Token|ListOfTokens], []). 	% insert token into list, and reset current token

reverse(List,Reversed):-
  rev(List,[],Reversed).

rev([],Rev,Rev).
rev([A|T],L,Rev):-
  rev(T,[A|L],Rev).

addToKB([Object, Weight, Value |_]):-		% note: tail will be empty on purpose
	assert(item(Object,Weight,Value)),		% eg) item(napkin, 1, 1)
	write(Object),							% print out progress to user
	write(': W='), write(Weight),
	write(', V='), write(Value),nl.
	
count([],0).		% initializes Sum to 0 (when list has been traversed)
count([_|T],N) :-
	count(T,Sum),	% recursively traverse the list	
    N is Sum+1.		% increase counter during backtracking

/* Credit for the permutation code goes to:
	http://ktiml.mff.cuni.cz/~bartak/prolog.old/learning/LearningProlog4.html	*/
perm(List,[H|Perm]):-delete(H,List,Rest),perm(Rest,Perm).
perm([],[]).

delete(X,[X|T],T).
delete(X,[H|T],[H|NT]):-delete(X,T,NT).

/* Create all variations */
modified_varia(0,_).
modified_varia(N,X):- 
	Z is N-1, 
	bagof(L, varia(N,X,L), LL),
	%write(LL), nl,	% print out all variations
	bruteForce(LL),
	modified_varia(Z,X).

/* Variation is a subset with given number of elements. The order of elements in variation is significant. */
varia(0,_,[]).
varia(N,L,[H|Varia]):-
	N > 0,
	N1 is N-1,
	delete(H,L,Rest),
	varia(N1,Rest,Varia).

/* Create a list of all asserted items, then create all combinations using this list */
bruteForce:-
	findall([X,Y,Z],item(X,Y,Z),Items),
	%write(Items), nl,
	count(Items, N),
	modified_varia(N, Items).
	
/* Evaluate every variaton to find the optimal loot */
bruteForce([]). %:-nl.
bruteForce([H|T]):-
	%write(H),nl, % friendly message
	computeLoot(H,0,0,H),	% start with the sack's weight & value at 0, and keep a copy of the items
	bruteForce(T).

/* Compute the current loot variation */
computeLoot([], TotalW, TotalV, Copy):-
	%write('Weight: '),write(TotalW),write('\tValue: '),write(TotalV),nl, % friendly message
	maxV(MaxV),
	TotalV > MaxV ->										% if there is a new record, record it
		retract(maxV(MaxV)), retract(maxW(_)), retract(sack(_)),
		asserta(maxV(TotalV)), asserta(maxW(TotalW)), asserta(sack(Copy));
		!.													% otherwise cut, do not record
computeLoot([[_,ItemW,ItemV]|T], SackW, SackV, Copy):-
	(NewW is SackW + ItemW, capacity(C), NewW =< C) ->		% if capacity not yet exceeded
		NewW is SackW + ItemW,
		NewV is SackV + ItemV,
		computeLoot(T, NewW, NewV, Copy);
		%write('**Capacity exceeded!**'),nl,				% friendly message
		!.													% else capacity exceeded