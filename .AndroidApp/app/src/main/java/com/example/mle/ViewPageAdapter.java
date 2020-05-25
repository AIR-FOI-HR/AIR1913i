package com.example.mle;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

public class ViewPageAdapter extends FragmentPagerAdapter {

    private  int numberOfTabs;
    private  int userId;

    public ViewPageAdapter(FragmentManager childFragmentManager,int numberOfTabs, int userId) {

        super(childFragmentManager);
        this.numberOfTabs = numberOfTabs;
        this.userId = userId;
    }

    public ViewPageAdapter(FragmentManager childFragmentManager) {
        super(childFragmentManager);
    }

    @NonNull
    @Override
    public Fragment getItem(int position) {
        switch (position){
            case 0:
                Bundle b = new Bundle();
                b.putInt("UserId",userId);
                ProjectFragment pf = new ProjectFragment();
                pf.setArguments(b);

                return  pf;

            case 1:
                Bundle b2 = new Bundle();
                b2.putInt("UserId",userId);
                ChartFragment pf2 = new ChartFragment();
                pf2.setArguments(b2);

                return  pf2;

            default:
                return null;
        }

       // return StatisticFragment.getInstance(position);
    }

    @Override
    public int getCount() {
        return numberOfTabs;
    }

    @Override
    public int getItemPosition(@NonNull Object object) {
        return  POSITION_NONE;
    }
}
