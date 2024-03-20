Expense Tracker Flutter Application

This Flutter application serves as a comprehensive expense tracker, enabling users to efficiently
manage their spending habits. Below is an overview of the application's key features and
functionalities:

Features:
Add Expense:

1. On the first page, users can add expenses by entering the amount, date, and description, and then
   tapping the add button.
   View Expense List:

2. The second page displays a list of expenses, which can be sorted based on date range (from and to
   dates).
   Users can click on individual expense cards to edit or delete the item. Editing opens a dialog
   with fields for amount, date, and description.
   Summary:

3. The third page offers a summary view, allowing users to sort expenses by either monthly or weekly
   periods.
   When selecting monthly, the total monthly expenses are displayed; likewise, selecting weekly
   shows the total weekly expenses.
   Local Notifications:

4. The application utilizes local notifications to remind users of their pending expenses.
   Notifications are triggered at two-minute intervals.

Dependencies Used:

get: State management library for Flutter applications.

intl: Provides internationalization and localization utilities.

hive: Lightweight and fast NoSQL database for Flutter applications.

hive_flutter: Hive database integration with Flutter applications.

build_runner: Tools for generating code for JSON serialization and Hive adapters.

hive_generator: Code generation for Hive database adapters.

flutter_animate: Animation library for creating smooth and customizable animations.

lottie: Allows the use of Adobe After Effects animations in Flutter applications.

flutter_background_service_android: Facilitates background service implementation for Android.

flutter_background_service: Enables background service functionality in Flutter applications.

flutter_local_notifications: Plugin for displaying local notifications in Flutter applications.

permission_handler: Provides a cross-platform API to request and check permissions in Flutter
applications.

Local Storage:

The application utilizes Hive as its local storage solution, offering efficient data persistence for
managing expenses locally.