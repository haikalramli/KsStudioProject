# Deployment Guide: GitHub & Heroku

I have prepared your project locally (git initialized and files committed). Follow these exact steps to push your code and deploy it.

## Part 1: Push to GitHub

1.  **Create a New Repository on GitHub**
    *   Go to [github.com/new](https://github.com/new).
    *   Name it `KSStudio`.
    *   **Do NOT** initialize with README, .gitignore, or license (we already have them).
    *   Click **Create repository**.

2.  **Push Your Code**
    *   Copy the HTTPS URL of your new repo (e.g., `https://github.com/YOUR_USERNAME/KSStudio.git`).
    *   Run these commands in your terminal (replace the URL with yours):

    ```bash
    git remote add origin https://github.com/YOUR_USERNAME/KSStudio.git
    git branch -M master
    git push -u origin master
    ```

## Part 2: Deploy to Heroku

1.  **Create Helper App**
    *   Login to Heroku CLI (if not logged in):
        ```bash
        heroku login
        ```
    *   Create a new app:
        ```bash
        heroku create ks-studio-app
        ```
        *(If the name is taken, try a unique one like `ks-studio-yourname`)*

2.  **Add PostgreSQL Database**
    *   Provision the database (Essential-0 is the free/low-cost tier):
        ```bash
        heroku addons:create heroku-postgresql:essential-0
        ```

3.  **Deploy the Code**
    *   Push your code to Heroku:
        ```bash
        git push heroku master
        ```

4.  **Open the App**
    *   Once the build finishes, open it in your browser:
        ```bash
        heroku open
        ```

## Part 3: Database Setup on Heroku (One-Time Setup)

After deployment, your app is running but the database is empty. You need to verify the tables.

1.  **Connect to Heroku Database**
    ```bash
    heroku pg:psql
    ```

2.  **Run the Schema Script**
    *   Copy the contents of `database/KSStudio_Postgres.sql` and paste them into the Heroku SQL terminal to create your tables and insert sample data.
    *   Type `\q` to exit.

## Troubleshooting

- **Build Failures:** Check the `heroku logs --tail` to see error messages.
- **Application Error:** Ensure `JDBC_DATABASE_URL` is set (Heroku sets this automatically when you add Postgres).
