import java.sql.*;
import java.util.Scanner;

public class CustomerReport
{
    private static final String URL = "jdbc:mysql://localhost:3306/Aurelius";
    private static final String USER = "root";
    private static final String PASSWORD = "Ch@nt3ll3:P@55w0rd";

    public static void main(String[] args)
    {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Please Enter Your Customer ID");
        String customerID = scanner.nextLine();

        try
        {
            Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
            generateReports(connection, customerID);
            connection.close();
        } catch (SQLException e)
        {
            e.printStackTrace();
        }

        scanner.close();
    }

    private static void generateReports(Connection connection, String customerID) throws SQLException
    {
        printAddress(connection, customerID);
        printAccountBalance(connection, customerID);
        printTransactions(connection, customerID);
    }

    private static void printAddress(Connection connection, String customerID) throws SQLException
    {
        String query = "SELECT CONCAT(StreetNumber, '-', StreetName, '-', Area, '-', ZipCode, '-', Province) AS Address " +
                "FROM CustomerTable WHERE CustomerID = ?";
        try (PreparedStatement statement = connection.prepareStatement(query))
        {
            statement.setString(1, customerID);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
            {
                System.out.println("Address: " + resultSet.getString("Address"));
            } else
            {
                System.out.println("Sorry, no address was found for this Customer Identification: " + customerID);
            }
        }
    }

    private static void printAccountBalance(Connection connection, String customerID) throws SQLException
    {
        String query = "SELECT CurrentBalance, AccountNumber FROM AccountTable WHERE CustomerID = ?";
        try (PreparedStatement statement = connection.prepareStatement(query))
        {
            statement.setString(1, customerID);
            ResultSet resultSet = statement.executeQuery();
            System.out.println("Account Balances: ");
            while (resultSet.next())
            {
                System.out.println("Account Number: " + resultSet.getString("AccountNumber") + ", Balance: " +
                        resultSet.getBigDecimal("CurrentBalance"));
            }
        }
    }

    private static void printTransactions(Connection connection, String customerID) throws SQLException
    {
        String query = "SELECT AccountTable.CustomerID, TransactionTable.AccountNumber, TransactionDate, Amount, TransactionType " +
                "FROM AccountTable JOIN TransactionTable ON AccountTable.AccountNumber = TransactionTable.AccountNumber " +
                "WHERE AccountTable.CustomerID = ? AND AccountTable.AccountType = 'Checking'";
        try (PreparedStatement statement = connection.prepareStatement(query))
        {
            statement.setString(1, customerID);
            ResultSet resultSet = statement.executeQuery();
            System.out.println("Transactions");
            while (resultSet.next())
            {
                System.out.println("Account Number: " + resultSet.getString("AccountNumber") + ", Date: "
                        + resultSet.getDate("TransactionDate") + ", Amount: " + resultSet.getBigDecimal("Amount")
                        + ", Type: " + resultSet.getString("TransactionType"));
            }
        }
    }
}//end CustomerReport
