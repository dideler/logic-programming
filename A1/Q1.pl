% A1, Q1: Family tree

% Facts

male(dennis).	% Me
male(paul).	% My father
male(steve).	% Katherine's father
male(nicholas).	% Katherine's brother
male(yannick).	% My cousin
male(marcel).	% My uncle
male(clifford).	% Katherine's grandfather
male(jose).	% My grandfather
male(jesus).	% Jesus (needed someone unrelated, lulz)

female(katherine).	% My girlfriend
female(judy).		% Katherine's mother
female(jacqueline).	% My mother
female(nichelle).	% My sister
female(frances).	% My aunt
female(mien).		% My grandmother

begot(paul,dennis). % offspring
begot(paul,nichelle).
begot(steve,katherine).
begot(steve,nicholas).
begot(clifford,steve).
begot(jacqueline,dennis).
begot(jacqueline,nichelle).
begot(judy,katherine).
begot(judy,nicholas).
begot(mien,paul).
begot(mien,marcel).
begot(jose,jacqueline).
begot(jose,frances).
begot(frances,yannick).

wed(paul,jacqueline).
wed(jacqueline,paul).
wed(steve,judy).
wed(judy,steve).
wed(dennis,katherine).
wed(katherine,dennis).

% Rules

son(X,Y) :- % son if a child (of someone in the KB, because really every male is a son) and male
  begot(Y,X), % no need to check X \= Y, because there are no begot facts where X = Y (unless parent and child have the same name, but not in this KB)
  male(X).

daughter(X,Y) :- % daughter if a child and female
  begot(Y,X), % same story as above
  female(X).

sibling(X,Y) :- % sibling if same parents
  parent(Z,X),
  parent(Z,Y),
  X \= Y. % no need to check Z \= X and Z \= Y, that's done in parent rule

brother(X,Y) :- % brother if sibling and male
  sibling(X,Y), % X \= Y is checked in sibling
  male(X).

sister(X,Y) :- % sister if sibling and female
  sibling(X,Y), % X \= Y is checked in sibling
  female(X).

father(X,Y) :- % father if produced offspring and male
  begot(X,Y),
  male(X).

mother(X,Y) :- % mother if produced offspring and female
  begot(X,Y),
  female(X).

parent(X,Y) :- % parent if produced offspring
  begot(X,Y).

wife(X,Y) :- % wife if married and female
  spouse(X,Y), % X \= Y is checked in spouse rule
  female(X).

husband(X,Y) :- % husband if married and male
  spouse(X,Y), % same as by wife
  male(X).

spouse(X,Y) :- % spouse if married
  wed(X,Y),
  X \= Y;
  wed(Y,X),
  X \= Y.

sisterInLaw(X,Y) :- % sister-in-law if sister of spouse, or wife of sibling
  spouse(Z,Y),
  sister(X,Z); % X \= Y, X \= Z, and Y \= Z all checked in the called rules
  sibling(Y,Z),
  wife(X,Z).

brotherInLaw(X,Y) :- % brother-in-law if brother of spouse, or husband of sibling
  spouse(Z,Y),
  brother(X,Z); % same as by sisterInLaw
  sibling(Y,Z),
  husband(X,Z).

sonInLaw(X,Y) :- % son-in-law if husband of child (many of my rules consider the child, rather than the gender of the child [e.g. daughter], in case of gay marriage)
  husband(X,Z),
  begot(Y,Z).

daughterInLaw(X,Y) :- % daughter-in-law if wife of child
  wife(X,Z),
  begot(Y,Z).

motherInLaw(X,Y) :- % mother-in-law if mother of spouse
  spouse(Y,Z),
  mother(X,Z).

fatherInLaw(X,Y) :- % father-in-law if father of spouse
  spouse(Y,Z),
  father(X,Z).

inLaw(X,Y) :- % in-law if brother-, sister-, mother-, or father-in-law
  brotherInLaw(X,Y);
  sisterInLaw(X,Y);
  motherInLaw(X,Y);
  fatherInLaw(X,Y);
  sonInLaw(X,Y);
  daughterInLaw(X,Y).
  
uncle_A(X,Y) :- % uncle if a brother of a parent
  brother(X,Z),
  parent(Z,Y).
  
uncle_B(X,Y) :- % uncle if the husband of your aunt
  husband(X,Z),
  aunt_A(Z,Y).

uncle(X,Y) :- % combines the two uncle rules
  uncle_A(X,Y);
  uncle_B(X,Y).

aunt_A(X,Y) :- % aunt if a sister of a parent
  sister(X,Z),
  parent(Z,Y).

aunt_B(X,Y) :- % aunt if the wife of your uncle
  wife(X,Z),
  uncle_A(Z,Y).

aunt(X,Y) :- % combines the two aunt rules
  aunt_A(X,Y);
  aunt_B(X,Y).

niece(X,Y) :- % niece if daughter of sibling, OR daughter of spouse's sibling
  daughter(X,Z),
  sibling(Y,Z);
  daughter(X,Z),
  sibling(Z,A),
  spouse(A,Y).

nephew(X,Y) :- % nephew if son of sibling, OR son of spouse's sibling
  son(X,Z),
  sibling(Y,Z);
  son(X,Z),
  sibling(Z,A),
  spouse(A,Y).

% NOTE: There is no need to check the child of the "aunt/uncle" that is the spouse of your actual aunt/uncle (thus no need to check uncle_B & aunt_B for cousins),
%	because the 2nd definition of aunt/uncle means they are the spouse of your real aunt/uncle, thus they share the same child legally (perhaps not biologically).
%	Otherwise there would just be double results for no good reason. 
cousin(X,Y) :- % cousin if child of uncle or aunt
  uncle_A(Z,Y), % note that uncle_B isn't checked on purpose, because if there exists an uncle_B, that means there is an aunt_A (i.e. a real aunt), thus the same cousin
  parent(Z,X);
  aunt_A(Z,Y), % note that aunt_B isn't checked on purpose, because if there exists an aunt_B, that means there is an uncle_A (i.e. a real uncle), thus the same cousin
  parent(Z,X).

ancestor(X,Y) :- % recursive -- parent, parent of a parent, etc.
  parent(X,Y); % base case
  parent(X,Z),
  ancestor(Z,Y).

related(X,Y) :- % related if family
  sibling(X,Y);
  parent(X,Y);
  begot(X,Y);
  spouse(X,Y);
  inLaw(X,Y);
  cousin(X,Y);
  aunt(X,Y);
  uncle(X,Y);
  niece(X,Y);
  nephew(X,Y);
  ancestor(X,Y);
  ancestor(Y,X).

unrelated(X,Y) :- % unrelated if not related -- need to assign X first if I want it to work with variables
  %not(related(X,Y)).
  \+ related(X,Y).