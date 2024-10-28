# A1: Hearthstone Card Parser

Learning Outcomes
-----------------

1.  **Write** a Makefile to compile a simple C program.
2.  **Use** file stream functions to open and read files.
3.  **Create** a program that will parse file content for display.
4.  **Use** memory allocator functions.

Specifications
--------------

For this assignment, you will complete a program that parses a .csv file full of Hearthstone card data. It will also de-duplicate, sort and then nicely print out the cards.

### Stream I/O

You may use raw file streams for this assignment. Gone are the dark ages of having to deal with a too-tiny buffer!

### Array of Pointers to Structs

The data structure we want to use for this assignment is **a dynamic array of `CARD_T*`** or pointers to `CARD_T` structs. That means the data type of `cards` needs to be `CARD_T**`.

### Obtaining a Line from the File

I strongly recommend using the `getline()` function. It basically does everything for you, the trick is that you have to figure out how to call it properly. Don't forget to `free()` the memory allocated by the function before you exit the program or you will have a Valgrind error!

### Parsing the Line

A very difficult challenge in this assignment is parsing all of the fields effectively. Open the `hscards.csv` file in an actual spreadsheet program such as Excel or Numbers and observe which fields might be empty and which ones are never are. You can use this information to your advantage! Also note which characters may be present in which fields. For example: a comma could appear in the **card name** or **card text** fields, but never in the **card type** field. The hardest field to parse is the **card text** field because it could contain a comma _or escaped double quotes_. The strategy I recommend is to go to the end of the line and parse backwards to locate the end of the **card text** field. Another option is to parse through the field by detecting when there are _two double quote characters in a row_ and continuing to search for the ending double quote.

When it comes to assigning the values of the card fields that are enum types, you must still parse the text from the line but then decide which enum value to assign based on that token! A `strcmp()` can work, as well as other strategies. When this field is printed out, you do this process backwards, but lookup arrays have been provided for you. The reason we are doing this won't be immediately clear until we begin working on the next assignment that involves binary files.

### Text Replacement

The **card text** field also contains a number of issues that make it gross to read in terminal output. Let's fix that by replacing certain characters:

1.  `""` -> `"`
2.  `\\n` -> `\n`
3.  `</b>` **or** `</i>` -> `\e[0m`
4.  `<b>` -> `\e[1m`
5.  `<i>` -> `\e[3m`

The easiest change will be the third one. For one and two, you are replacing two characters with a single one, which means every character in front of the change to the end of the text field need to be moved back by one element! I recommend `memmove()` for this (can't use `memcpy()` now, since these areas would overlap). For four and five, the replacement will be even harder because you are replacing 3 characters with 4. This **requires a call to `realloc()`** in order to guaratee there is enough space in memory for this addition. And you will need to move all characters in front of this sequence forward by one element!

### Restrictions

*   You must compile your program using the flags `std=gnu11`, `-Werror` and `-Wall`.
*   You must implement the stubbed functions: `dupe_check()`, `fix_text()`, `free_card()`, `parse_card()`, `print_card()`

### Submission

**Submit only your completed `parser.c` file, `card.h` and associated `Makefile`.** When `make` is executed in the directory, a binary named `parser` should be created. If not, the autograder will fail. You can make a submission as many times as you'd like in order to see the autograder feedback. The maximum points you can receive from the autograder is 26.

### Functions

Here is a list of functions that are used by the solution program. This might help in completing the assignment.

*   `atoi()`
*   `dupe_check()`
*   `fclose()`
*   `find_compar()`
*   `fix_text()`
*   `fopen()`
*   `free()`
*   `free_card()`
*   `getline()`
*   `lfind()`
*   `main()`
*   `malloc()`
*   `parse_card()`
*   `print_card()`
*   `printf()`
*   `qsort()`
*   `realloc()`
*   `sort_compar()`
*   `strcmp()`
*   `strdup()`
*   `strlen()`
*   `strsep()`
*   `strstr()`

Example
-------

Here's sample out from a working program. ***Your program must not print out anything other than what's shown or the autograder will fail***. The `$` character represents the terminal prompt, you do not type this character when executing commands.

    $ ./parser hscards.csv
    A Light in the Darkness        2
    Spell       Paladin       Common
    --------------------------------
    [1mDiscover[0m a minion.
    Give it +1/+1.
    --------------------------------
    0                              0
    
    A New Challenger...            7
    Spell       Paladin         Epic
    --------------------------------
    [1mDiscover[0m a 6-Cost minion. Summon it with [1mTaunt[0m and [1mDivine Shield[0m.
    --------------------------------
    0                              0
    
    Aberrant Berserker             4
    Minion      Neutral       Common
    --------------------------------
    Has +2 Attack while damaged.
    --------------------------------
    3                              5
    
    Abominable Bowman              7
    Minion       Hunter         Epic
    --------------------------------
    [1mDeathrattle:[0m Summon
    a random friendly Beast
    that died this game.
    --------------------------------
    6                              7
    
    ... snip ...
    
    Zul'Drak Ritualist             4
    Minion      Neutral         Rare
    --------------------------------
    [1mTaunt[0m
     [1mBattlecry:[0m Summon three
    random 1-Cost minions
    for your opponent.
    --------------------------------
    3                              9
    
    Zul'jin                       10
    Hero         Hunter    Legendary
    --------------------------------
    [1mBattlecry:[0m Cast all spells
    you've played this game
    [3m(targets chosen randomly)[0m.
    --------------------------------
    0                             30
    
    Zzeraku the Warped             8
    Minion      Warlock    Legendary
    --------------------------------
    Whenever your hero
    takes damage, summon
    a 6/6 Nether Drake.
    --------------------------------
    4                             12

