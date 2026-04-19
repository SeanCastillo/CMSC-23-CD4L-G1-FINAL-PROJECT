# CMSC23: CD4L GROUP 1 FINAL PROJECT

## Milestone 1 Goals
1. Allow users to sign up, log in, and view/edit a profile with tags  
2. Work on UI and branding  

---

## Tentative Folder Structure

```
my_app/
  lib/
    models/
    screens/
      auth/
        login_screen.dart
        signup_screen.dart
      profile/
        profile_screen.dart
    widgets/
    services/
    main.dart
```

---

## Folder Descriptions

**models/**  
→ data structures (e.g., AppUser, later Item, etc.)

**screens/**  
→ full pages (login screen, profile screen)

**widgets/**  
→ reusable UI components (buttons, text fields, tag chips)

**services/**  
→ logic that talks to Firebase (auth, firestore, etc.)

**main.dart**  
→ app entry point, navigation, theme setup  

---

## Project Roles

**(1) auth**  
→ login screen / sign up screen / logout / connecting with Firebase Authentication  

**(2) profile**  
→ profile screen UI / showing user info / editing basic profile fields / interests and dietary tags UI  

**(3) branding and UI**  
→ app colors / logo placement / button styles / text field styles / app bar style / making shared widgets (if needed) / makes sure that the app looks consistent  

**(4) integration and project coordination**  
→ in charge of structure / responsible for combining the parts into one app / folder structure setup / defining user model / app navigation / testing  