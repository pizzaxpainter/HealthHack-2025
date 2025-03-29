# MediTrack AI: Intelligent Medication Tracker

## NUS HealthHack 2025

**Authors:** Atul Parida, Kripashree S

## Overview

MediTrack AI is a smart medication tracking application developed for the NUS HealthHack 2025. Leveraging the power of Flutter for a cross-platform mobile experience and TensorFlow Lite for on-device AI processing, MediTrack AI aims to revolutionize how individuals manage and adhere to their medication schedules. The app provides AI-powered medicine identification, pill counting, and intelligent relation to other medicines and diseases, ensuring comprehensive medication management.

## Key Features

- **AI-Powered Medicine Identification:** Utilizes TensorFlow Lite models to identify medicines from images captured via the device's camera.
- **Automated Pill Counting:** AI algorithms count the number of pills in a container from an image, assisting users in tracking medication consumption and refills.
- **Intelligent Medication Relation:** Analyzes relationships between different medications and associated diseases, providing users with potential interactions and side effects.
- **Personalized Medication Schedules:** Allows users to create and manage medication schedules with reminders for timely adherence.
- **Comprehensive Medication Logging:** Maintains a detailed history of medication intake for insights and healthcare provider reference.
- **User-Friendly Interface:** Built with Flutter, ensuring a seamless experience across Android and iOS platforms.

## Tech Stack

- **Flutter:** Cross-platform mobile application framework.
- **TensorFlow Lite:** On-device AI processing for medicine identification and pill counting.
- **TFLite Models:** Custom-trained image recognition and object detection models optimized for mobile.
- **Dart:** Primary language for Flutter development.

## Dockerization

To ensure consistency and ease of deployment, the MediTrack AI application can be containerized using Docker.

### Docker Setup

1. **Install Docker:** Download and install Docker from the [official website](https://www.docker.com/get-started).
2. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-repo/meditrack-ai.git
   cd meditrack-ai
   ```
3. **Build the Docker Image:**
   ```sh
   docker build -t meditrack-ai .
   ```
4. **Run the Docker Container:**
   ```sh
   docker run -p 8080:8080 meditrack-ai
   ```
   The application will be accessible at `http://localhost:8080`.

## Running the Application (Without Docker)

1. **Install Flutter:** Follow the installation guide on the [Flutter website](https://flutter.dev/docs/get-started/install).
2. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-repo/meditrack-ai.git
   cd meditrack-ai
   ```
3. **Get Dependencies:**
   ```sh
   flutter pub get
   ```
4. **Connect a Device:** Connect an Android/iOS device or start an emulator.
5. **Run the Application:**
   ```sh
   flutter run
   ```
   This will install and run MediTrack AI on the connected device or emulator.

## NUS HealthHack 2025 - Hackathon Requirements

MediTrack AI aligns with the hackathon goals by tackling medication adherence and safety challenges through AI and user-friendly design.

- **Innovation:** AI-powered medicine identification and pill counting provide a novel approach.
- **Impact:** Improves medication adherence and reduces errors, enhancing patient outcomes.
- **Technical Feasibility:** Built with robust and scalable technologies for real-world deployment.
- **User Experience:** Intuitive interface with personalized features ensures ease of use.

## Future Enhancements

- **Integration with Wearable Devices:** For continuous medication intake monitoring.
- **Cloud Synchronization:** Secure storage and syncing of medication data across devices.
- **Telemedicine Integration:** Remote consultations with healthcare providers.
- **Advanced Analytics:** Personalized insights into medication patterns and health outcomes.

## Conclusion

MediTrack AI represents a significant advancement in medication management, offering a comprehensive and intelligent solution for individuals and healthcare providers. We are excited to present this application at the NUS HealthHack 2025 and contribute to the future of healthcare technology.
