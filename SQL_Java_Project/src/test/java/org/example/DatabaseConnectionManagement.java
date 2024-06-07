package org.example;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DatabaseConnectionManagement
{
    private static final String URL = "jdbc:mysql://localhost:3306/Aurelius";
    private static final String USER = "root";
    private static final String PASSWORD = "Ch@nt3ll3:P@55w0rd";
    private static Connection connection;

    static
    {
        try
        {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
    }

    public static Connection getConnection()
    {
        return connection;
    }

}

