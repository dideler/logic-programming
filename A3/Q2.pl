% @author Dennis Ideler
% @date March 2010
% COSC 2P93 - A3 - Q2
% Postfix Calculator
% The program only recognizes the basic operators: +,-,*,/

% When you encounter an operand (number), push it on a stack.
% When you encounter an operator (+,-,*,/),
%	pop two values off of the stack,
%	perform the calculation with the operator encountered,
%	and push the result back onto the stack.
% When you run out of tokens, the (only) item on the stack is the final solution.

% e.g.) 2 2 +
% Stack = [], List = [2, 2, +]
% Stack = [2], List = [2, +]
% Stack = [2, 2], List = [+]
% operator encountered: pop both 2s
% Stack = [], List = []
% apply operator: 2+2 -> 4
% Stack = [4], List = []
% No more tokens left, Answer = 4

% NOTE: Linux uses the 'user' stream for input, Windows uses 'user_input'

rpn:-
  write('Please enter your math in postfix notation: '),
  read_line_to_codes(user_input,String), % asks for user input and store it as ASCII code into String
  parse(String,[],[]).

parse([],ListOfTokens,CurrentToken):-	% Base case
  reverse(CurrentToken,CompleteToken),	% need to add the last token to the list, thus reverse it first
  name(Token, CompleteToken),			% convert the ASCII list into an atom (i.e. into characters)
  Tmp = [Token|ListOfTokens],			% then add it
  reverse(Tmp,List),					% now need to reverse the list as a whole
  !,
  calculate(List, []).					% perform the calculation
  
parse([H|T], ListOfTokens, CurrentToken):-
  H \= 32,								% IF not the delimiter, build up the token
  parse(T, ListOfTokens, [H|CurrentToken]); % place character in current list, recursively check the next character
  H = 32,								% ELSE if delimiter...
  reverse(CurrentToken,CompleteToken),	% reverse current list (to put in original order)
  name(Token, CompleteToken),			% convert the ASCII list into an atom (i.e. into characters)
  parse(T, [Token|ListOfTokens], []). 	% insert token into list, and reset current token

reverse(List,Reversed):-
  rev(List,[],Reversed).
  
rev([],Rev,Rev).
rev([A|T],L,Rev):-
  rev(T,[A|L],Rev).
  
push(Item,Stack,[Item|Stack]).
pop(Item,[Item|Rest],Rest).
top(Top,[Top|_]).
is_empty([]).

% Example:
% ?- push(2,[],Stack), push(3,Stack,NewStack).
% Stack = [2],
% NewStack = [3, 2].

% Example:
% ?- pop(H, [a,b,c],Stack).
% H = a,
% Stack = [b, c].

calculate([],Stack):-					% base case -- when out of tokens, answer is item left in stack
	top(Top, Stack),
	write('Solution: '),
	write(Top).
calculate([H|T], Stack):-
	H = +,								% ADD the top 2 values
	pop(Operand2, Stack, NewStack),		% pop 2 values
	pop(Operand1, NewStack, NewerStack),
	Result is Operand1 + Operand2,		% apply the operator to the operands
	push(Result, NewerStack, NewestStack), % push the result in the stack
	!,									% prune the tree
	calculate(T, NewestStack);			% continue the calculation
	H = -,								% SUBTRACT the top 2 values
	pop(Operand2, Stack, NewStack),		% pop 2 values
	pop(Operand1, NewStack, NewerStack),
	Result is Operand1 - Operand2,		% apply the operator to the operands
	push(Result, NewerStack, NewestStack), % push the result in the stack
	!,									% prune the tree
	calculate(T, NewestStack);			% continue the calculation
	H = *,								% MULTIPLY the top 2 values
	pop(Operand2, Stack, NewStack),		% pop 2 values
	pop(Operand1, NewStack, NewerStack),
	Result is Operand1 * Operand2,		% apply the operator to the operands
	push(Result, NewerStack, NewestStack), % push the result in the stack
	!,									% prune the tree
	calculate(T, NewestStack);			% continue the calculation
	H = /,								% DIVIDE the top 2 values
	pop(Operand2, Stack, NewStack),		% pop 2 values
	pop(Operand1, NewStack, NewerStack),
	Result is Operand1 / Operand2,		% apply the operator to the operands
	push(Result, NewerStack, NewestStack), % push the result in the stack
	!,									% prune the tree
	calculate(T, NewestStack);			% continue the calculation
	push(H, Stack, NewStack),			% ELSE push the operand onto the stack
	calculate(T, NewStack).
