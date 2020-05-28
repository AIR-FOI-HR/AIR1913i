package com.example.mle;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.appcompat.app.AppCompatActivity;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.example.core.DataInterface;
import com.example.database.DB;
import com.google.android.material.navigation.NavigationView;

import java.util.ArrayList;
import java.util.List;

import com.example.examplemarkingmodul.ExampleMarkingModule;

public class DataInterfaceManager {
    private static final DataInterfaceManager ourInstance = new DataInterfaceManager();

    DataInterface module;

    public static DataInterfaceManager getInstance() {
        return ourInstance;
    }

    public void startModule(RelativeLayout rl, Context context, List<DB.SubCategory> subCategories, final DB.Marked marking, int X, int Y) {
        module = new ExampleMarkingModule();
        module.setContext(context, rl);
        module.setData(subCategories, marking, X, Y);
    }

    public void checkVisibility(RelativeLayout rl){
        module = new ExampleMarkingModule();
        module.checkVisibility(rl);
    }
}
