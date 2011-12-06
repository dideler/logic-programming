% Facts

% these facts not really needed
%animal(elephant).
%animal(mouse).
%animal(poodle).
%animal(cat).
%animal(whale).
%animal(man).
%animal(ostrich).

% weight is in kilograms
weight(elephant,900).
weight(mouse,1).
weight(poodle,5). % original weight was 6 kg
weight(cat,7).
weight(whale,2000).
weight(man,70).
weight(ostrich,90).
weight(kwyjibo,150).

habitat(whale,ocean).
habitat(man,savannah).
habitat(man,jungle).
habitat(ostrich,savannah).
habitat(kwyjibo,forest).

legs(elephant,4).
legs(mouse,4).
legs(poodle,4).
legs(cat,4).
legs(whale,0).
legs(man,2).
legs(ostrich,2).
legs(kwyjibo,2). % note: legs might be useless due to obesity

% Rules

big(Animal) :- % if it weighs more than 50 Kg
  weight(Animal,Weight),
  Weight>50.

small(Animal) :- % if it weighs less than 5 Kg
  weight(Animal,Weight),
  Weight<5.

medium(Animal) :- % if it is neither big nor small (i.e. between 5-50 kg inclusive) 
  \+ small(Animal),
  \+ big(Animal).
% weight(Animal,Weight), % alternate way
% Weight>=5,
% Weight<=50.

biggish(Animal) :- % if it is medium or big
  medium(Animal);
  big(Animal).

smallish(Animal) :- % if it is medium or small
  medium(Animal);
  small(Animal).

tropical(Animal) :- % if it lives in a jungle or on a savannah
  habitat(Animal,jungle);
  habitat(Animal,savannah).

marine(Animal) :- % if it lives in the ocean
  habitat(Animal,ocean).

forestDwelling(Animal) :- % if it is neither marine nor tropical
  habitat(Animal,_),
  \+ tropical(Animal),
  \+ marine(Animal).

quadruped(Animal) :- % if walks on 4 legs
  legs(Animal,Legs),
  Legs = 4.

biped(Animal) :- % if walks on 2 legs
  legs(Animal,Legs),
  Legs = 2.
