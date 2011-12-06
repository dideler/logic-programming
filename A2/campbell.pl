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

costarred(ActorOne,StarTwo,Film):-
	starredIn(ActorOne,Film),
	starredIn(StarTwo,Film),
	\+(ActorOne=StarTwo).
check(ActorA):-
	ActorA=bruce_campbell, %Note, should change to check(bruce_campbell):-write...
	write('Bruce be the man, himself.'),nl,!.
check(ActorA):-
	campbellifies(ActorA,bruce_campbell,6).
campbellifies(ActorA,StarTwo,_):-
	ActorA=StarTwo.
campbellifies(ActorA,StarTwo,Degrees):-
	LessDegrees is Degrees-1,
	Degrees>0,
	costarred(ActorA,CelebTrois,AFilm),
	campbellifies(CelebTrois,StarTwo,LessDegrees),
	!,
	write(CelebTrois),write(' was in '),write(AFilm),write(' with '),write(ActorA),nl.
