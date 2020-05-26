package com.example.mle;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Build;
import android.os.StrictMode;

import androidx.annotation.RequiresApi;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Formatter;
import java.util.List;
import java.util.Locale;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class DB {
    static String ip = "192.168.8.109", port = "1433", dbName = "MLE", user = "zv", password = "zv";

    @SuppressLint("NewApi")
    public static Connection ConnectToDB() {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        Connection connection = null;
        String ConnectionURL = null;
        try {
            Class.forName("net.sourceforge.jtds.jdbc.Driver");
            ConnectionURL = "jdbc:jtds:sqlserver://" + ip + ":" + port + ";databaseName=" + dbName;
            connection = DriverManager.getConnection(ConnectionURL, user, password);
        } catch (Exception ex) {
            String e = ex.getMessage();
        }
        return connection;
    }

    public static ResultSet ExecuteQuery(Connection c, String q) {
        try {
            Statement st = c.createStatement();
            ResultSet rs = st.executeQuery(q);
            return rs;
        } catch (Exception ex) {
            return null;
        }
    }

    public static class Example {
        public int Id;
        public String Name;
        public String Content;
        public int CategoryId;
        public int ProjectId;
        public int StatusId;

        @RequiresApi(api = Build.VERSION_CODES.O)
        public static List<Example> GetAllExamples() {
            List<Example> examples = new ArrayList<>();
            String q = "select * from Example";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
                    try {
                        while (rs.next()) {
                            Example e = new Example();
                            e.Id = Integer.parseInt(rs.getString("Id"));
                            e.Name = rs.getString("Name");
                            e.Content = rs.getString("Content");
                            e.CategoryId = Integer.parseInt(rs.getString("CategoryId"));
                            e.ProjectId = Integer.parseInt(rs.getString("ProjectId"));
                            e.StatusId = Integer.parseInt(rs.getString("StatusId"));
                            examples.add(e);
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return examples;
        }

        public static Example GetExampleById(int id) {
            Example e = new Example();
            String q = "select * from Example where Id = " + id;
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
                    try {
                        if (rs.next()) {
                            e.Id = Integer.parseInt(rs.getString("Id"));
                            e.Name = rs.getString("Name");
                            e.Content = rs.getString("Content");
                            e.CategoryId = Integer.parseInt(rs.getString("CategoryId"));
                            e.ProjectId = Integer.parseInt(rs.getString("ProjectId"));
                            e.StatusId = Integer.parseInt(rs.getString("StatusId"));
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return e;
        }

        public static void FinishExample(int id) {
            Example e = GetExampleById(id);
            if (e.Id != 0) {
                String q = "update Example set StatusId=2 where Id=" + e.Id;
                Connection c = ConnectToDB();
                if (c != null) {
                    ResultSet rs = ExecuteQuery(c, q);
                }
            }
        }

        public int getExampleProjectId() {
            return ProjectId;
        }
    }

    public static class Category {
        public int Id;
        public String Name;
        public String Description;
        public boolean isActive;
    }

    public static class SubCategory {
        public int Id;
        public int CategoryId;
        public String Name;
        public boolean isActive;
        public String Color;
        public String Sentiment;

        public static List<SubCategory> GetSubCategoriesByExampleId(int ExampleId) {
            int CategoryId = Example.GetExampleById(ExampleId).CategoryId;

            List<SubCategory> subCategories = new ArrayList<>();
            String q = "select * from Subcategory where CategoryId=" + CategoryId + " and isActive=1";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
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

        public static String GetSubcategoryColor(int SubcategoryId) {
            String color = "";
            String q = "select * from Subcategory where Id=" + SubcategoryId + " and isActive=1";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
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

    public static class Marked {
        public int Id;
        public int ExampleId;
        public int SubcategoryId;
        public int SentenceId;
        public int EntityId;

        public static Marked GetMarkedEntity(int ExampleId, int SentenceId, int EntityId) {
            Marked e = new Marked();
            String q = "select * from Marked where ExampleId=" + ExampleId + " and SentenceId=" + SentenceId + " and EntityId=" + EntityId;
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
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

        public static void SaveMarkedEntity(Marked marking) {
            Marked m = GetMarkedEntity(marking.ExampleId, marking.SentenceId, marking.EntityId);
            if (m.Id != 0) {
                // update current
                String q = "update Marked set SubcategoryId=" + marking.SubcategoryId + " where Id=" + m.Id;
                Connection c = ConnectToDB();
                if (c != null) {
                    ResultSet rs = ExecuteQuery(c, q);
                }
            } else {
                // create new
                String q = "insert into Marked (ExampleId, SubcategoryId, SentenceId, EntityId) values (" + marking.ExampleId + "," + marking.SubcategoryId + "," + marking.SentenceId + "," + marking.EntityId + ")";
                Connection c = ConnectToDB();
                if (c != null) {
                    ResultSet rs = ExecuteQuery(c, q);
                }
            }
        }

        public static List<Marked> GetMarkedByExampleIds(String exampleIds) {
            List<Marked> markeds = new ArrayList<>();
            String q = "select * from Marked where ExampleId in (" + exampleIds + ")";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
                    try {
                        while (rs.next()) {
                            Marked m = new Marked();
                            m.Id = Integer.parseInt(rs.getString("Id"));
                            m.ExampleId = Integer.parseInt(rs.getString("ExampleId"));
                            m.SubcategoryId = Integer.parseInt(rs.getString("SubcategoryId"));

                            markeds.add(m);
                        }
                    } catch (Exception ex) {
                    }
                }
            }

            return markeds;
        }
    }

    public static class Project {
        public int Id;
        public String Name;

        public static List<Project> GetAllProjects() {


            List<Project> projects = new ArrayList<>();
            String q = "select * from Project";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
                    try {
                        while (rs.next()) {
                            Project p = new Project();
                            p.Id = Integer.parseInt(rs.getString("Id"));
                            p.Name = rs.getString("Name");

                            projects.add(p);
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return projects;
        }
    }

    public static class UserExample {
        public int UserId;
        public int ExampleId;

        public static List<UserExample> GetUserExamplesByUserId(int userId) {
            List<UserExample> userExamples = new ArrayList<>();
            String q = "select * from UserExample where UserId=" + userId;
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
                    try {
                        while (rs.next()) {
                            UserExample ue = new UserExample();
                            ue.UserId = Integer.parseInt(rs.getString("UserId"));
                            ue.ExampleId = Integer.parseInt(rs.getString("ExampleId"));

                            userExamples.add(ue);
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            return userExamples;
        }
    }

    public static class User {
        public int Id;
        public boolean IsValid;

        public static User CheckLogin(String username, String password) throws SignatureException {
            User u = new User();

            String q = "select * from [User] where Username='" + username + "' and [Password]='" + hashMac(password) + "' and IsActive=1";
            Connection c = ConnectToDB();
            if (c != null) {
                ResultSet rs = ExecuteQuery(c, q);
                if (rs != null) {
                    try {
                        if (rs.next()) {
                            u.Id = Integer.parseInt(rs.getString("Id"));
                            u.IsValid = true;
                        }
                    } catch (Exception ex) {
                    }
                }
            }

            return u;
        }

        public static String hashMac(String text) throws SignatureException {
            try {
                String key = "vmadfklMF45r423dsadbgfs15s";
                Key sk = new SecretKeySpec(key.getBytes(), HASH_ALGORITHM);
                Mac mac = Mac.getInstance(sk.getAlgorithm());
                mac.init(sk);
                final byte[] hmac = mac.doFinal(text.getBytes());
                return toHexString(hmac);
            } catch (NoSuchAlgorithmException e1) {
                throw new SignatureException("Error building signature; No algorithm in device " + HASH_ALGORITHM);
            } catch (InvalidKeyException e) {
                throw new SignatureException("Error building signature; Invalid key " + HASH_ALGORITHM);
            }
        }

        private static final String HASH_ALGORITHM = "HmacSHA256";

        public static String toHexString(byte[] bytes) {
            StringBuilder sb = new StringBuilder(bytes.length * 2);

            Formatter formatter = new Formatter(sb);
            for (byte b : bytes) {
                formatter.format("%02x", b);
            }

            return sb.toString();
        }
    }
}
