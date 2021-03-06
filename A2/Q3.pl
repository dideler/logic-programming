% @author Dennis Ideler - 4134466
% @date February 8, 2010
% COSC 2P93 - Logic Programming
% Assignment 2, Question 3

% edge-clause form
starredIn(bruce_campbell, army_of_darkness).
starredIn(bruce_campbell, evil_dead).
starredIn(bruce_campbell, xena).
starredIn(bruce_campbell, darkman).
starredIn(bruce_campbell, jack_of_all_trades).
starredIn(lucy_lawless, xena).
starredIn(liam_neeson, darkman).
starredIn(liam_neeson, star_wars).
starredIn(ewan_mcgregor, star_wars).
starredIn(lucy_lawless, spartacus).
starredIn(john_hannah, spartacus).
starredIn(john_hannah, the_mummy).
starredIn(brendan_fraser, the_mummy).
starredIn(brendan_fraser, journey_earth).
starredIn(seth_meyers, journey_earth).
starredIn(seth_meyers, snl).
starredIn(amy_poehler, snl).
starredIn(tina_fey, snl).
starredIn(mike_meyers, snl).
starredIn(amy_poehler, baby_mama).
starredIn(tina_fey, baby_mama).
starredIn(mike_meyers, austin_powers).
starredIn(heather_graham, austin_powers).
starredIn(verne_troyer, austin_powers).
starredIn(seth_green, austin_powers).
starredIn(seth_green, rat_race).
starredIn(whoopi_goldberg, rat_race).
starredIn(verne_troyer, jack_of_all_trades).
starredIn(johnny_depp, sleepy_hollow).
starredIn(christina_ricci, sleepy_hollow).
starredIn(hugh_grant, love_actually).


% Campbell Number of an actor/actress is the MINIMUM degrees of separation between Campbell and a given actor/actress.

campbellNumber(bruce_campbell) :-	% special case
  write('bruce_campbell has a Campbell Number of 0.').

campbellNumber(Actor) :-
  write(Actor),			% can print this stuff initially since it's both in true and false cases
  write(' has '),
  path(Actor,bruce_campbell,1). % starts at 1 degree, because the 0th degree was a special case

path(A,B,Degree) :- 	% helper predicate
  Degree =< 6,		% while within degree limit
  costarred(A,B),	% check if actor A and B are costars
  B == bruce_campbell,	% if Campbell has been reached, then finished searching
  write('a Campbell Number of '), % print out the result
  write(Degree),
  write('.').

path(A,B,Degree) :-	% helper predicate
  Degree =< 6,		% while within degree limit
  Count is Degree+1,	% increase degree
  costarred(A,C),	% check if actor A and C are costars
  path(C,B,Count); 	% continue to recur, checking the relationship between actor C and B
  write('no Campbell Number.'), % else if degrees > 6, then failed
  fail.

path(_,_,_). % lets it finish gracefully on a fail (because the body of a rule is true)

costarred(A,B) :- 	% helper predicate
  starredIn(A, Movie),	% costars if they appeared in the same movie
  starredIn(B, Movie),
  A \= B.		% cannot be the same actor
