package com.example.mle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import android.content.Intent;
import android.os.Bundle;

import com.google.android.material.tabs.TabItem;
import com.google.android.material.tabs.TabLayout;

public class StatisticActivity extends AppCompatActivity {


    private TabLayout tabLayout;
    private ViewPager viewPager;
    private ViewPageAdapter pageAdapter;
    private TabItem tabProjects;
    private TabItem tabExamples;
    private  int UserId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.statistics_tabs);

        Intent i = getIntent();
        UserId = Integer.parseInt(i.getExtras().get("UserId").toString());


        tabLayout = findViewById(R.id.tabLayoutView);
        tabProjects = (TabItem) findViewById(R.id.tab_project);
        tabExamples = findViewById(R.id.tabExamples);

        viewPager = findViewById(R.id.viewPager);

        pageAdapter = new ViewPageAdapter(getSupportFragmentManager(),tabLayout.getTabCount(),UserId);

        viewPager.setAdapter(pageAdapter);

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

    }
}
