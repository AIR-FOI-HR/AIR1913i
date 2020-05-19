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

        public static String GetSubcategoryColor(int SubcategoryId){
            String color = "";
            String q = "select * from Subcategory where Id=" + SubcategoryId + " and isActive=1";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if(rs != null) {
                    try {
                        if (rs.next()) {
                            color = rs.getString("Color");
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return color;
        }
    }

    public static class Marked{
        public int Id;
        public int ExampleId;
        public int SubcategoryId;
        public int SentenceId;
        public int EntityId;

        public static Marked GetMarkedEntity(int ExampleId, int SentenceId, int EntityId){
            Marked e = new Marked();
            String q = "select * from Marked where ExampleId=" + ExampleId + " and SentenceId=" + SentenceId + " and EntityId=" + EntityId;
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if(rs != null) {
                    try {
                        if (rs.next()) {
                            e.Id = Integer.parseInt(rs.getString("Id"));
                            e.ExampleId = Integer.parseInt(rs.getString("ExampleId"));
                            e.SubcategoryId = Integer.parseInt(rs.getString("SubcategoryId"));
                            e.SentenceId = Integer.parseInt(rs.getString("SentenceId"));
                            e.EntityId = Integer.parseInt(rs.getString("EntityId"));
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return e;
        }

        public static void SaveMarkedEntity(Marked marking){
            Marked m = GetMarkedEntity(marking.ExampleId, marking.SentenceId, marking.EntityId);
            if(m.Id != 0){
                // update current
                String q = "update Marked set SubcategoryId=" + marking.SubcategoryId + " where Id=" + m.Id;
                Connection c = ConnectToDB();
                if(c != null){
                    ResultSet rs = ExecuteQuery(c, q);
                }
            }
            else{
                // create new
                String q = "insert into Marked (ExampleId, SubcategoryId, SentenceId, EntityId) values (" + marking.ExampleId + "," + marking.SubcategoryId + "," + marking.SentenceId + "," + marking.EntityId + ")";
                Connection c = ConnectToDB();
                if(c != null){
                    ResultSet rs = ExecuteQuery(c, q);
                }
            }
        }
    }
}
