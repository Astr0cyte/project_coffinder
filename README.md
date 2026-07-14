# Project Coffinder, aka: BrewStreet!

- A 4 week project developing a coffee recommendation app for Ho Chi Minh City. Collaboration between HCMUT and Macquarie University students.

- Problem: How do you know which coffee shops are better than others? Google Reviews is an option, but we think we can improve the user experience.
    - What differentiates this app from Google Reviews?
    - "At a glance" categorical information about coffee shops - e.g., Is it air conditioned? Is it quiet? Are the staff friendly?
    - Interactivity with posts (e.g., saving posts from users)
    - A simpler and user interface.

## Google Docs: https://docs.google.com/document/d/1mA1S87TNb-0UzPttEff7rrWKtPnk7D7vlj9eSMlyy6U/edit?tab=t.0

## Guidelines for development

- Every contributor works on a **separate branch**.
    - -git checkout -b your-new-branch-name 
- PULL before you PUSH.
- ENSURE commit messages are CLEAR, so that we know what you’ve done.
- DO NOT approve pull requests on your own - we have to discuss as a team before merging it to main.
- DO NOT mess up git conflicts - that is: **do not delete or alter** someone else’s code without permission.
- No REBASE.

## Notable features to be implemented

### Login page
- Account management: login/signup system, forgot password/ resend verification.

### Home page
- Ability to filter posts.
- Bottom toolbar:
    #### User profile page - user
    - Account management: change password, ability to edit profile information.
    - Ability to **delete** posts.
    - Ability to **share** posts.

    #### Settings page
    - Translation from English to Vietnamese.
    - Light/dark mode toggle (PENDING - if we have time near end of project).

    #### Diary
    - Translations for coffee names and how to order them!
    - Saved coffee shops.
    - **View** saved posts.

### Coffee shop page
- Google maps api.
- Coffee shop details.
    - Address, name, tagline.
- Reviews for that coffee shop (where "that" refers to the coffee which has been clicked on).
- Important categories for that coffee shop.

### Review page
- Voting system, for notable features.
- Ability to **create** posts.
- Ability to **share** posts.
- Post CRUD confirmations.

### User profile page - other users
- Display post history.
- Follow and unfollow capabilities for users.
- Ability to **save** posts.

### Other features (not related to a single page)

- ***Theme***: For now, **light mode only** (we can implement dark mode later, if we have enough time).

