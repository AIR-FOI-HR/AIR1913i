package com.example.mle;

import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

public class ProjectListFragment extends Fragment {
    private ExpandableListView expandableListView;
    private ExpandableListAdapter expandableListAdapter;
    private List<String> lstTitle;
    private HashMap<String, List<String>> lstChild;
    private List<DB.Example> userExamples;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_project_list, container, false);

        return view;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        expandableListView = (ExpandableListView) view.findViewById(R.id.expListView);


        initData();

        addDrawersItem();
    }

    private void addDrawersItem() {
        expandableListAdapter = new ExpandableListAdapter(requireContext(), lstTitle, lstChild);
        expandableListView.setAdapter(expandableListAdapter);

        expandableListView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.N)
            @Override
            public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
                String selectedItem = ((List) (lstChild.get(lstTitle.get(groupPosition))))
                        .get(childPosition).toString();

                Integer exampleId = 0;

                Optional<DB.Example> currentExample = userExamples.stream().filter(ue -> ue.Name == selectedItem).findFirst();

                exampleId = currentExample.get().Id;

                FirstFragment firstFragment = new FirstFragment();
                Bundle args = new Bundle();
                args.putInt("Example", exampleId);

                firstFragment.setArguments(args);

                getFragmentManager().beginTransaction().replace(R.id.fragment_container, firstFragment).commit();

                return true;
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void initData() {



        Bundle bundle = this.getArguments();

        int myInt = 0;
        myInt = bundle.getInt("UserId");


        final List<DB.UserExample> userExampleList = DB.UserExample.GetUserExamplesByUserId(1);
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

       /* List<String> title = Arrays.asList("projekt 1", "projekt 2", "projekt 3");
        List<String> childItem = Arrays.asList("primjer 1", "primjer 2", "primjer 3");
*/
        lstChild = new HashMap<>();

        for (int i = 0; i < projects.size(); i++) {
            List<String> exampleNames = new ArrayList<>();
            for (int j = 0; j < userExamples.size(); j++) {
                if (userExamples.get(j).ProjectId == projects.get(i).Id) {
                    exampleNames.add(userExamples.get(j).Name);
                }
            }

            lstChild.put(projects.get(i).Name, exampleNames);
        }

        lstTitle = new ArrayList<>(lstChild.keySet());
    }
}
