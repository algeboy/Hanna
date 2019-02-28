# Hanna: Compilers

CC-BY-2019, James B. Wilson

If you want an idea to be known, you tell someone.  If you want it to spread, you let them retell it in their own words.  If your idea is an algorithm then you write it in a programming language.  To record an algorithm in new words you translate it with what is known as a _compiler_. Insofar as mathematics is interested in preserving proofs, the preservation and accurate translation of algorithms is essential.  Perhaps no better example exists than the following.

**Theorem.**
For a pair of positive integers  $n$ and $m$ there exists unique integers $m$ and $r$ satisfying
$$n=qm+r\quad 0\leq r<q.$$

This simple assertion is known ubiquitously as the **division algorithm** despite making not even one instruction to the reader.  This is because algorithms are found in proofs.  Indeed, if we put in the rigor to make clear definitions of _theorem_, _proof_, and  _algorithm_, then the _Curry-Howard Isomorphism_  asserts that **all** proofs are algorithms and _vice-versa_.  But we needn't take things to that extreme to make the point that algorithms record an enormous amount of mathematical argument and their content is critical to curate, adapt, and translate -- the work of compilers.  

---
So where do we start?  Compiler theory today is to computer science undergraduates what Cauchy's real analysis is to mathematics undergraduates: necessary, challenging, particular, and deeply instructive -- not just about the topic, but about the entire discipline.  So our one chapter will not do justice to the topic.  What we want is an appreciation of how to design a language to express algorithms and how to translate it to languages other have invented or some day might.  

We will stick to the mathematical context, creating a new language along side which I call **Hanna** in honor of Hanna Neumann who extensively researched algebra from a syntatic point of view which was deeply influential on this author's reasoning about computing with algebra.  But this new language should not be seen as a "mathematical esperanto", but rather we encourage the reader to explore and invent new languages expressing the objectives of new domains.  

The choice of the word **domain** above is intentional.  When you find yourself in need of further support and reading material searching the vast literature on compilers may be too much.  Concentrate on the subset related to **Domain Specific Languages**, or simply as "DSLs".  There are lots of tools available to get DSLs working with very little background. 

# Stages of a compiler

First thing to note is that a compiler translates one language `L` -- the _programming language_ into another `M` -- the _compiled language_.  If your language is vastly simpler than spoken language, you can describe this with three phases.
```
Lexer: Code in L -> Tokens
Parser: Tokens -> Trees
Compiler: Trees -> Code in M
```
Here we shall stick to this division of work.  It is enough to handle nearly all mathematical algorithms, including theorem provers.  That said, languages that can be grammatically decomposed in this way are limited.  Their grammars are known as _context free_,
and much has been written about this elsewhere and we will not need to deeply consider this formalism.

### **Lexer** (or Tokenizer).    
Here we lift of the page individual words or symbols and look up in a dictionary if any of them have special significance.   The name _lexer_ comes from latin _lex_, as in lexicon, another name for dictionary.  For example you write may write:
```
if x >< 0 then 5 / x
```  
The lexor could replace this with a list of terms of different data types.  E.g.
```
I <var=x> NEQ <const=0> => <const=541> DIV <var=x>
```
This is somewhat misleading because a piece of data is not stored as letters any more.  So our second box of symbols is actually a printout of the tokens we assigned to each word in the original and one could ask why not just print them the same way we read them, i.e. why don't we see the same sentence identically?

Part of the answer is that it is the job of the lexer to begin ignoring certain characters, such as extra tabs, spaces, and comments.  Those help the programmer but the compiler will not need them. 
We also might begin to insert machine abreviations for text, e.g. a long variable name might be replaced with a sequence of unused characters that is much shorter but looks completely unreadable to a person.  These products are called **tokens**, and hence this stage is also be called a **tokenizer**. Because of these adaptations a lexer is not strictly bijective so printing out the token list cannot in general faithfully reproduce the input..

The most important role of the lexer is that a programming language is a mixture of actual words in the programming language, e.g. `if`, `=`,`then`, and then many made up words such as `x` or `541`.  No language could be defined whose dictionary is any string of letters and yet we expect in programming that you can use any string of letters as a variable name, and any string of numbers as constants etc. So the lexer's role is to see these as possible additions to the language, while not in its dictionary, it will create tokens to request these be added.  In doing so it is playing a vital role of making one copy of the word to add, so that a variable that occurs in one place, if accepted to the language, will be replaced everywhere with the same meaning. This is a very different problem to the typical parsing of spoken language where madeup words are not easily accepted into a language.

Whether or not a variable or constant token is accepted into the lexicon of our language will depend ultimately on the grammar and compiler. For now the lexer's job is to make the place holders.  In our example above these are `<var=x>`, `<const=0>` and `<const=541>`. 

---

If reading closely a reader may begin to ask, if `lexer` is a function at all.  What is its codomain, given that it will now be also returning words not yet in the dictionary?  The answer is that inputs and outputs in programs are not sets -- most sets would be too large to express in a computer.  Instead they are types, an alternative to set theory developed by Russell-Whitehead and later extensively developed by Church and the community that followed him.  With a type it is not necessary to fortell all the possilbe terms of a type, but to give only the means to produce and judge if terms have that type.  It is clear then that lexer has a means to know if it wants to add a word to its temporary dictionary, so its output type is defined by a fixed set of words, togther with a production rule to inductively add new terms of this type.  Ultimately such type theory functions can be made into statements with sets as well, but the result can be somewhat meaningless.  As set the codomain of a lexer would become:
>The set of all words in the language together, union,  the set of all possible words. 

Leaving the the meaning of `lexer` as a function of types makes it clear that every word we add was used in a sentence that we will have to read.  This is far more controlled than a set description.

Later when we speak [Languages within Languages](#LanguagesWithinLanguages) we will notice there is further subtlies to consider.  For example, we sometimes want to keep the comments and throw out the rest!

## **Parser** 

Before exploring parsers let us pause for an exercise.  Search the web for images of diagrammed English sentences, and then also German, or your favorite language.  As you play around you should notice many are not trees.  Try diagramming:
>I worked and reworked this sentence.

If one observes the compound predict with one direct object, this diagram has a cycle.
```
       _worked_
     /          \
_I_/and           \__Sentence_
   \              /   \__this_
     \_reworked_/
```

Diagrams of sentences are a form of parsing the words according to the rules of grammar.  We here are relying one important assumption.

**Theorem.** Sentences in  context free grammar can be parsed into trees.

The purpose of this choice is that translating a parsed sentence is a walk on the graph.  A tree is special because there is a unique path between two points.  So the results of our walk are predictable.  The consequence is that languages of this sort are on the low end of _expressiveness_.  This is why reading a proof can be interesting while reading its equivalent as a program becomes dry.  The language itself squashes creative prose in favor of clarity.  Keep this tension in mind when designing a domain specific language for your own applications.  Any flexibility to express more with fewer words may lead to failing to understand the instructions when it comes to compiling.  This is why for example languages will introduce functions with special keywords, such as
```
function Square(x) ....
def square(x:Int):Int...
```
instead of the mathematically accepted $f(x)=...$ notation which requires context to properly assess if $f$ is a function or definition or the value of an output.  Adding keywords helps us define a grammar that cannot be misunderstood even without context.

**Remark.** Writers on compilers regularly assert without proof that context-free languages are high-level grammars capable of expressing not only programming, but English, German, and essentially all but the rarest dialects. To compel the reader to this view they offer point out a few rare dialects that escape this claim.  But the names of these dialects seem to change from author to author suggesting these are more apocryphal than scientific claims.  

Certainly the loop in the diagram above together with the theorem above points to the bigger problem which is that what one judges as the "rules of grammar" are difficult to compell in to simple descriptions and in one choice we might find loops whereas in another the same sentence might be parsed differently.  

In truth, the question of whether a spoken language is context-free should be settled by linguist, not computer scientist.  The general result is spoken language is rarely if ever as nice as programming languages. See _James Higginbotham_ "English Is Not a Context-Free Language", Linguistic Inquiry, Vol. 15, No. 2 (Spring, 1984), pp. 225-234.

### Parse trees

Let us begin with an illustration of the most agreed upon mathematical grammar. In US schools this is taught as _Please Excuse My Dear Aunt Sally_: a mnuemonic for parsing by Parenthesis, Exponents, Multiplication, Division, Addition, then Subtraction.  So for example:
$$9(x+y-2)^6$$
becomes the following labeled tree.
```
+--(x+y-2)^6--u=x+y-2 --- 2
| *    | comp      | -
9     u^6        x+y -- y
                  | +
                  x
```
What is happening here is we are parsing an expression into it parse tree according to some inductive principles.  If read a constant or variable we continue until we find an operator between them (with the caveot that $xy$ in mathematics abrevaites $x\cdot y$).
This production rule looks something like this.  The notation is known as _Backus Naur Form_. Each entry is a token or a formula from elsewhere in the grammar.  Notice we include tokens that where added to the lexicon as well including `<var>` and `<const>`.
These will be replaced with any token that acts as a variable or constant respectively.
```
<exp> := <const> * <const> 
```
This says one type of expression is to combine two constants by the multiplication operation `*`, e.g. `5*3`.  This will be parsed as
```
+--3
| *
5
```
We would like to also allow variables.  So we could use `|` which means "or"
```
<exp> := <const> * <const> | <var> * <const> | <const> * <var> | <var>*<var>
```
Now this grammar accepts $5*9$, $3*x$, $x*y$, and $x*4$.  With are math caps on we know we should factor.  When factoring a program, the accepted terminology is _refactor_.
```
<value> := <const> | <var>
<exp> := <value> * <value>
```
Likewise we expect to have several binary operations so lets add that.
```
<value> := <const> | <var>
<binop> := '^'' | '*'' | '/' | '+' | '-'
<exp> := <value> <binop> <value>
```
We have now declared that expressions include are any binary operation from $\{\hat{}, *,/,+,-\}$.  What is more we can see the evolving tree structure.  If we have an expression then it has three children, the value on the left, the binary operation in the middle, and the value on the right.  So far all these three are terminal so we would only get a rooted tree with 3 leaves.  So now we add induction to this process.
```
<value> := <const> | <var>
<binop> := '^'' | '*'' | '/' | '+' | '-'
<exp> := <value> 
      | <exp> <binop> <exp>
```
This is the simplest interpretation but it looses some expressiveness.  Notice for example that $9\cdot x+5$ is not accepted because at the outset this is `<const><binop><var><binop><const>`.  We could insist that one write $(9\cdot x)-5$ and then add to our grammar the use of parenthesis.
```
<value> := <const> | <var>
<binop> := '^'' | '*'' | '/' | '+' | '-'
<exp> := <value> 
      | <value> <binop> <value>
      | <value> <binop> (<exp>)
      | (<exp>) <binop> <value>
      | (<exp>) <binop> (<exp>)
```
An even better option is to make our grammar support the order of operations rules.
```
<value> := <const> | <var>
<exp> := 
      | <exp> ^ <exp>
      | <exp> * <exp>
      | <exp> / <exp>
      | <exp> + <exp>
      | <exp> - <exp>
      | <value>
```
In fact implicit within reading this grammar in BNF is a grammar of its own, one which says we read from left to right and top to bottom.  So the implication is that when our parser reads $9\cdot x-5$ it first encounters the token `<const=9>` which it finds is a `<value>`.  The next token `*` is found in `<exp>` but will not be a match until the rest is judged to be an exprssion.  The next token `<var=x>` matches a value and therefore also an expresion so indeed at this point the parser has turned the token stream
```
<const=9> * <var=x>
```
into an expression `<exp>`.  Now it keeps reading and findes `-` which makes it a partial match to the last row of `<exp>` so it continues till it makes a match with the final expression token `<const=5>`.  So in the end 
$9\cdot x-5$ becomes the token lists
```
<const=9> * <var=x> - <const=5>
```
Which is accepted by recursive application of the `<exp>` rules:
```
<value1> = <const=9>
<exp1> = <value1>
<value2> = <var=x>
<exp2> = <value2>
<exp3> = <exp1> * <exp2>
<value3> = <const=5>
<exp4> = <value3>
<exp5> = <exp3> - <exp4>
```
Now try this with $5-9\cdot x$.  Here the tokens become
```
<const=5> - <const=9> * <var=x>
```
Why doesn't the parser see this as $5-9$?  The reason is our expression rule.  The parser continues as follows.
```
<value1> = <const=5>
<value2> = <const=9>
<value3> = <var=x>
<exp1> = <value2> * <value3>
<exp2> = <value1> - <exp1>
```
Why doesn'tThe fact that the parser does not stop when it sees $5-9$ and accept this is that the parser first must render `<const=9>` into an expression, not simply a value.

## Proposed Grammar

This is just a start, but one to get things going.  First some formalism.  I'll be designing a context free grammar (CFG), so that eventually I can parse it into (parse) trees.  I'll give the grammar here in Backus Naur Form (BNF).  Unfortunately, for me I'm writing the compiler in Magma so that it can be run by anyone wanting Hanna code in magma.  But Magma is somewhat limited as a language, no generics or templates.  So for my first stre

```
<var> := [A-z] | <var>;

<type> := Type                  // Primitive types
        | Any                   
        | Nothing
        | <var> : Type          // Type builders...
        | <type> -> <type>      // function type
        | <type> '*' <type>     // product of types
        | <type> '+' <type>     // sum of types
        | <type>^?              // Option monad
        | <type>[<var>*]        // Type with generics.
    

<func> := <var> : <type> -> <type> : <var> -> <exp>
        | def <name> (<var> : <type> ):<type> = <exp>
        

```

## Compiler

### Functions.

Acceptable function syntax

```
def f(x:Int):Int = x*x
```

```
f:Int->Int = x -> x*x
f:Int->Int:
  x->x*x
```
becomes
```
intrinsic f(x::RngIntElt) -> RngIntElt
{}
  return x*x;
end intrinsic;
```

### Implications

```
if bool then ... [else] ...
```
but wouldn't it be improved to suggest a greater use of implication over condition?  The point is that most things are not boolean, they become boolean as a mean to decide if formula $P(x)$ will imply formula $Q(x)$, but at the end of the day we want $P(x)\Rightarrow Q(x)$, and in type theory that is nothing but an inhabitant $f:P\rightarrow Q$.
```
A => B := f:A->B
```

```
if i < m  then list[i]
```
becomes
```
as:List[A] = ...
f:Int(<m)->A = i -> as[i]
```
With some type inference you could write
```
f = i < m -> list[i]
```
So this is stricly non-boolean, it is not even flow control.  You simply cannot evaluate $f$ outside the range of integer less than `m`. 

Implicitly though _cannot evaluate_ means what? You type $f(5)$ and you don't know $m$ until run time so you cannot compile time spot the problem. So you run out and try to caste $5$ into `Int(<m)$`somewhere it fails.  Failure becomes the user's **boolean side-effect**.  So what, they now need to manage this by catching errors?

To get flow control you could wrap it in a monad or a hetrogeneous type.
So perhaps
```
if P(x:A) then Q(x):B
```
should expand to
```
f:Any->B^? 
  = a:A(P(a)) -> Q(a)
  | None
```
### Types

I want a type theory behind what I write.  It helps, and its stepped in mathematics going back to Russell and Church.  It also naturally solves a problem what almost no sets will ever be encoded in a computer.  To that end the first features of the language are type constructors.

### Encapsulation

```
class C()
t = new C
```

### Languages within langauges.

>This chapter is important as it explains a nuasance in programming languages which really matters, but it might be something you skip on your first reading. You don't need to worry about these when designing a language but you might want to have them recognized by your compiler when you get to the stage of building testing and documentation tools.


Most programming languages eventually become a cross-bread of multiple interwined languages.  You might see commands inside documentation, or commands with special fonts/colors that simply look different. E.g. Comments these days are not entirely ignored by compilers.  

Starting in the 1990's with Javadoc, compiler designers realized they could help document software by having the compiler copy out sections of comments and compile those as well into supporting documentation.  These are traditionally flagged with `/** my very good description and examples */`. Soon entire programming languages were inserted into comments, often in internet friendly languages so that a website can host all the documentation. We will use Markdown with MathJax inside `/**...*/` blocks for just this purpose. E.g.
```
/**
 For $x\geq 0$ returns $\int_1^x \frac{dt}{t}$.
 Use `exp(x)` for the inverse.
 */
def ln(x:double):double = ...
```
When we run the documentation compiler on this it can produce:

---
```
ln:double -> double
```
 For $x\geq 0$ returns $\int_1^x \frac{dt}{t}$.
 Use `exp(x)` for the inverse.
 
---

Another language running through a programming language has to do with how we build code.  We want to turn parts on or off for testing for example.  These portions,  often called **annotation**, are usually one line and start with `#` or increasingly more common with `@` (clever hint at the name _annotation_).  For example you might write:
 ```
 #IFDEF __TEST_MODE__ // in annotation language
     SetVerbosePrinting();   // in your language
 #ENDIF               // back to annotation lingo
 ```

**IMPORTANT POINT** It is the job of you lexor to know how to ignore comments and annotations, but you may find you need several types of lexors, ones that target the comments to extract them, others which target annotations to enable them before trying to compile etc.  Keep this flexiblity in mind.  It is too difficult to get started with a lexor that correctly handles all those parts but when possible don't design your lexor in such a hard-wired way that you cannot later relax it a bit to include such features.
