/*

    CC-BY-2019 James B. Wilson

 A magma lagnuage extension parser.

    1. Support for generics.
    2. Support for join of types.
    3. Support for typed function signatures.

*/


// LEXOR =====================================================
//============================================================
// Language tokens.
//============================================================

declare type MagmaToken;

__scan_until := function (stream, head, len, endings )
    start := head;
    while head le len and not stream[head] in endings do head +:= 1; end while;
    if head gt len then return stream, ""; else return stream[start..head], stream[(head+1)..len];
end function;

__WHITE_SPACE := { " ", "\t", "\r", "\n" };
__DELIMITERS := __WHITE_SPACE join { ":", ";", "," "(", ")", "{", "}" };

// DEV.  Magma's own Regexp is based on egrep, so it says. 
// but something is wrong, you can't for example get it to
// identify comments in the usual reg-exp
//
// Repexp( "/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/", stream );
//
// So I gave up trying to use, so this lexor is slow.
NextToken := function( stream )
    head := 1; len := #stream;

    if head gt len then return EOF; end if; // Exit when empty.
    
    // trim leading whitespace.
    while stream[head] in __WHITE_SPACE do head +:= 1; end while;

    // skip line commented code.
    isLineComment, comments, newstream := Regexp( "//.*\n(.*)", stream );
    if isComment then return NextToken(newstream); end if;

    // skip /*...*/ comments.  should be 1-liner with Regexp, see issue above.
    if stream[1..2] eq "/*" then 
        __scan_until 
        while head lt (len-2) and not stream[head..(head+2)] eq "*/" do
            head +:= 1;
        end while;
        if head gt len-2 then
            // technically a grammar error but I don't see the point
            return ERROR("File ended without close comment `*/`" );
        else
            return NextToken( stream[head..len]);
        end if;
    end if;

    // Token separators: white space, `:', `;' 
    __scan_until(stream, head, len, {" ", ":", ";", })
    isLineComment, comments, newstream := Regexp( "(.*) //.*\n(.*)", stream );

end function;



declare type Infix
declare attributes MagmaToken
//tokenize by white space.
__trim := func< str | Split( str, " \t\r\n" )>;


ParseLine := function( line )
    test, full, tokens := Regexp( line );
end function;

ParseFile := function( lines )
    
    tokens := Split( lines, " \t\r\n" );    // white space separated => new token.

    for token in tokens do

    end for;
end function;
