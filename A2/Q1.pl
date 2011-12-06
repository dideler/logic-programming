% @author Dennis Ideler - 4134466
% @date February 2010
% COSC 2P93 - A2

% (a) Counts the number of items N in list L

count([],0).		% initializes Sum to 0 (when list has been traversed)

count([_|T],N) :-
	count(T,Sum),	% recursively traverse the list	
        N is Sum+1.	% increase counter during backtracking
		
%---------------------------------------------------------------------------------------

% (b) Counts the number of instances Q in list L, which is N

tally(L,Q,_) :-
	count(L,Q,0).	% call count with N initialized to 0

count([Q|T],Q,N) :-	% if Q matches current element (i.e. head),
	!,				% cut to not search exhaustively
	N1 is N+1,		% increase counter
	count(T,Q,N1).	% recursively traverse the list with the new count

count([_|T],Q,N) :-	% else Q does not match current element, (because above rule already checked for match)
	%not(H = Q)		% can add a line such as not(H = Q) or H \= Q to be safe, but not really needed
	count(T,Q,N).	% recursively traverse the list with the same count

count([],_,N) :-	% if finished traversing the list, (i.e. list is currently empty)
        write('N = '),
        write(N),	% print out value of N. if this isn't done, then backtracking causes N to go back to "something" and it won't be returned to the query
        nl.

%-----------------------------------------------------------------------------------------

% (c) removeItem(A,L,M) removes item A from list L, resulting in list M

removeItem(A,[A|L],L). % base case -- when match found, copy remaining list

removeItem(A,[N|M],[N|L]) :- % adds non matching elements to the front when backtracking (ie adds missing elements)
	removeItem(A,M,L).
	
%------------------------------------------------------------------------------------------

% (d) removeAll(A,L,M) => Removes all instances of A from list L, resulting in list M

removeAll(A,[A|Tail],NewList) :-		% if A matches current element (i.e. head)
	removeAll(A,Tail,NewList).			% recursively traverse the list and do not add A to new list

removeAll(A,[Head|Tail],[Head|NewTail]) :-	% if A does not match current element (i.e. head), include head in new list
	%not(Head = A),							% can be included for safety, but not needed (can also use A \= Head)
	removeAll(A, Tail, NewTail).			% recursively traverse list, and the new list now contains the head that was just added

removeAll(_,[],[]).			% when L has been fully traversed, the new list is initialized which is then filled during backtracking

%-------------------------------------------------------------------------------------------

% (e) Remove one item if Type=one, remove all items if Type=all, or do nothing if neither.

removeGen(one,A,L,M) :-	% remove one item
	removeItem(A,L,M).
	
removeGen(all,A,L,M) :- % remove all items
	removeAll(A,L,M).

%---------------------------------------------------------------------------------------

% (f) Takes a list L and writes each item on a new line on the terminal, with the count in front

writeList(L) :-
	writeList(L,0).		% need to initialize counter to 0, only done once
	
writeList([H|T],N) :-
	N2 is N+1,		% increase counter
	write(N2),		% write counter
	write(' '),		% write white space
	write(H),nl,	% write current element
	writeList(T,N2).% recursively traverse the list with the new count


