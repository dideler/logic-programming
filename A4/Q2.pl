/* Dennis Ideler
 * April 2010
 * COSC 2P93 - Logic Programming
 * Assignment 4 -  Question 2
 * 
 * Detect palindroms using Definite Clause Grammar
 *
 * Have the user type in some word or phrase.
 * Store the word as a list of characters, or simply as character codes.
 * Create DCG rules that can test if a word/phrase is a palindrome.
 * Indicicate if it is or isn't a palindrome.
 *
 * Assume that uppercase letters and lowercase letters are separate letters for this purpose.
 * This can easily be done with only three rules (not including the bonus mentioned below).
 *
 * BONUS: Use DCG rules to ignore spaces and apostrophes
 *		  Assume that no double-spaces or double-apostrophes will be used
 */

:- writeln(''), writeln('Type "palindrome." to test the palindrome.'), writeln('').

palindrome:-
    read_line_to_codes(user,String), % asks for user input and store it as ASCII code into String
	writeln('This may take a while... please be patient.'),
	palindrome(String,[]).

% Check for invalid characters (other special characters can be added to the list by changing the ASCII code)
palindrome-->[32],palindrome.				% if whitespace encountered in front, recursively skip it
palindrome-->[Char],palindrome,[Char],[32].	% if whitespace encountered in rear, check predecessor
palindrome-->[_],[32].						% special case, if apostrophe in rear and there is no predecessor to check

palindrome-->[39],palindrome.				% if apostrophe encountered in front, recursively skip it
palindrome-->[Char],palindrome,[Char],[39].	% if apostrophe encountered in rear, check predecessor
palindrome-->[_],[39].						% special case, if apostrophe in rear and there is no predecessor to check

% There are 3 cases of what a palindrome is
palindrome-->[Char],palindrome,[Char].		% matching front and back, and recursively checking the middle
palindrome-->[_].							% a single letter
palindrome-->[].							% an empty string

/*
whitespace = 32
apostrophe = 39

example for whitespace: i prefer pi
1: 'i' <-> 'i'
2: ' ' <-> 'p'	invalid char encountered in front
3: 'p' <-> 'p'
4: 'r' <-> ' '	invalid char encountered in rear
5: 'r' <-> 'r'

example for apostrophe in rear: mad'am
1: 'm' <-> 'm'
2: 'a' <-> 'a'
3: 'd' <-> '''
4: 'd'
*/