package com.example.examplemarkingmodul;

import android.annotation.TargetApi;
import android.app.Fragment;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.example.core.DataInterface;
import com.example.database.DB;

import java.util.List;

import com.example.core.DataInterface;

@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class ExampleMarkingModule extends Fragment implements DataInterface{

    androidx.fragment.app.Fragment fragment;
    private List<DB.SubCategory> subCategories;
    private DB.Marked marking;
    private LinearLayout layout;

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    @Override
    public androidx.fragment.app.Fragment getFragment() {
        return null;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void setData(LinearLayout layout, List<DB.SubCategory> subCategories, DB.Marked marking) {
        this.subCategories = subCategories;
        this.marking = marking;
        this.layout = layout;

        ShowDialog(layout);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private void ShowDialog(final LinearLayout linear){

        // TODO
        //  Proslijediti fragment i dinamički kreirati linearlayout u kojem su gumbovi za klik

        linear.setVisibility(View.VISIBLE);

        for (int i = 0; i < subCategories.size(); i++) {

        }
    }
}
