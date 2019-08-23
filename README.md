This is an app to maintain a personal library catalogue. The following functionalities are provided by this app
1. Ability to login and signup to the app (Firebase authentication)
2. Ability to signup to use the app. <b>Please create a user before you use the app by clicking on the signup button.</b>
3. Once Logged in, we will land in the my library (table view controller) screen
4. There are options to add a book into my library by clicking the + button on top right hand section
5. By clicking + you will be taken to a search screen where you can out in the book title and hit search
6. The search results page will be shown with matching book titles along with their thumbnail (Google Books API under the hood) in a collection view page
7. Clicking on a books thumbnail will open up a Book details view, where there will be an option to add the book to library
8. On clicking the "Add Book to Library", you will be taken back to the MyLibrary view, with the book tile populated in the table view controller.This will add the book to the user's library via Coredata objects.
9. There is an ability to logout of the app on the top left hand section which will take us back to login / signup screen depending on where the journey started. 
Upon logging back in to the app, you should still be able to see the list of books.

Note: The mylibrary screen will always be local to the user. For example. If user 1 has added 3 books with specific titles, this will never be shown to another user (user 2)
Each user will see only the books that have been added to thier library.

Any questions, please email vedarthsolutions@gmail.com

Thank you for trying the app.

