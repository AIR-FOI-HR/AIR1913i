package com.example.core;

import android.content.Context;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.fragment.app.Fragment;

import com.example.database.DB;

import java.util.List;

public interface DataInterface {
    void setContext (Context context, RelativeLayout rl);
    void setData(int ExampleId, TextView name, List<DB.SubCategory> subCategories, DB.Marked marking, int X, int Y);
    void checkVisibility(RelativeLayout rl);
}
