package com.example.core;

import androidx.fragment.app.Fragment;

import com.example.database.DB;

import java.util.List;

public interface DataInterface {
    Fragment getFragment();
    void setData(List<DB.SubCategory> subCategories, DB.Marked marking);
}
