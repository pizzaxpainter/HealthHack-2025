MediTrack AI: Intelligent Medication Tracker - NUS HealthHack 2025

Authors: Atul Parida, Kripashree S

Overview

MediTrack AI is a smart medication tracking application developed for the NUS HealthHack 2025. Leveraging the power of Flutter for a cross-platform mobile experience and TensorFlow Lite for on-device AI processing, MediTrack AI aims to revolutionize how individuals manage and adhere to their medication schedules. The app provides AI-powered medicine identification, pill counting, and intelligent relation to other medicines and diseases, ensuring comprehensive medication management.

Key Features

AI-Powered Medicine Identification: Utilizes TensorFlow Lite models to identify medicines from images captured via the device's camera. This feature helps users quickly and accurately log their medications, even without knowing the name.
Automated Pill Counting: Employs AI algorithms to count the number of pills in a container from an image, assisting users in tracking their medication consumption and refills.
Intelligent Medication Relation: Analyzes the relationships between different medications and associated diseases, providing users with potential interactions and side effects, promoting safer medication practices.
Personalized Medication Schedules: Allows users to create and manage personalized medication schedules with reminders, ensuring timely adherence to prescriptions.
Comprehensive Medication Logging: Maintains a detailed history of medication intake, providing valuable insights for users and healthcare providers.
User-Friendly Interface: Designed with Flutter, the app offers a seamless and intuitive user experience across both Android and iOS platforms.
Tech Stack

Flutter: Used for building the cross-platform mobile application, ensuring a smooth and responsive UI.
TensorFlow Lite: Deployed for on-device AI processing, enabling real-time medicine identification and pill counting without requiring an internet connection.
TFLite Models: Custom-trained models for image recognition and object detection, optimized for mobile devices.
Dart: The primary programming language for Flutter development.
Dockerization

To ensure consistency and ease of deployment, the MediTrack AI application can be containerized using Docker. This allows developers and users to run the application in a consistent environment, regardless of the underlying operating system.

Docker Setup

Install Docker: If you don't have Docker installed, download and install it from Docker's official website.

Clone the Repository: Clone the MediTrack AI repository from GitHub.

Build the Docker Image: Navigate to the root directory of the project and run the following command to build the Docker image:

docker build -t meditrack-ai .
Run the Docker Container: Once the image is built, run the following command to start the Docker container:

docker run -p 8080:8080 meditrack-ai
This will start the MediTrack AI application inside the Docker container, accessible via http://localhost:8080 in your web browser.

Running the Application (Without Docker)

Install Flutter: Ensure you have Flutter installed on your machine. Follow the installation guide on the official Flutter website.

Clone the Repository: Clone the MediTrack AI repository from GitHub.

Get Dependencies: Navigate to the project directory in your terminal and run:

flutter pub get
Connect a Device: Connect a physical Android or iOS device to your computer, or start an emulator.

Run the Application: Run the following command to start the application:

flutter run
This will install and run the MediTrack AI application on your connected device or emulator.

NUS HealthHack 2025 - Hackathon Requirements

MediTrack AI is designed to meet the requirements of the NUS HealthHack 2025 by providing an innovative solution to medication management. The application addresses the challenges of medication adherence, accuracy, and safety through the use of cutting-edge AI technology and a user-friendly interface.

Innovation: The AI-powered medicine identification and pill counting features offer a novel approach to medication tracking.
Impact: By improving medication adherence and reducing medication errors, MediTrack AI has the potential to significantly improve patient outcomes.
Technical Feasibility: The application is built using robust and scalable technologies, ensuring its feasibility for real-world deployment.
User Experience: The intuitive interface and personalized features make MediTrack AI easy to use and engaging for users of all ages.
Future Enhancements

Integration with Wearable Devices: To enable continuous monitoring of medication intake.
Cloud Synchronization: To securely store and synchronize medication data across multiple devices.
Telemedicine Integration: To facilitate remote consultations with healthcare providers.
Advanced Analytics: To provide users with personalized insights into their medication patterns and health outcomes.
Conclusion

MediTrack AI represents a significant advancement in medication management, offering a comprehensive and intelligent solution for individuals and healthcare providers. We are excited to present this application at the NUS HealthHack 2025 and contribute to the future of healthcare technology.
