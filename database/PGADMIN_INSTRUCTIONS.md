# Setting up KSStudio Database in pgAdmin 4

Follow these steps to set up your local PostgreSQL database and import the schema.

## Prerequisites
- PostgreSQL installed/running (usually on port 5432).
- pgAdmin 4 installed.

## Step 1: Connect to Server
1. Open **pgAdmin 4**.
2. If this is your first time, you may need to add a server:
   - Right-click **Servers** > **Register** > **Server...**
   - **General** tab: Name it "Localhost".
   - **Connection** tab:
     - Host name/address: `localhost`
     - Port: `5432`
     - Maintenance database: `postgres`
     - Username: `postgres`
     - Password: (The password you set during installation).
   - Click **Save**.

## Step 2: Create the Database
1. Expand **Servers** > **Localhost** > **Databases**.
2. Right-click **Databases** > **Create** > **Database...**
3. **General** tab:
   - Database: `ksstudio`
4. Click **Save**.

## Step 3: Run the Schema Script
1. In the browser tree, click on the new `ksstudio` database to select it.
2. Click the **Query Tool** icon (looks like a database with a play button) in the top toolbar.
3. In the Query Tool:
   - Click the **Open File** icon (folder icon).
   - Navigate to your project folder: `Documents/KSStudioFull/database/`.
   - Select `KSStudio_Postgres.sql`.
   - Click **Select**.
4. The SQL code should appear in the editor.
5. Click the **Execute/Refresh** button (Play button icon) or press `F5`.
6. You should see "Query returned successfully" in the Messages tab.

## Step 4: Verify Setup
1. In the browser tree, right-click `ksstudio` and select **Refresh**.
2. Navigate to `Schemas` > `public` > `Tables`.
3. You should see tables like `photographer`, `client`, `booking`, etc.
4. Right-click `photographer` > **View/Edit Data** > **All Rows** to confirm sample data (like `Admin Senior`) exists.

## Step 5: Update Application Configuration
Ensure your `src/main/java/util/DBConnection.java` settings match your local setup:

```java
// Default fallback in DBConnection.java
String url = "jdbc:postgresql://localhost:5432/ksstudio";
String user = "postgres";
String password = "password"; // <--- CHANGE THIS TO YOUR PGADMIN PASSWORD
```

> [!IMPORTANT]
> If your local PostgreSQL password is NOT `password`, you must update `DBConnection.java` line 25 to match your actual password!
