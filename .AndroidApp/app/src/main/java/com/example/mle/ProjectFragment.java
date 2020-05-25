package com.example.mle;

import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;

import com.anychart.AnyChart;
import com.anychart.AnyChartView;
import com.anychart.chart.common.dataentry.DataEntry;
import com.anychart.chart.common.dataentry.ValueDataEntry;
import com.anychart.charts.Pie;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

public class ProjectFragment extends Fragment {

    private AnyChartView anyChartView;
    private List<DB.Example> userExamples;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_statistics, container, false);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        anyChartView = (AnyChartView) view.findViewById(R.id.any_chart);

        initChartData();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void initChartData() {

        Bundle bundle = this.getArguments();
        int userId = bundle.getInt("UserId");

        final List<DB.UserExample> userExampleList = DB.UserExample.GetUserExamplesByUserId(userId);

        List<DB.Project> projects = DB.Project.GetAllProjects();
        List<DB.Example> exampleList = DB.Example.GetAllExamples();

        List<Integer> exampleIds = new ArrayList<>();

        for (int i = 0; i < userExampleList.size(); i++) {

            exampleIds.add(userExampleList.get(i).ExampleId);
        }

        userExamples = (List<DB.Example>) exampleList.stream().filter(e -> exampleIds.contains(e.Id)).collect(Collectors.toList());

        List<Integer> projectIds = new ArrayList<>();

        for (int i = 0; i < userExamples.size(); i++) {

            if (!projectIds.contains(userExamples.get(i).ProjectId)) {
                projectIds.add(userExamples.get(i).ProjectId);
            }
        }

        projects = projects.stream().filter(p -> projectIds.contains(p.Id)).collect(Collectors.toList());






        Pie pieChart = AnyChart.pie();
        List<DataEntry> dataEntries = new ArrayList<>();

        for (int i = 0; i < projects.size(); i++) {
            int numberOfExamples= 0;
            for (int j = 0; j < userExamples.size(); j++) {
                if (userExamples.get(j).ProjectId == projects.get(i).Id) {
                    numberOfExamples++;
                }

            }
            dataEntries.add(new ValueDataEntry(projects.get(i).Name,numberOfExamples));

            //projectExamples.put(projects.get(i).Name, numberOfExamples);
        }






        /*dataEntries.add(new ValueDataEntry("Broj označenih primjera",45));
        dataEntries.add(new ValueDataEntry("Broj neoznačenih",35));*/


        pieChart.data(dataEntries);
        anyChartView.setChart(pieChart);
    }
}
