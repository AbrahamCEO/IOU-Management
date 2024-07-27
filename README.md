# IOU App

## Overview

The **IOU App** helps you manage personal debts and IOUs. It includes features for tracking amounts, payments, and statuses. Users can add, update, and view their IOUs and UOMes, manage currency preferences, and monitor transactions. The frontend is built with Flutter, and SQLite is used for local database management.

**Deployed Site:**

## Getting Started

### Prerequisites

- **Flutter SDK** installed on your machine.
- **SQLite** for local database management.

### Installation

1. **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd <repository-folder>
    ```

2. **Install Flutter dependencies:**

    ```bash
    flutter pub get
    ```

3. **Install additional dependencies:**

    Ensure you have the required plugins for SQLite and currency conversion in your `pubspec.yaml`.

### Running the Application

1. **Run the Flutter app:**

    ```bash
    flutter run
    ```

    This will start the app on the connected device or emulator.

## Features

- **Dashboard:** Overview of IOUs and UOMEs total amount and net balance and visual representation (pie chart.
- **UOMe Page:** Add, view, delete and update UOME items and manage item status.
- **IOU Page:** Add, view, delete and update UOME items and manage item status.
- **Currency Conversion:** Fetches up-to-date exchange rates from the Free Currency Conversion API.

## Usage

- **Add/Update UOMe:** Use the form to create or update UOME items and select status from the drop-down menu.
- **Add/Update IOU:** Use the form to create or update UOME items and select status from the drop-down menu.
- **Currency Settings:** Adjust currency preferences and view totals accordingly.

## Screenshots

1. **Dashboard**

![image](https://github.com/user-attachments/assets/1064996b-8f5a-48f6-a627-42c89ee3a583)

2. **UOMe Page**

![image](https://github.com/user-attachments/assets/2352534a-fbe9-413c-8f45-781cc65f7929)

3. **IOU Page**

![image](https://github.com/user-attachments/assets/bb32e9cb-791f-4839-aad3-43996932492e)

## Technologies Used

- **Frontend:**
  - Flutter
  - SQLite (for local database)

- **API Integration:**
  - Free Currency Conversion API
