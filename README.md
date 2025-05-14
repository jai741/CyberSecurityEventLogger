# Cybersecurity Event Logging System

A web-based system for logging and monitoring cybersecurity events, built with **MySQL** for database management, **Streamlit** for the web interface, and **Python** for backend processing.

## 🚀 **Setup Instructions**

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/jai741/CyberSecurityEventLogger.git
   ```

2. **Navigate to the Project Directory:**
   ```bash
   cd CyberSecurityEventLogger
   ```

3. **Install Required Packages:**
   Ensure you have Python installed and run:
   ```bash
   pip install streamlit mysql-connector-python pandas
   ```

4. **Import the Database Schema:**
   Open MySQL and import the `schema.sql` file:
   ```bash
   mysql -u root -p < schema.sql
   ```

   This will create the necessary database (`CyberSecurityLogs`), tables (`users`, `login_attempts`, `ip_blacklist`), trigger, and stored procedure.

5. **Configure Database Connection:**
   In `app.py`, ensure the MySQL connection parameters are correctly set:
   ```python
   connection = mysql.connector.connect(
       host='localhost',
       user='root',
       password='your_password',  # Replace with your MySQL password
       database='CyberSecurityLogs'
   )
   ```

6. **Run the Streamlit Application:**
   ```bash
   streamlit run app.py
   ```

7. **Open the Web Interface:**
   Open your browser and go to:
   ```
   http://localhost:8501
   ```

   You can now log cybersecurity events through the web interface.

## 🔥 **Features**

- **User Authentication:** 
  - Users are inserted into the `users` table if not already present.
  - Logins are recorded in `login_attempts` with their associated status (`SUCCESS` or `FAILED`).
  
- **IP Blacklisting:** 
  - The system automatically blacklists an IP address after 3 failed login attempts within 5 minutes.
  
- **Recent Logs:** 
  - The most recent login attempts are displayed in a table, showing user details and login status.

## 📑 **Database Schema**

- **Users Table:** Contains user information such as `Username`, `Email`, and `Role`.
- **Login Attempts Table:** Tracks login attempts with `Status` (Success or Failed), `IPAddress`, and `Timestamp`.
- **Blacklist Table:** Records IP addresses that have been blacklisted due to multiple failed login attempts.

## 🔧 **Trigger and Procedure**

- **Trigger:** Automatically blacklists an IP address after 3 failed login attempts within 5 minutes.
- **Stored Procedure:** Generates a weekly report for firewall breaches, unauthorized access, and blacklisted IPs.

## 🎨 **Screenshots**
Include screenshots or UI demos here if applicable (e.g., for the web interface, login page, or event logs display).

## 📝 **Future Enhancements**
- **Data Visualization:** Display trends of successful/failed login attempts over time.
- **Geolocation Mapping:** Show the geographic location of blacklisted IPs.
- **Advanced Alerts:** Integrate email/SMS alerts for blacklisted IPs or suspicious activities.

## 🧑‍💻 **Contributing**
Feel free to contribute to this project. Fork the repository and submit a pull request for improvements or new features!

## 📞 **Contact**
For any inquiries, please contact [your-email@example.com].

---

## 🔒 **License**
This project is licensed under the MIT License.
