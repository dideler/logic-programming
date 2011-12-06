starredIn(bruce_campbell,army_of_darkness).
starredIn(bruce_campbell,evil_dead).
starredIn(bruce_campbell,xena).
starredIn(bruce_campbell,darkman).
starredIn(lucy_lawless,xena).
starredIn(liam_neeson,darkman).
starredIn(liam_neeson,star_wars).
starredIn(ewan_mcgregor,star_wars).
starredIn(lucy_lawless,spartacus).
starredIn(john_hannah,spartacus).
starredIn(john_hannah,the_mummy).
starredIn(brendan_fraser,the_mummy).
starredIn(brendan_fraser,journey_earth).
starredIn(mole_people,journey_earth).
starredIn(mole_people,fancy).
starredIn(chuck,fancy).
starredIn(chuck,squiggle).
starredIn(me,squiggle).
starredIn(me,something).
starredIn(you,something).

minlist([X],X).
minlist([X,Y|Rest],Min):- minlist([Y|Rest],MinRest),Min is min(X,MinRest).

costarred(ActorOne,StarTwo,Film):-
	starredIn(ActorOne,Film),
	starredIn(StarTwo,Film),
	\+(ActorOne=StarTwo).
check(ActorA):-
	ActorA=bruce_campbell,
	write('Bruce be the man, himself.'),nl,!.
check(ActorA):-
	setof(Degrees,campbellifies(ActorA,bruce_campbell,6,Degrees),S),
	minlist(S,Eidros),
	%length(S,Length),
	%Length>0,
	write('Eidros number is '),write(Eidros),nl,!.
check(ActorA):-
	\+ campbellifies(ActorA,bruce_campbell,6,_),
	write(ActorA),write(' has no Eidros number.'),nl.
campbellifies(ActorA,StarTwo,Limit,Degrees):-
	ActorA=StarTwo,
	Degrees is 6-Limit.
campbellifies(ActorA,StarTwo,Limit,Degrees):-
	LessDegrees is Limit-1,
	Limit>0,
	%costarred(ActorA,CelebTrois,AFilm),
	costarred(ActorA,CelebTrois,_),
	campbellifies(CelebTrois,StarTwo,LessDegrees,Degrees).
	%write(CelebTrois),write(' was in '),write(AFilm),write(' with '),write(ActorA),nl.
