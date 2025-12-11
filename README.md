# 🎓 TutorMe – Peer-to-Peer Academic Support Platform

## 📌 Project Overview
**TutorMe** is a Ruby on Rails–powered Software-as-a-Service (SaaS) platform designed to centralize peer-to-peer academic support.The system connects students seeking help with approved student tutors, facilitating the coordination of online session scheduling and post-session feedback.

The platform serves three distinct user groups—Learners, Tutors, and Admins—providing a robust user management system with distinct roles, permissions, and a modular architecture.

This project was developed for:
* **Course:** CS-UY 4513 – Software Engineering
* **Professor:** Dr. DePasquale
* **Semester:** Fall 2025

## 👥 Team Members & Contributions

* **Edward Kim** – User Authentication, Learner Session Management (View/Cancel), CI (SimpleCov).
* **Ivan Yeung** – Learner Booking Logic, Meeting Link Management.
* **Abdulrahman Albaoud** – Learner Feedback System, Admin Subject Management.
* **Remi Uy** – Tutor Availability Slots, Tutor Session Management (View/Cancel).
* **Alok Aenugu** – Tutor Application Submission, Admin Approval Workflows.
* **Alan Tong** – Attendance Tracking, Tutor Profile Management, Admin Approval Workflows.
* **Jungwoo Park** – Tutor Feedback Views, Admin Privilege Management.

## 🚀 Features

### User & Identity Management
* **Authentication:** Secure registration and login via email/password.
* **Roles:** Distinct permissions for Learners, Tutors, and Admins.
* **Tutor Applications:** Workflow for tutors to apply and Admins to approve/reject applications.

### Scheduling & Session Management
* **Availability:** Tutors publish available time slots with capacity limits.
* **Booking:** Learners browse availability and "instant-book" sessions (1:1 or group).
* **Attendance:** Tutors mark attendance after meetings to unlock feedback capabilities.
* **Cancellations:** Lifecycle management for Learners and Tutors to cancel upcoming sessions.

### Tutor & Subject Catalog
* **Browsing:** Learners can search for tutors by subject or course code.
* **Profiles:** Tutors manage their bios, qualifications, and meeting links.

### Feedback & Reporting
* **Ratings:** Learners submit ratings and comments only after attending a session.
* **Analytics:** Tutors can view their feedback summaries; Admins oversee system activity.

## 🛠️ Tech Stack
* **Language:** Ruby 3.4.7
* **Framework:** Ruby on Rails 8.1
* **Database:** PostgreSQL
* **Testing:** Cucumber, Capybara, RSpec

## 🏗️ Project Modules
The system is logically divided into the following modules:
1.  **User & Identity Management:** Authentication and role definitions.
2.  **Tutor & Subject Catalog:** Profiles, subjects, and availability visibility.
3.  **Scheduling & Session Management:** Booking logic, calendar updates, and meeting links.
4.  **Feedback & Reporting:** Post-session ratings and analytics.

## 📡 API & Routes Overview
The application exposes a RESTful interface for inter-module communication. Below are the key endpoints based on the implementation:

### 🔐 Authentication
* `POST /login` — Log in a user.
* `POST /learners` — Register a new learner account.
* `DELETE /logout` — End the current session.

### 📚 Tutors & Applications
* `GET /tutors` — List all tutors.
* `GET /tutors/:id` — View specific tutor profile.
* `POST /tutor_applications` — Submit a new application to become a tutor.
* `GET /admin/tutor_applications/pending` — Admin view of pending applications.
* `POST /admin/tutor_applications/:id/approve` — Admin approves a tutor.
* `POST /admin/tutor_applications/:id/reject` — Admin rejects a tutor.

### 📅 Sessions & Booking
* `GET /sessions/search` — Search for available tutor slots.
* `POST /sessions/:id/book` — Book a specific availability slot.
* `POST /sessions/:id/attendance` — Tutor marks attendance.
* `GET /learner_sessions` — View logged-in learner's upcoming/past sessions.
* `GET /tutor_sessions` — View logged-in tutor's schedule.
* `PATCH /learner_sessions/:id/confirm_cancel` — Learner cancels a booking.

### 💬 Feedback
* `POST /feedbacks` — Submit feedback for a completed session.
* `GET /tutor/feedbacks` — Tutors view their received feedback.

## ⚙️ Setup Instructions

These instructions will get a copy of the project up and running on your local machine.

### 1. Requirements
* **Ruby:** 3.4.7
* **Rails:** 8.1
* **PostgreSQL:** 14+

### 2. Clone Repository
```bash
git clone https://github.com/NYU-CSE-Software-Engineering/cs-uy-4513-f25-team2.git
cd cs-uy-4513-f25-team2/
```

### 3. Install Dependencies
```bash
bundle install
```

### 4. Setup the Database
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Run the server
```bash
rails server
```

## 🧪 Testing Instructions

The project uses RSpec for unit tests and Cucumber for acceptance tests.

### Run Unit & Request Tests (RSpec)

To verify models, booking rules, and API endpoints:

```bash
bundle exec rspec
```

### Run End-to-End Tests (Cucumber)

To verify full user journeys (e.g., A learner browsing, booking, and submitting feedback):

```bash
bundle exec cucumber
```

