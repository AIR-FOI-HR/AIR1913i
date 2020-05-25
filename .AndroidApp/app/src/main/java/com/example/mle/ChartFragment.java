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
import com.anychart.charts.Cartesian;
import com.anychart.charts.Pie;
import com.anychart.core.cartesian.series.Column;
import com.anychart.enums.Anchor;
import com.anychart.enums.HoverMode;
import com.anychart.enums.Position;
import com.anychart.enums.TooltipPositionMode;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ChartFragment extends Fragment {

    private AnyChartView anyChartView;
    private List<DB.Example> userExamples;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_chart, container, false);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        anyChartView = (AnyChartView) view.findViewById(R.id.example_chart);

        initChartData();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void initChartData() {

        Bundle bundle = this.getArguments();
        int userId = bundle.getInt("UserId");

        List<DB.UserExample> userExampleList = DB.UserExample.GetUserExamplesByUserId(userId);
        
        userExampleList = userExampleList.stream().distinct().collect(Collectors.toList());
        
        String exampleId = "";
        
        StringBuilder sb = new StringBuilder();
        
        for(int i = 0; i < userExampleList.size(); i++){

            Integer eId = (Integer)userExampleList.get(i).ExampleId;

            exampleId = eId.toString();

            sb.append(exampleId+ ",");

            exampleId = "";

        }

        sb.substring(0,sb.length()-1);

        exampleId = sb.toString().substring(0,sb.length()-1);

        List<DB.Marked> markedExample = DB.Marked.GetMarkedByExampleIds(exampleId);
        List<DB.Example> exampleList = DB.Example.GetAllExamples();

        List<Integer> exampleIds = new ArrayList<>();

        for (int i = 0; i < userExampleList.size(); i++) {

            exampleIds.add(userExampleList.get(i).ExampleId);
        }

        userExamples = (List<DB.Example>) exampleList.stream().filter(e -> exampleIds.contains(e.Id)).collect(Collectors.toList());

        Cartesian cartesianChart = AnyChart.cartesian();
        List<DataEntry> dataEntries = new ArrayList<>();

        for (int i = 0; i < userExamples.size(); i++) {
            int numberOfSubcategories= 0;
            for (int j = 0; j < markedExample.size(); j++) {
                if (markedExample.get(j).ExampleId == userExamples.get(i).Id) {
                    numberOfSubcategories++;
                }

            }
            dataEntries.add(new ValueDataEntry(userExamples.get(i).Name,numberOfSubcategories));
        }


        Column column = cartesianChart.column(dataEntries);

        column.tooltip().titleFormat("{%X}")
                .position(Position.CENTER_BOTTOM)
                .anchor(Anchor.CENTER_BOTTOM)
                .offsetX(0d)
                .offsetY(5d)
                .format("{%Value}{groupsSeparator: }");

        cartesianChart.animation(true);
        cartesianChart.title("Broj podkategorija svakog primjera");

        cartesianChart.yScale().minimum(0d);

        cartesianChart.yAxis(0).labels().format("{%Value}{groupsSeparator: }");

        cartesianChart.tooltip().positionMode(TooltipPositionMode.POINT);
        cartesianChart.interactivity().hoverMode(HoverMode.BY_X);

        cartesianChart.xAxis(0).title("Primjer");
        cartesianChart.yAxis(0).title("Broj subkategorija");


        //cartesianChart.data(dataEntries);
        anyChartView.setChart(cartesianChart);
    }
}
