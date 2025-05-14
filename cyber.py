import streamlit as st
import mysql.connector
import pandas as pd

# MySQL Connection
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='#####password',   # Replace with your MySQL root password
    database='CyberSecurityLogs'
)
cursor = connection.cursor()

# Page Title
st.title("🔒 Cybersecurity Event Logging System")

# Form for Data Entry
st.subheader("Enter Event Details")
with st.form(key='event_form'):
    username = st.text_input("Username")
    email = st.text_input("Email")
    role = st.selectbox("Role", ["Administrator", "User", "Guest"])
    ip_address = st.text_input("IP Address")
    status = st.selectbox("Login Status", ["SUCCESS", "FAILED"])
    submit_button = st.form_submit_button(label='Submit')

    if submit_button:
        # Insert User if not exists
        cursor.execute(f"INSERT IGNORE INTO users (Username, Email, Role) VALUES (%s, %s, %s)", 
                       (username, email, role))
        connection.commit()
        
        # Get UserID
        cursor.execute("SELECT UserID FROM users WHERE Username=%s", (username,))
        user_id = cursor.fetchone()[0]
        
        # Insert into login_attempts
        cursor.execute("INSERT INTO login_attempts (UserID, Status, IPAddress) VALUES (%s, %s, %s)", 
                       (user_id, status, ip_address))
        connection.commit()
        st.success(f"Event Logged Successfully for {username}!")

# Display Recent Logs
st.subheader("🔍 Recent Login Attempts")
query = """
    SELECT Username, Email, Role, Status, IPAddress, Timestamp 
    FROM login_attempts 
    JOIN users ON login_attempts.UserID = users.UserID 
    ORDER BY Timestamp DESC LIMIT 10
"""
data = pd.read_sql(query, connection)
st.dataframe(data)
