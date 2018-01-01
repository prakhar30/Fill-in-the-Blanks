# Wikipedia Fill-in-the-Blanks

Wikipedia Fill-in-the-Blank is an iOS game developed to test the various features that the platform provides.
###### About the Game

The game fetches a random page from Wikipedia, from among the few given page links, and then hides 10 randomly selected words and replaces them with blanks in the format (___blank_number___). The user then has to guess the hidden words in the sentence. The user taps the blank to select a word for that blank from the list given. Then on the completion of the game the user gets his score and the right answers against the user selected choices.


### Tech

The game makes use of the following ideas, implemented in Swift 3, and xCode 8.2 - 
* [URLSession] - To call RESTful API to fetch data from Wikipedia
* [Arc4Random] - To generate a random number to select random words
* [UIButtons] - These buttons are placed over the randomly chosen words so that when the user taps one of them, the system knows where to replace which words.
* [textView text positioning] - These lines of code help us to determine the location of the randomly selected words so that we could place the invisible button over them.
* [UIPickerView] - This is used to display the hidden words to the user so that the user can select on of them for each location.
* [UITableView] - This table is used to show the user their score card along with their choices against the correct answers.

##### Installation
Simply clone or download the project and open it in xCode 8, Swift 3 to run the application.

Any feedbacks or suggestion for improvements are welcome. :) 

