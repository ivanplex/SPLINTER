Splinter- SPLINTER       USER GUIDE

- Typing

- The  language  has  two  main  types:  int  and  bool.  Ints  are  signed  32-bit  integers,  while  bools  are  boolean

- values.

- The language also features lists. Lists are dynamic arrays of variables of almost any size. Their size is only

- limited by the size of a positive integer with which to specify an index of the list. When declaring the type of a

- variable  or  function,  lists  are  declared  as  “<element  type>  list”,  where  the  element  type  is  any  other  valid

- variable type, for instance: “bool list”, or “int list list”.

- Functions may also be declared as void, meaning they do not return a value. Variables may not be void.

- Syntax

- The top level of a program consists of function definitions, and global variable initialisations

- Function  definitions  consists  of  a  type  declaration,  a  function  name  (which  must  start  with  an  uppercase

- letter), parameter declarations in brackets, and a sequence of expressions surrounded by braces. Parameter

- declarations consist of a valid variable type declaration, followed by the parameter name.

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=3>If  there  are  multiple  parameters,  they  are  separated  by commas. If the function body consists of multiple expressions, they  are  separated  by  a  semicolon,  with  an  optional  trailing semicolon.</td>
		<td rowspan=3>void foo ( int a, bool b) { /* function body */ }</td>
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

- Each  program  requires  three  functions  to  be  defined:  Init  and  Final,  which  both  take  no  parameters,  and

- Loop, which takes a single int list parameter. All three return void. Init is run once at the start of execution,

- Loop is run once for each value in the input streams, and Final is run once after the entire input stream has

- been processed.

- Valid types for functions are int, bool, void, or * list, where * is any other valid type.

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=3>Variable initialisations consist of a type declaration, a variable name (which must start with a lowercase letter), followed by an equal sign, then an expression which matches the type of the variable.</td>
		<td rowspan=3>int foo = 3;</td>
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

- Variables  initialised  outside  of  a  function  definition  are  global,  meaning  they  can  be  accessed  from  any

- function, and are persistent across function calls.

- Expressions, may be:

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

- variable  will  no  longer  be  in  scope  after  the  function  it  is  in  terminates.  If  defined  within  a

- conditional, or loop, it will also be local to that block.

Splinter<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

- list. This means that if the list is of type X list, the indexing operation will return

- type X.

- •  A binary operator. These consist of the operator with an appropriately typed expression on either side of it, as

- operands.

- o

The following operators take two int operands and return an int value:

“+” Adds the two operands

“-” subtracts the right operand from the left operand

“*” multiplies the two operands

“/” divides the left operand by the right operand

“&” performs a bitwise-and operation on the two operands

“|” performs a bitwise-or operation on the two operands

“^” performs a bitwise-xor operation on the two operands

- o

- o

- o

The  following  operators  are  comparison  operators  which  take  either  two  int  operands,  or  two  booloperands, and return a bool:

“==” returns true if the two operands are equal

“!=”, “<>” are both equivalent, and are the negation of the equality (“==”) operator

The following are comparison operators which will only take two ints, and return a bool:

“<” returns true if the left operand is less than the right operand

“>”  returns  true  if  the  right  operand  is  less  than  the  left  operand.  Note  that  this  is  evaluatedexactly as the “<” operator but with the left and right operands swapped.

“<=” returns true if the left operand is less than or equal to the right operand.

“>=” returns true if the right operand is less than or equal to the left operand. Like with the “<”and “>” operators, this operator is equivalent to “<=”, with the operator order swapped.The following are boolean operators which take two bools, and return bool:

!

!

“&&” returns logical-and of the operands.

“||” returns logical-or of the operands.

!

!

!

!

!

!

!

!

!

!

!

!

!

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

- •

- A prefix unary operator. These consist of the operator, followed by an expression which will form its operand.

- o

- o

“!” is logical-not, which returns the negation of its operand. It takes a bool, and returns a bool.“-” is unary-minus, which is equivalent to subtracting its operand from 0. It takes an int and returns anint.

<table align="center">
	<tr align="center">
		<td rowspan=2>int. The length of a list is initialised as how ever many elements are in the  literal  which  created  it,  or  it  may  have  been  expanded  by assignments.  For  example  after  running  "int  list  foo  =  [1]; foo[1] = 5;”, #foo will evaluate to 2.</td>
		<td colspan=3 rowspan=2> !false -5 #foo </td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>int. The length of a list is initialised as how ever many elements are in the  literal  which  created  it,  or  it  may  have  been  expanded  by assignments.  For  example  after  running  "int  list  foo  =  [1]; foo[1] = 5;”, #foo will evaluate to 2.</td>
		<td colspan=3 rowspan=2> !false -5 #foo </td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>int. The length of a list is initialised as how ever many elements are in the  literal  which  created  it,  or  it  may  have  been  expanded  by assignments.  For  example  after  running  "int  list  foo  =  [1]; foo[1] = 5;”, #foo will evaluate to 2.</td>
		<td rowspan=2> !false -5 #foo </td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>inner  expression,  but  allows  for  operations  to  be  performed  against  the  standard order of operations.</td>
		<td rowspan=2>// evaluates to 8 (3 + 1) * 2 // evaluates to 5 3 + (1 * 2)</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td colspan=2 rowspan=2>inner  expression,  but  allows  for  operations  to  be  performed  against  the  standard order of operations.</td>
		<td colspan=2 rowspan=2>// evaluates to 8 (3 + 1) * 2 // evaluates to 5 3 + (1 * 2)</td>
	</tr>
	<tr align="center">
		<td colspan=2>(3 + 1) * 2 // evaluates to 5 3 + (1 * 2)</td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td colspan=2 rowspan=2>inner  expression,  but  allows  for  operations  to  be  performed  against  the  standard order of operations.</td>
		<td colspan=2 rowspan=2>// evaluates to 8 (3 + 1) * 2 // evaluates to 5 3 + (1 * 2)</td>
	</tr>
	<tr align="center">
		<td colspan=2>(3 + 1) * 2 // evaluates to 5 3 + (1 * 2)</td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>an  equals  sign,  and  an  expression  which  evaluates  to  the  same type  as  the  left-hand-side.  This  will  overwrite  the  value  of  the variable  with  the  value  of  the  right-hand-side  expression.  In addition to a direct assignment, certain operators may be used to perform  arithmetic  operations  directly  on  variables.  These  are simply syntactic sugar and are processed exactly the same as the corresponding operator, and an assignment.</td>
		<td rowspan=2>foo = 5; // equivalent to “foo = foo + 5” foo += 5; // equivalent to “foo = foo - 2” foo -= 2; // equivalent to “foo = foo * 3” foo *= 3; // equivalent to “foo = foo / 2” foo /= 2;</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>an  equals  sign,  and  an  expression  which  evaluates  to  the  same type  as  the  left-hand-side.  This  will  overwrite  the  value  of  the variable  with  the  value  of  the  right-hand-side  expression.  In addition to a direct assignment, certain operators may be used to perform  arithmetic  operations  directly  on  variables.  These  are simply syntactic sugar and are processed exactly the same as the corresponding operator, and an assignment.</td>
		<td colspan=3 rowspan=2>foo = 5; // equivalent to “foo = foo + 5” foo += 5; // equivalent to “foo = foo - 2” foo -= 2; // equivalent to “foo = foo * 3” foo *= 3; // equivalent to “foo = foo / 2” foo /= 2;</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>an  equals  sign,  and  an  expression  which  evaluates  to  the  same type  as  the  left-hand-side.  This  will  overwrite  the  value  of  the variable  with  the  value  of  the  right-hand-side  expression.  In addition to a direct assignment, certain operators may be used to perform  arithmetic  operations  directly  on  variables.  These  are simply syntactic sugar and are processed exactly the same as the corresponding operator, and an assignment.</td>
		<td colspan=3 rowspan=2>foo = 5; // equivalent to “foo = foo + 5” foo += 5; // equivalent to “foo = foo - 2” foo -= 2; // equivalent to “foo = foo * 3” foo *= 3; // equivalent to “foo = foo / 2” foo /= 2;</td>
	</tr>
	<tr align="center">
	</tr>
</table>

Splinter<table align="center">
	<tr align="center">
		<td rowspan=2>followed  by  a  series  of  expressions  inside  braces.  Optionally,  this  may  be followed by an “else” keyword, and another block of expressions enclosed in braces. If this “else” block is absent, it is treated as if, it is present, but empty. If the boolean expression following the “if” keyword returns true, the first block of code is run, otherwise, the second block is run.</td>
		<td colspan=3 rowspan=2>if ( true ) { foo = 4; } else { foo = 2; }; if ( bar ) { foo *= 2; };</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>followed  by  a  series  of  expressions  inside  braces.  Optionally,  this  may  be followed by an “else” keyword, and another block of expressions enclosed in braces. If this “else” block is absent, it is treated as if, it is present, but empty. If the boolean expression following the “if” keyword returns true, the first block of code is run, otherwise, the second block is run.</td>
		<td colspan=3 rowspan=2>if ( true ) { foo = 4; } else { foo = 2; }; if ( bar ) { foo *= 2; };</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>followed  by  a  series  of  expressions  inside  braces.  Optionally,  this  may  be followed by an “else” keyword, and another block of expressions enclosed in braces. If this “else” block is absent, it is treated as if, it is present, but empty. If the boolean expression following the “if” keyword returns true, the first block of code is run, otherwise, the second block is run.</td>
		<td rowspan=2>if ( true ) { foo = 4; } else { foo = 2; }; if ( bar ) { foo *= 2; };</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>by  a  block  of  expressions  inside  braces,  much  like  in  the  if-statement described above. This will repeat the block of code zero or more times, until the boolean expression evaluates to false.</td>
		<td rowspan=2> i -= 1; };</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>by  a  block  of  expressions  inside  braces,  much  like  in  the  if-statement described above. This will repeat the block of code zero or more times, until the boolean expression evaluates to false.</td>
		<td colspan=3 rowspan=2> i -= 1; };</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=2>by  a  block  of  expressions  inside  braces,  much  like  in  the  if-statement described above. This will repeat the block of code zero or more times, until the boolean expression evaluates to false.</td>
		<td colspan=3 rowspan=2> i -= 1; };</td>
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td rowspan=3>enclosed  in  parentheses,  and  separated  by  semicolons,  followed  by  a block  of  expressions,  enclosed  in  braces.  The  three  expressions  in  the parentheses  are  the  initialisation,  condition,  and  incrementation.  The initialisation is run once before starting the loop, the condition is used to test whether or not to continue looping, and the incrementation is run at the  end  of  each  loop,  before  re-testing  the  condition.  The  for  loop  is considered  syntatic  sugar  for  a  while-loop,  which  runs  the  initialisation before the loop, uses the for-loop's condition, and has the incrementation at the end of the while-loop's block of code. One quirk of this is that any variables declared inside the initialisation of the for-loop, remain in scope after the loop ends, while any variables declared inside the loop itself do not.</td>
		<td rowspan=3>/* Equivalent to: int i = 0; while ( i < #array ) { sum += array[i]; i += 1; }; */  for(int i=0;i<#array;i+=1){ sum += array[i]; }; </td>
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

- •  A function call, consisting of a function name, followed by a list of expressions to be given as parameters,

- separated by commas, and enclosed in parentheses. This will run the specified function, passing it the

- evaluated  values  of  the  parameter  expressions.  There  must  be  the  correct  number  of  parameters,  and

- they must all match the types declared in the function's definition. If the function expects no parameters,

- then  a  pair  of  empty  parentheses  must  follow  the  function  name.  Once  the  function  terminates,  the

- function call will evaluate to the value returned by the function. Note that function names must start with

- an upper case letter.

<table align="center">
	<tr align="center">
		<td>int bar = Foo( 2, false );</td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td>int bar = Foo( 2, false );</td>
	</tr>
</table>

- The language ignores any whitespace in the form of spaces, tabs, newlines, and carriage returns. And allows

- either line comments starting with a “//”, or block comments starting with “/*” and ending with “*/”.

- Type Checking

- Prior to any executing taking place, the whole program is type-checked, ensuring that anywhere where specific types

- are expected, eg. operands, parameters, return statements, output statements, etc. all evaluate to the correct type.

- During  type-checking,  the  interpreter  also  ensures  that  no  variables  are  assigned  to,  or  read  from,  prior  to  being

- declared.

- Turing Completeness

- This language is Turing complete. To prove this, find, in the appendices, a Turing machine simulator written

- in the language.

- Appendix

- Errors

Splinter<table align="center">
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

Splinter<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

Splinter<table align="center">
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
		<td></td>
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

Splinter<table align="center">
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
	<tr align="center">
	</tr>
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

<table align="center">
	<tr align="center">
	</tr>
</table>

<table align="center">
</table>

- Turing Machine Simulator

- In order to prove that the language is Turing complete, below is a Turing machine simulator, written in the

- language.

(1 for right, -1 for left)

- // list of state transitions such that:

- // transition[x][y] contains the value after reading symbol y in state x

- // transitionState holds the new state id,

- // transitionDirection holds the direction in which the tape head will

- move

- //

- // transitionSymbol holds the symbol which will replace the current symbol

- on the tape

- int list list transitionState = [];

- int list list transitionDirection = [];

- int list list transitionSymbol = [];

- // the tape starts at index 0 at the left hand side, and continues right

- "infinitely"

- // (up to 2^31-1)

- int list tape = [];

- // used when constructing states

- int currentState = -1;

- void Init() {};

- // Loop will read in the definition of the turing machine, and the initial

- tape state

- // The first stream will contain instructions,

- // while the second, third, fourth, and fifth streams will contain

- arguments to those

- // instructions

- void Loop( int list input ) {

int instruction = input[0];

// instruction 1 - select current state

// second stream contains stateId,

// other streams ignored

if ( instruction == 1 ) {

};

// instruction 2 - define a transition from the current state

// second stream will hold the symbol being read from the tape

currentState = input[1];

transitionState[currentState] = [];

transitionDirection[currentState] = [];

transitionSymbol[currentState] = [];

return;

tape[#tape] = input[1];

return;

int symbolRead = input[1];

transitionState[currentState][symbolRead] = input[4];

transitionDirection[currentState][symbolRead] = input[3];

transitionSymbol[currentState][symbolRead] = input[2];

return;

// third stream contains the new number to write into the current

//

// fourth stream contains direction in which the tapehead will

//

// fifth stream contains new stateId,

if ( instruction == 2 ) {

};

// instruction 3 - define a value on the tape

// second stream will hold the value to be written to the tape

// other streams ignored

if ( instruction == 3 ) {

};

- };

- // After we've read the whole input, we've assembled the turing machine,

- and can start

- // simulating it.

- void Final() {

- transition

- been

- };

// 0 is the final state

// 1 is the default state

int stateId = 1;

int tapePosition = 0;

// loop until the tm enters the final state

while ( stateId != 0 ) {

tape[tapePosition] = transitionSymbol[stateId][readSymbol];

// move the tape head left or right

tapePosition += transitionDirection[stateId][readSymbol];

// change state

stateId = transitionState[stateId][readSymbol];

// if the tape head has gone past the portion of tape which has// read the value at the current position on the tape

int readSymbol = tape[tapePosition];

// write to the tape according to the current state's

tape[#tape] = 0;

generated, initialise the new cell as empty (0)

//

while ( tapePosition >= #tape ) {

};

};

//now we've reached the final state, output the contents of the tapefor ( int i = 0; i < #tape; i += 1 ) {

};

output [ tape[i] ];

Splinterposition (before moving)

move (1 for right, -1 for left),

- As an example of what input the program should be given, below is the definition of a Turing machine which

- will output 1 (followed by some zeros as “empty” cells) if the given input of 1s and 2s is a palindrome, or 0

- otherwise.

- The below input initialises the tape as 1, 2, 1, and thus should output 1.

Splinter-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

-1

- Language BNF

- Below  is  the  grammar  of  the  language  defined  formally  in  BNF.  Note  that  this  BNF  does  not  include

- whitespace.

- <main> ::= <topLevelList> <eof>

- <eof> ::= "~" | eof

- <topLevelList> ::= <topLevelOperation> <topLevelList> |

- <topLevelOperation>

- <topLevelOperation> ::= <funcDef> ";" | <funcDef> | <varInit> ";"

- <funcDef> ::= <typeDec> <funcId> <funcDefParams> <funcDefBody>

- <typeDec> ::= "int" | "bool" | "void" | <typeDec> "list"

- <funcId> ::= <uppercaseLetter> | <uppercaseLetter> <identifierTail>

- <varId> ::= <lowercaseLetter> | <lowercaseLetter> <identifierTail>

- <uppercaseLetter> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I"

- | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" |

- "V" | "W" | "X" | "Y" | "Z"

- <lowercaseLetter> ::= "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i"

- | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" |

- "v" | "w" | "x" | "y" | "z"

- <digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

- <identifierTail> ::= <identifierCharacter> | <identifierCharacter>

- <identifierTail>

- <identifierCharacter> ::= <uppercaseLetter> | <lowercaseLetter> | <digit>

- | "_"

- <funcDefParams> ::= "(" <paramList> ")" | "(" ")"

- <paramList> ::= <funcParam> "," <paramList> | <funcParam>

- <funcParam> ::= <typeDec> <varId>

- <funcDefBody> ::= "{" <exprList> "}" | "{" "}"

- <exprList> ::= <expr> ";" <exprList> | <expr> | <expr> ";"

- <expr> ::= "return" <expr> | "return" | "output" <expr> | <literal> |

- <varInit> | <varId> | <varAssign> | <expr> "+" <expr> | <expr> "-" <expr>

- | <expr> "*" <expr> | <expr> "/" <expr> | <expr> "==" <expr> | <expr> "<"

- <expr> | <expr> ">" <expr> | <expr> "<=" <expr> | <expr> ">=" <expr> |

- <expr> "!=" <expr> | <expr> "<>" <expr> | <expr> "&&" <expr> | <expr> "||"

- <expr> | <expr> "&" <expr> | <expr> "|" <expr> | <expr> "^" <expr> | "-"

- <expr> | "!" <expr> | "#" <expr> | "(" <expr> ")" | <ifExpr> | <loopExpr>

- | <functionCall>

- <ifExpr> ::= "if" <expr> "{" <exprList> "}" | "if" <expr> "{" <exprList>

- "}" "else" "{" <exprList> "}"

- <loopExpr> ::= "while" <expr> "{" <exprList> "}" | "for" "(" <expr> ";"

- <expr> ";" <expr> ")" "{" <exprList> "}"

- <literal> ::= <intLit> | <boolLit> | "[" <arrayContents> "]" | "[" "]"

- <intLit> ::= <digit> | <digit> <intLit>

- <boolLit> ::= "true" | "false"

- <arrayContents> ::= <expr> | <expr> "," <arrayContents>

- <varInit> ::= <typeDec> <varId> "=" <expr>

- <varAssign> ::= <assignLhs> <assignmentOperator> <expr>

- <assignmentOperator> ::= "=" | "+=" | "-=" | "*=" | "/="

- <functionCall> ::= <funcId> "(" <functionCallParams> ")" | <funcId> "("

- ")"

- <functionCallParams> ::= <expr> | <functionCallParams> "," <expr>

Splinter