# Checkmate

> Checkmate is an intelligent task planner that helps you schedule your time based on what you actually complete rather than what you want to complete.

## Overview

This quarter (Winter 2020), I took a class called CS125: Next Generation Search Systems. It was my second project class at UC Irvine, and had the requirement of building a Search/Recommendation Engine during the last 8 weeks of the class. It was an ambitious timeline with the additional complexity of being required to be a Mobile application, something I have never developed end-to-end before.

Most students in the class decided to pursue building a health-oriented app that recommends exercises and foods to eat based on calorie intake and fitness goals but I wasn't super interested in projects involving food recommendation. After a few hours of brainstorming early in the quarter, I came up with the idea for an application that recommends tasks and recommended times for completion after complaining to a friend how I often plan my schedule around what I'd like to complete but don't actually end up completing 100% of the work I set out to do. This led me to come up with **Checkmate**, an intelligent task planner that helps you schedule your time based on what you actually complete rather than what you want to complete.

I partnered with two other students for building the project: Aubtin Samai and Andrew Nguyen

![https://user-images.githubusercontent.com/13127625/77372143-427c9d00-6d22-11ea-94e6-c6288841fdf7.png](https://user-images.githubusercontent.com/13127625/77372143-427c9d00-6d22-11ea-94e6-c6288841fdf7.png)

## Goals

With this project we needed to build a mobile app. Earlier last year my roommate raved about **Flutter** and it's ease of use, so we decided to utilize that to build a native app for both iOS and Android. I'll go over some of it's pros and cons later in the writeup.

Because I was taking CS178, Introduction to Machine Learning, this same quarter I wanted to utilize machine learning to help our recommendation system. The model would be used to classify tasks as "Likely to complete" or "Unlikely to complete" and used in our recommendations.

As always, a clean UI/UX is a plus! I think it's much more fun to make an app works well and looks good too.

Because this app would be used for scheduling, we wanted to integrate Google calendar to take in more information on current tasks and schedule our tasks in our Google calendar. The idea was to make it pretty hands free into integrating with what students already use to manage their time.

## Machine Learning

For our classification API, I wanted to build a system that could accurately classify if tasks would be completed or not. The idea was the API would request all the available times for the user (scanning other scheduled tasks and their google calendar), then take the features of the task scheduled at each of those times and classify them. We would filter out tasks that are unlikely to be completed, then use some more filtering to reduce the times to 2 "top" recommended times for a three day forecast.

To collect data before the app was built to test if our idea would work, I wrote a script that would generate random tasks and random times based on my current quarter schedule. For example it would generate a couple workout tasks at times throughout the day, and would only say I'd complete the ones on Mon/Weds/Fri mornings, which was true based on my current schedule. I collected around 400 data-points and trained some models. The features used were task type, time of day, and day of the week.

Because Machine Learning wasn't the focus of our app, I very quickly tried 3 models. Both Linear Regression and a LinearSVM scored around 55-65% accuracy. A KNN scored consistently a 80% accuracy on shuffled datasets, which made sense because a KNN would work well under circumstances where it implicitly makes groups in the data which was especially helpful for repetitive time scheduling week by week. 

## The App!

Below there are a few screenshots of the application. Tasks contained information regarding their task type, priority, task length, location, and of course a name and short description. All of these pieces of contextual information for each task was used with for our recommendation system. The idea is the user just uses the app as a simple task management system, but confirms wether or not they completed the task to better train our ML model.

The main three sections of the homepage are the task areas for Limbo Tasks, Scheduled Tasks, and Unscheduled Tasks. Limbo tasks are tasks that have technically "happened", but have yet to be confirmed as completed or not. Scheduled tasks are currently scheduled tasks sorted by time, with the closest time stating how far away it is based on the location of the task and the user's current location. Unscheduled tasks are a list of tasks sorted by priority, proximity to user, and length. This allows for a clean overview on what the easiest tasks and most important tasks to complete would be.

The best way to see how to functions and what it does is by watching our demo video [here](https://www.youtube.com/watch?v=Mt7tbNEvJaQ&t=111s).

## Screenshots

### Edit Task and Homepage

![https://user-images.githubusercontent.com/13127625/77372194-5de7a800-6d22-11ea-8405-33cf4184ce84.png](https://user-images.githubusercontent.com/13127625/77372194-5de7a800-6d22-11ea-8405-33cf4184ce84.png)

### Create Task + Recommended Times

![https://user-images.githubusercontent.com/13127625/77372224-735cd200-6d22-11ea-8166-d4397946c2e8.png](https://user-images.githubusercontent.com/13127625/77372224-735cd200-6d22-11ea-8166-d4397946c2e8.png)

### Google Calendar Integration

![https://user-images.githubusercontent.com/13127625/77372228-75269580-6d22-11ea-980b-ec5af4e562dc.png](https://user-images.githubusercontent.com/13127625/77372228-75269580-6d22-11ea-980b-ec5af4e562dc.png)
