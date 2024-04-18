# Viami Front
Welcome to Viami Front, the mobile application development project for both iOS and Android platforms. This project is aimed at developing an application called Viami that will be available in the App Store and Play Store. The application is being developed using Flutter, a UI toolkit from Google that allows for the creation of natively compiled applications for mobile, web, and desktop from a single codebase. Viami application is developed by me Tania Olivia and my colleague Nihel Ouanassi as part of our master's degree project. This flutter project serves as the frontend for the Viami application, which is designed to connect solo travelers and facilitate the discovery of activities in their destination countries.

### Description
Viami is an application aimed at solo travelers who seek to connect with other travelers and discover activities to do in their destination countries.

## Developers
- Tania Olivia
- Nihel Ouanassi

## Directory Structure

The project's directory structure is organized as follows:

1. `screens`: This directory contains all the screens of the application. Each screen has its own file.
2. `models`: This directory contains all the data models used in the application.
3. `models-api`: This directory contains all the API models used in the application.
4. `services`: This directory contains all the services used in the application. Services are used to handle API requests and business logic.
5. `widgets`: This directory contains all the custom widgets used in the application.
6. `components`: This directory contains all the reusable components used in the application.

## Payment Method

The payment method implemented in this application is In-App Purchase. This allows users to buy products directly within the mobile application. For the payment method while using the in-app purchase, we also use RevenueCat.

RevenueCat is a service that simplifies in-app purchase management for mobile applications. It provides a platform for developers to manage subscriptions, in-app purchases, and trials across multiple platforms. It also offers features such as analytics, user management, and revenue recognition.

In the `constant.dart` file inside the `lib` directory, there are `appleApiKey` and `googleApiKey` that need to be filled to test the in-app payment.

## Push Notifications

Firebase Cloud Messaging (FCM) is used for push notifications. FCM is a cross-platform messaging solution that allows for the sending of notifications to mobile and web applications. It provides a reliable and battery-efficient connection between the server and devices. This allows for the delivery of notifications to the application on both iOS and Android platforms.

Firebase is a mobile and web application development platform that provides a variety of services, including a real-time database, authentication, cloud storage, and hosting. Firebase Notifications is a service that allows for the sending of notifications to mobile and web applications. It is built on top of FCM and provides a simple and easy-to-use interface for sending notifications.

## Setup
1. **Clone the repository:** 
```bash
git clone https://github.com/taniaolivia/Viami-Front.git
```

2. **Navigate to the project directory:**
    cd Viami-Front
   
3. To set up the environment for the project, follow these steps:
    - Copy the `.env-example` file in the root directory of the project.
    - Rename the copied file to `.env`.
    - Fill in the necessary details in the `.env` file. These details will be used to configure the application.

## Running the Application

To run the application, use the following command in the terminal:

```bash
flutter run
```

This command will build and run the application on the connected device or emulator.

Please ensure that you have Flutter and Dart installed on your machine before running this command.

## Stopping the Application

To stop the application running you can just click "q" to quit.

## License

This project is licensed under the terms of the MIT license.

## Copyright

Copyright (c) 2023 Viami. All rights reserved.

## Contact

For any questions, feel free to reach out to the team members listed above.

## Note

Please note that contributions to this project are not allowed.
