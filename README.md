#. Biblio - A Personal Library Catalogue
This is an app to maintain a personal library catalogue by searching the title via Google Books API.

# App Features
The following features are provided by this app
1. User authentication to maintain a personal library catalogue 
2. Look up book by Title and add the same to the library
3. See the list of books in the main page (My library screen)
4. Remove a title by swiping across a row in the my library view
5. Logout to protect privacy

# Implementation / Main View controllers:
1. LoginViewController - Maintains code for providing Login functionality and user authentication management via Firebase
2. SignUpViewController - Maintains code for signing up a new user to the app (Uses Firebase Authentication)
3. ForgotPasswordViewController - Maintains code for enabling user to email a password reset link via Firebase authentication
4. MyLibraryViewController - Subclass of Table view controller and maintains a list of Book titles that belong to the logged in user via CoreData
5. SearchBookViewController - Provides the ability to search for a title. User can input the title in the text field and click search. Queries GoogleBooks API under the hood to retrieve titles
6. SearchBookResultsViewController - Displays the search results in a collection view with the item being a book thumbnail (if no image thumbnail is available, a no image available icon is displayed)
7. BookDetailsViewController - Maintains the logic to view book details such as Image thumbnail, title and description as provided by the Google Books API. Also displays an Add to Library button which upon clicking adds the book to the library and takes them back to the MyLibraryViewController

# How to build/compile
1. git clone https://github.com/vedarths/bibliov2
2. pod init
3. pod install
4. Open the BiblioV2.xcworkspace file in Xcode, type the commands pod init choose a desired simulator device and click on the Run button which should bring up the Login screen.

# Requirements
Xcode 9.2
Swift 4.0

......

# License
This code may be used free of cost for a non-commercial purpose, provided the intended usage is notified to the owner via the below email address.

# App Flow:
1. Ability to login and signup to the app (Firebase authentication)
2. Ability to signup to use the app. <b>Please create a user before you use the app by clicking on the signup button.</b>
3. Once Logged in, we will land in the my library (table view controller) screen
4. There are options to add a book into my library by clicking the Search button in the bottom right hand section
5. By clicking Search you will be taken to a search screen where you can out in the book title and hit search
6. The search results page will be shown with matching book titles along with their thumbnail (Google Books API under the hood) in a collection view page
7. Clicking on a books thumbnail will open up a Book details view, where there will be an option to add the book to library
8. On clicking the "Add Book to Library", you will be taken back to the MyLibrary view, with the book tile populated in the table view controller.This will add the book to the user's library via Coredata objects.
9. There is an ability to logout of the app on the bottom section which will take us back to login / signup screen depending on where the journey started. 
10. There is an ability to remove book by clicking edit in the top right corner and swiping the table view cell row and clicking on the delete button.
Upon logging back in to the app, you should still be able to see the list of books that you added in the pervious session.

Note: The mylibrary screen will always be local to the user. For example. If user 1 has added 3 books with specific titles, this will never be shown to another user (user 2)
Each user will see only the books that have been added to thier library.

Any questions, please email vedarthsolutions@gmail.com


Thank you for trying the app.

