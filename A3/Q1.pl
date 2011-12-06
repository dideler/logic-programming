% @author Dennis Ideler
% @date March 2010
% COSC 2P93 - A3 - Q1
% String Tokenizer

% Have a current token, and list of all tokens.
% Once a delimiter is reached, placed the current token list inside the list of all tokens.
% e.g. |: hi you
%	 S = [104, 105, 32, 121, 111, 117]
%	 ListOfTokens = []
%	 CurrentToken = [104]
%	 CurrentToken = [104,105]
%	 delimiter reached. place current token into the list of tokens
%	 ListOfTokens = [[104,105]]
%	 CurrentToken = [121]
%	 CurrentToken = [121,111]
%	 CurrentToken = [121,111,117]
%	 ListOfTokens = [[104,105], [121,111,117]]

% NOTE: Linux uses the 'user' stream for input, Windows uses 'user_input'

tokenize:-
  read_line_to_codes(user_input,String), % asks for user input and store it as ASCII code into String
  parse(String,[],[]).

parse([],ListOfTokens,CurrentToken):-	% Base case
  reverse(CurrentToken,CompleteToken),	% need to add the last token to the list, thus reverse it first
  name(Token, CompleteToken),			% convert the ASCII list into an atom (i.e. into characters)
  Tmp = [Token|ListOfTokens],			% then add it
  reverse(Tmp,Output),					% now need to reverse the list as a whole
  write(Output),
  !.
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

%--------This version uses a built-in predicate---------
tokenizer(String):-
  concat_atom(Output,' ',String), % concatenate the string with whitepsace as delimiter
  write(Output).