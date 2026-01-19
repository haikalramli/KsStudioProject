# How to Connect to Heroku Database (Remote)

To view the data on the live Heroku website, you can connect your local **pgAdmin** to the Heroku database.

## 1. Credentials
Use these details to set up a new server in pgAdmin 4.

**Host name/address:** `c5cqb8h0eop3g3.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com`
**Port:** `5432`
**Maintenance database:** `d58b5cs4somcpc`
**Username:** `ufhn7se16osuj6`
**Password:** `p69bd018482454a370f9b7253894b200e9f6e67b6dc24d5c70755c2ddec909fc6`

## 2. Setting it up in pgAdmin
1. Open pgAdmin 4.
2. Right-click **Servers** > **Register** > **Server...**
3. In the **General** tab, name it: `KS Studio Heroku`
4. In the **Connection** tab, fill in the details above:
   - Copy **Host name/address** into Host name/address.
   - Copy **Maintenance database** into Maintenance database.
   - Copy **Username** into Username.
   - Copy **Password** into Password.
   - **Important:** Go to the **Parameters** tab (or "SSL" tab depending on version).
   - Set **SSL mode** to `Require` (This is mandatory for Heroku).
5. Click **Save**.

## 3. How the Java App Connects
You do **not** need to put these credentials in your local code.
Your `DBConnection.java` file is smart. It detects when it is running on Heroku:

```java
// DBConnection.java
String dbUrl = System.getenv("JDBC_DATABASE_URL"); // Heroku automatically sets this
if (dbUrl != null && !dbUrl.isEmpty()) {
    conn = DriverManager.getConnection(dbUrl); // Connects to Heroku DB
} else {
    // Connects to your Local DB (localhost)
}
```
This means your code works on **both** your laptop and Heroku without changing anything!
