package com.example.mle;

import android.annotation.SuppressLint;
import android.os.Build;
import android.os.StrictMode;
import androidx.annotation.RequiresApi;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class DB {
    static String ip = "192.168.8.109", port = "1433", dbName = "MLE";

    @SuppressLint("NewApi")
    public static Connection ConnectToDB() {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        Connection connection = null;
        String ConnectionURL = null;
        try {
            Class.forName("net.sourceforge.jtds.jdbc.Driver");
            ConnectionURL = "jdbc:jtds:sqlserver://" + ip + ":" + port + ";databaseName=" + dbName;
            connection = DriverManager.getConnection(ConnectionURL, "zv", "zv");
        } catch (Exception ex) {
            String e = ex.getMessage();
        }
        return connection;
    }

    public static ResultSet ExecuteQuery(Connection c, String q){
        try {
            Statement st = c.createStatement();
            ResultSet rs = st.executeQuery(q);
            return rs;
        }
        catch (Exception ex){
            return null;
        }
    }

    public static class Example {
        public int Id;
        public String Content;
        public int CategoryId;

        @RequiresApi(api = Build.VERSION_CODES.O)
        public static List<Example> GetAllExamples() {
            List<Example> examples = new ArrayList<>();
            String q = "select * from Example";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if(rs != null) {
                    try {
                        while (rs.next()) {
                            Example e = new Example();
                            e.Id = Integer.parseInt(rs.getString("Id"));
                            e.Content = rs.getString("Content");
                            e.CategoryId = Integer.parseInt(rs.getString("CategoryId"));
                            examples.add(e);
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return examples;
        }

        public static Example GetExampleById(int id){
            Example e = new Example();
            String q = "select * from Example where Id = " + id;
            Connection c = ConnectToDB();
            if(c != null){
                ResultSet rs = ExecuteQuery(c,q);
                if(rs != null) {
                    try {
                        if (rs.next()) {
                            e.Id = Integer.parseInt(rs.getString("Id"));
                            e.Content = rs.getString("Content");
                            e.CategoryId = Integer.parseInt(rs.getString("CategoryId"));
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return e;
        }
    }

    public static class Category{
        public int Id;
        public String Name;
        public String Description;
        public boolean isActive;
    }

    public static class SubCategory{
        public int Id;
        public int CategoryId;
        public String Name;
        public boolean isActive;
        public String Color;
        public String Sentiment;

        public static List<SubCategory> GetSubCategoriesByExampleId(int ExampleId){
            int CategoryId = Example.GetExampleById(ExampleId).CategoryId;

            List<SubCategory> subCategories = new ArrayList<>();
            String q = "select * from Subcategory where CategoryId=" + CategoryId + " and isActive=1";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if(rs != null) {
                    try {
                        while (rs.next()) {
                            SubCategory e = new SubCategory();
                            e.Id = Integer.parseInt(rs.getString("Id"));
                            e.Color = rs.getString("Color");
                            e.Name = rs.getString("Name");
                            e.isActive = Boolean.parseBoolean(rs.getString("isActive"));
                            e.Sentiment = rs.getString("Sentiment");
                            e.CategoryId = Integer.parseInt(rs.getString("CategoryId"));
                            subCategories.add(e);
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return subCategories;
        }
    }
}
