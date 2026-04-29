# CMSC23: CD4L GROUP 1 FINAL PROJECT

## Milestone 1 Goals
1. Allow users to sign up, log in, and view/edit a profile with tags  
2. Work on UI and branding  

## Milestone 2 Goals
1. Implement Firestore CRUD for surplus items  
2. Enable profile editing with Firestore integration  

---

## Current + Upcoming Folder Structure

```
lib/
  models/
    user_model.dart
    item_model.dart        // (to be added for M2)

  screens/
    auth/
      login_screen.dart
      signup_screen.dart

    profile/
      profile_screen.dart

    pantry/                // (Milestone 2)
      create_item_screen.dart
      item_list_screen.dart
      edit_item_screen.dart

  widgets/                // reusable UI components (already refactored)

  services/
    auth_service.dart
    firestore_service.dart  // (to be added)

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


---

## Folder Descriptions

**models/**  
→ data structures (e.g., AppUser, Item)

**screens/**  
→ full pages (auth, profile, pantry-related screens)

**widgets/**  
→ reusable UI components (buttons, text fields, item cards, tag chips)

**services/**  
→ logic that talks to Firebase (auth, firestore, etc.)

**main.dart**  
→ app entry point, navigation, theme setup  

---

## Firestore Structure (Milestone 2)

```
items (collection)
  └── itemId
        title
        description
        ownerId
        imageUrl
        expirationDate
        status (available/reserved/completed)
        createdAt
```

---

## Project Roles

**(1) auth**  
→ login screen / sign up screen / logout / Firebase Authentication  

**(2) profile**  
→ profile UI / display user info / edit profile fields / dietary tags / Firestore integration  

**(3) pantry (CRUD)**  
→ create, read, update, delete surplus items / connect to Firestore  

**(4) branding and UI**  
→ app colors / logo / styles / reusable widgets / UI consistency  

**(5) integration and project coordination**  
→ structure / merge components / define models / navigation / testing  

---

## Notes for Milestone 2

- Focus first on **Create and Read (basic functionality)** before Update/Delete  
- Keep UI simple while implementing logic  
- Ensure consistent field names when working with Firestore  
- Coordinate before adding new fields to models or database structure  