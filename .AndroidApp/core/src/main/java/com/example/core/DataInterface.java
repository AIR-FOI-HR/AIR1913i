package com.example.core;

import android.content.Context;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.fragment.app.Fragment;

import com.example.database.DB;

import java.util.List;

public interface DataInterface {
    void setContext (Context context, RelativeLayout rl);
    void setData(List<DB.SubCategory> subCategories, DB.Marked marking, int X, int Y);
    void checkVisibility(RelativeLayout rl);
}
