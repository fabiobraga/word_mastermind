# Word Mastermind
Guesses the word in a 4 letter word Cows and Bulls game

## Description
The user chooses a word and the program tries to guess the word while the user gives the cows and bulls scores for each guess.

**Number of cows**: letters correct but in the wrong position

**Number of bulls**: letters correct in the right position

```
> ruby game.rb
Turn: 1 - Guess: BISK
Please, enter the number of bulls: 0
Please, enter the number of cows: 1
Turn: 2 - Guess: GULS
Please, enter the number of bulls: 1
Please, enter the number of cows: 0
Turn: 3 - Guess: CUBE
Please, enter the number of bulls: 2
Please, enter the number of cows: 1
Turn: 4 - Guess: TUBE
Please, enter the number of bulls: 1
Please, enter the number of cows: 1
Turn: 5 - Guess: JUBE
Please, enter the number of bulls: 1
Please, enter the number of cows: 1
Turn: 6 - Guess: LUBE
Please, enter the number of bulls: 1
Please, enter the number of cows: 1
Turn: 7 - Guess: CURB
Please, enter the number of bulls: 4
Game Over!
```

## Using custom dictionaries
You can customize the words available by informing a custom dictionary with the option `--dictionary`.

The custom dictionary should be a file with a word per line, and every single word should have the same size and no special characters, numbers or spaces.

If the words have a different size than the default of 4, you should also inform the number of characters with the option `--word-size` or `-w`.

```
> ruby game.rb --word-size 2 --dictionary data/custom.txt
```

## Additional information
To print some additional information during the game, like the ammount of words currently possible according to the scores provided by the user, you can use the option `--debug`

```
> ruby game.rb --debug
```
