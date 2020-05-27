package com.example.mle;

import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.drawerlayout.widget.DrawerLayout;

import com.example.database.DB;

import java.security.SignatureException;

public class Login extends AppCompatActivity {
    private DrawerLayout drawer;
    public static int UserId = 0;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);

        Button btnLogin = (Button) findViewById(R.id.btnLogin);
        TextView tvError = (TextView) findViewById(R.id.tvErrors);

        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EditText txtUsername = (EditText) findViewById(R.id.txtUsername);
                EditText txtPassword = (EditText) findViewById(R.id.txtPassword);

                String username = txtUsername.getText().toString();
                String password = txtPassword.getText().toString();

                DB.User u = new DB.User();
                try {
                    u = DB.User.CheckLogin(username, password);
                }
                catch (Exception ex) {
                    String emkd = ex.getMessage();
                }

                if(u.IsValid)
                {
                    Intent i = new Intent(Login.this, MainActivity.class);
                    UserId = u.Id;
                    i.putExtra("UserId", UserId);
                    startActivity(i);
                }
                else
                {
                    txtUsername.setText("");
                    txtPassword.setText("");
                    tvError.setVisibility(View.VISIBLE);
                }
            }
        });
    }
}
