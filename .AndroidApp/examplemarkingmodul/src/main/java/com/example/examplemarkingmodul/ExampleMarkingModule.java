package com.example.examplemarkingmodul;

import android.annotation.TargetApi;
import android.app.Fragment;
import android.os.Build;

import com.example.core.DataInterface;

import java.util.List;

@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class ExampleMarkingModule extends Fragment implements DataInterface{
    @Override
    public androidx.fragment.app.Fragment getFragment() {
        return null;
    }

    @Override
    public void setData(List<com.example.database.DB.SubCategory> subCategories, com.example.database.DB.Marked marking) {

    }
}
