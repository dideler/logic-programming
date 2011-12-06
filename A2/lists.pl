count([],0).
count([_|T],N):-
	count(T,Nsub),
	succ(Nsub,N).

tally([],_,0).
tally([H|T],Q,N):-
	tally(T,Q,Nsub),
	H=Q,
	N is Nsub+1.
tally([H|T],Q,N):-
	tally(T,Q,Nsub),
	H\=Q,
	N=Nsub.

removeAll(_,[],[]).
removeAll(A,[Lhead|Ltail],Ntail):-
	removeAll(A,Ltail,Ntail),
	Lhead=A.
removeAll(A,[Lhead|Ltail],[Lhead|Ntail]):-
	removeAll(A,Ltail,Ntail),
	Lhead\=A.

removeItem(N, [N|L], L).
removeItem(N, [A|R], [A|L]) :- remove(N, R, L).

removeGen(Type,A,L,M):-
	Type=all,
	removeAll(A,L,M).
removeGen(Type,A,L,M):-
	Type=one,
	removeItem(A,L,M).

writeList(L):-
	writeit(L,1).
writeit([],_).
writeit([H|T],N):-
	write(N),write(' '),write(H),nl,
	succ(N,N2),
	writeit(T,N2).
