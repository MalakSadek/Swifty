# Swifty
A Movie Trivia Quiz mobile application (2019)

🧠🎮 An Android and iOS trivia quiz mobile application written in **Swift, Java, PHP, and SQL**. It handles user accounts using Google's Firebase services and maintains a global leaderboard of scores (discussed below) originally using a **MySQL database** that is reached via **PHP scripts**, this was later migrated to **Google's NoSQL Firebase service**. The quizzes and questions are stored offline locally in **JSON files**.

There is also a scoring system for the quizzes. For every correct answer, the player earns 10 points, for every incorrect answer, they lose 10 points, and if the timer for the current question runs out, they lose 10 points. Players can have an overall negative score and there is a ranking system based on the number of points that they have.

The application allows users to sign up and create a profile, this is handled using Google’s Firebase authentication service. The quiz categories, topics, questions, and answers are stored in JSON file stored remotely on the mobile device when the application is downloaded. This offers quick access to all quiz content, however it means that an update for the application must be made every time new content is added.

It takes the form `{“Categories”: , “Topics:”, “Question n”: answers[ ]}`

There is also a scoring system for the quizzes. For every correct answer, the player earns 10 points, for every incorrect answer, they lose 10 points, and if the timer for the current question runs out, they lose 10 points. Players can have an overall negative score and there is a ranking system based on the number of points that they have. There is also a global leaderboard for all players, which is stored on a NoSQL database using Google’s Firestore database service.

Screenshots and videos can be found here: https://malaksadek.wordpress.com/2019/07/17/swifty-the-trivia-quiz-app/

# Download the App

The app is available on:
* The iOS App Store: https://apps.apple.com/us/app/swifty-the-trivia-quiz-app/id1473285474?ls=1
* The Google Play Store: https://apps.apple.com/us/app/swifty-the-trivia-quiz-app/id1473285474?ls=1

# Contact

* email: mfzs1@st-andrews.ac.uk
* LinkedIn: www.linkedin.com/in/malak-sadek-17aa65164/
* website: https://malaksadek.wordpress.com/
