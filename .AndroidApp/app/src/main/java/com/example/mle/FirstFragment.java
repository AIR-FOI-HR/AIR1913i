package com.example.mle;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.Html;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.method.ScrollingMovementMethod;
import android.text.style.ClickableSpan;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.widget.PopupMenu;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Attribute;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FirstFragment extends Fragment {

    public int ExampleID = 0;

    @SuppressLint("ClickableViewAccessibility")
    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public View onCreateView(
            LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState
    ) {
        final View view = inflater.inflate(R.layout.fragment_first, container, false);

        final ExampleHelper.ExampleDocument ed = PopulateExamples(view);

        final TextView tv = (TextView) view.findViewById(R.id.tvText);
        final TextView tt = (TextView) view.findViewById(R.id.indexes);
        final LinearLayout linear = (LinearLayout) view.findViewById(R.id.dialog);

        tv.setOnTouchListener(new View.OnTouchListener() {
            @SuppressLint("ResourceType")
            @Override
            public boolean onTouch(View _view, MotionEvent motionEvent) {
                if (motionEvent.getAction() == MotionEvent.ACTION_DOWN) {
                    int mOffset = tv.getOffsetForPosition(motionEvent.getX(), motionEvent.getY());
                    String sentence = Html.fromHtml(ExampleHelper.findWord(tv.getText().toString(), mOffset, true)).toString();
                    String word = Html.fromHtml(ExampleHelper.findWord(tv.getText().toString(), mOffset, false)).toString();

                    if (linear.getVisibility() == View.VISIBLE) {
                        linear.setVisibility(View.GONE);
                        return false;
                    }

                    if (word == "")
                        return false;

                    Elements entities = ed.document.getElementsByClass("entity");
                    List<ExampleHelper.Node> ls = new ArrayList<>();

                    for (int i = 0; i < entities.size(); i++) {
                        String tt = entities.get(i).text();
                        String entitySentence = entities.get(i).parent().text();
                        if (word.equals(tt)) {
                            String[] splitted_sentence = sentence.split(" ");

                            int occurrences = 0;
                            for (int j = 0; j < splitted_sentence.length; j++)
                                if (splitted_sentence[j].length() > 3)
                                    if (entitySentence.indexOf(splitted_sentence[j]) >= 0)
                                        occurrences++;

                            ExampleHelper.Node node = new ExampleHelper.Node();
                            node.Entity = entities.get(i);
                            node.Index = ed.document.html().indexOf(entities.get(i).parent().html());
                            node.Occurrences = occurrences;
                            ls.add(node);
                        }
                    }

                    List<ExampleHelper.Node> filtered_ls = ExampleHelper.FilterEntities(ls);
                    if (filtered_ls.size() > 0) {
                        ExampleHelper.Node closestEntity = ExampleHelper.GetClosestEntity(ExampleHelper.StartIndex, filtered_ls);
                        int SentenceID = 0, EntityID = 0;
                        //String Word = "";
                        DB.Marked marking = new DB.Marked();

                        if(closestEntity.Entity.parent().id() != "" && closestEntity.Entity.id() != "" && closestEntity.Entity.text() != ""){
                            SentenceID = Integer.parseInt(closestEntity.Entity.parent().id());
                            EntityID = Integer.parseInt(closestEntity.Entity.id().replaceAll("\\D+", ""));
                            //Word = closestEntity.Entity.text();

                            marking.SentenceId = SentenceID;
                            marking.EntityId = EntityID;
                            marking.ExampleId = ExampleID;
                        }

                        // TODO:
                        //  Show categories -> Choose subcategory DONE
                        //  Save to DB
                        //  Change color of entity

                        List<DB.SubCategory> subCategories = DB.SubCategory.GetSubCategoriesByExampleId(ExampleID);
                        ShowDialog(linear, view, subCategories, marking);

                    } else {
                        tt.setText("Niste odabrali entitet");
                    }
                }
                return false;
            }
        });

        return view;
    }

    private List<Integer> Buttons = new ArrayList<>();

    @SuppressLint("ResourceType")
    private void ShowDialog(final LinearLayout linear, final View view, List<DB.SubCategory> subCategories, final DB.Marked marking) {

        if (Buttons.size() > 0) {
            for (int i = 0; i < Buttons.size(); i++) {
                Button btn = (Button) view.findViewById(Buttons.get(i));
                ViewGroup layout = (ViewGroup) btn.getParent();
                if (layout != null)
                    layout.removeView(btn);
            }
            Buttons.clear();
        }

        for (int i = 0; i < subCategories.size(); i++) {
            Button btn = new Button(getContext());
            btn.setId(subCategories.get(i).Id);
            final int subcategoryId = btn.getId();
            btn.setText(subCategories.get(i).Name);

            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            params.setMargins(0, 20, 0, 0);

            linear.setVisibility(View.VISIBLE);
            linear.addView(btn, params);
            btn = (Button) view.findViewById(subcategoryId);
            btn.setBackgroundColor(Color.parseColor(subCategories.get(i).Color));

            Buttons.add(subcategoryId);

            btn.setOnClickListener(new View.OnClickListener() {
                @RequiresApi(api = Build.VERSION_CODES.O)
                public void onClick(View view_) {
                    linear.setVisibility(View.GONE);

                    marking.SubcategoryId = subcategoryId;
                    DB.Marked.SaveMarkedEntity(marking);
                    PopulateExamples(view);

                    //Toast.makeText(view.getContext(), "Button clicked index = " + subcategoryId, Toast.LENGTH_SHORT).show();
                }
            });
        }
    }

    public void onViewCreated(@NonNull final View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
//        view.findViewById(R.id.button_first).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                NavHostFragment.findNavController(FirstFragment.this)
//                        .navigate(R.id.action_FirstFragment_to_SecondFragment);
//            }
//        });
    }

    @SuppressLint("SetTextI18n")
    @RequiresApi(api = Build.VERSION_CODES.O)
    private ExampleHelper.ExampleDocument PopulateExamples(View v) {
        TextView tv = (TextView) v.findViewById(R.id.tvText);
//        List<DB.Example> list = DB.Example.GetAllExamples();

        DB.Example e = DB.Example.GetExampleById(60);
        ExampleID = e.Id;

        // jsoup parse
        Document doc = Jsoup.parse(e.Content);
        Elements entities = doc.getElementsByClass("entity");
        ChangeEntityColor(entities);

        tv.setText(Html.fromHtml(doc.html().replace("class=\"entity\"", "style=\"background-color:" + ExampleHelper.EntityColor + ";\"")), TextView.BufferType.SPANNABLE);
        tv.setMovementMethod(new ScrollingMovementMethod());

        TextView title = (TextView) v.findViewById(R.id.tvTitle);
        title.setText("Primjer br." + e.Id);

        ExampleHelper.ExampleDocument ed = new ExampleHelper.ExampleDocument();
        ed.Id = e.Id;
        ed.document = doc;

        return ed;
    }

    private void ChangeEntityColor(Elements entities) {
        for (int i = 0; i < entities.size(); i++) {
            if (entities.get(i).id() == "")
                continue;

            DB.Marked mark = DB.Marked.GetMarkedEntity(ExampleID, Integer.parseInt(entities.get(i).parent().id()), Integer.parseInt(entities.get(i).id().replaceAll("\\D+", "")));
            String color = DB.SubCategory.GetSubcategoryColor(mark.SubcategoryId);
            if (color != "") {
                entities.get(i).attributes().remove("style");
                entities.get(i).attributes().add("style", "background-color: " + color);
            }
        }
    }

    private String ConvertRGBtoHEX(String color) {
        int index = color.indexOf("rgb");
        if (index == -1)
            return color;

        int start = color.indexOf("(") + 1;
        int end = color.indexOf(")");

        if (start == -1 || end == -1)
            return color;

        String[] rgb = color.substring(start, end).split(",");
        if (rgb.length != 3)
            return color;

        return String.format("background-color: #%02x%02x%02x", Integer.parseInt(rgb[0].trim()), Integer.parseInt(rgb[1].trim()), Integer.parseInt(rgb[2].trim()));
    }
}
