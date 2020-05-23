package com.example.mle;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.example.mle.R;

import java.util.HashMap;
import java.util.List;

public class ExpandableListAdapter extends BaseExpandableListAdapter {
    private Context context;
    private List<String> listTitle;
    private HashMap<String,List<String>> listItem;

    public ExpandableListAdapter(Context context, List<String> listTitle, HashMap<String, List<String>> listItem) {
        this.context = context;
        this.listTitle = listTitle;
        this.listItem = listItem;
    }

    @Override
    public int getGroupCount() {
        return listTitle.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return listItem.get(listTitle.get(groupPosition)).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return listTitle.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return listItem.get(listTitle.get(groupPosition)).get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        String listTitle = (String)getGroup(groupPosition);

        if(convertView == null){

            convertView = LayoutInflater.from(context).inflate(R.layout.list_group,null);
        }

        TextView lblListHeader = (TextView)convertView.findViewById(R.id.listTitle);
        lblListHeader.setTypeface(null, Typeface.BOLD);
        lblListHeader.setText(listTitle);

        return  convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        String listTitle = (String)getChild(groupPosition,childPosition);

        if(convertView == null){

            convertView = LayoutInflater.from(context).inflate(R.layout.list_item,null);
        }

        TextView txtChild = (TextView)convertView.findViewById(R.id.exandableListItem);
        txtChild.setText(listTitle);

        return  convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }
}
