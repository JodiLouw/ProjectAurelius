package org;
import org.example.DatabaseConnectionManagement;
import org.junit.jupiter.api.*;
import java.sql.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)

public class AureliusTesting
{
    private static Connection connection;

    @BeforeAll
    public static void setup()
    {
        connection = DatabaseConnectionManagement.getConnection();
    }

    @AfterAll
    public static void tearDown() throws SQLException
    {
        if(connection != null && !connection.isClosed())
        {
            connection.close();
        }
    }

    @Test
    public void customerCount() throws SQLException
    {
        String query = "SELECT COUNT(*) AS total FROM customertable";

        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query))
        {
            if(resultSet.next())
            {
                int totalCustomer = resultSet.getInt("total");
                assertEquals(2,totalCustomer,"Total number of customers should be 2");
            }
        }
    }


    @Test
    public void countAccount() throws SQLException
    {
        String customerName = "Sarah";

        String query = "SELECT COUNT(AccountNumber) AS numAccount FROM CustomerTable JOIN AccountTable ON CustomerTable.CustomerID = AccountTable.CustomerID WHERE CustomerTable.FirstName = '" +customerName +"'";

        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query))
        {
            if(resultSet.next())
            {
                int numAccount = resultSet.getInt("numAccount");
                assertEquals(2,numAccount,"Total number of accounts should be 2");
            }
        }
    }

    @Test
    public void totalTransactions() throws SQLException
    {
        String accountNumber = "3067104739007895";

        String query = "SELECT AccountNumber, SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE -Amount END) AS TotalTransaction FROM TransactionTable" +
                "WHERE AccountNumber = '" + accountNumber + "' GROUP BY AccountNumber";

        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query))
        {
            if(resultSet.next())
            {
                int TotalTransaction = resultSet.getInt("TotalTransaction");
                assertEquals(2,TotalTransaction,"The transaction total should be 0");
            }
        }

    }

}
