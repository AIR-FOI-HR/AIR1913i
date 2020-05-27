package com.example.core;

import android.widget.LinearLayout;

import androidx.fragment.app.Fragment;

import com.example.database.DB;

import java.util.List;

public interface DataInterface {
    Fragment getFragment();
    void setData(LinearLayout layout, List<DB.SubCategory> subCategories, DB.Marked marking);
}
