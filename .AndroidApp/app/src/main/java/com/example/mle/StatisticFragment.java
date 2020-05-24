package com.example.mle;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.anychart.AnyChart;
import com.anychart.AnyChartView;
import com.anychart.chart.common.dataentry.DataEntry;
import com.anychart.chart.common.dataentry.ValueDataEntry;
import com.anychart.charts.Pie;

import java.util.ArrayList;
import java.util.List;

public class StatisticFragment extends Fragment {

    private AnyChartView anyChartView;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return  inflater.inflate(R.layout.fragment_statistics,container,false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        anyChartView = (AnyChartView) view.findViewById(R.id.any_chart_view);

        initChartData();
    }

    private void initChartData() {

        Pie pieChart = AnyChart.pie();
        List<DataEntry> dataEntries = new ArrayList<>();

        dataEntries.add(new ValueDataEntry("Broj označenih primjera",45));
        dataEntries.add(new ValueDataEntry("Broj neoznačenih",35));


        pieChart.data(dataEntries);
        anyChartView.setChart(pieChart);
    }


}
