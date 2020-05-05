package com.example.mle;

import android.annotation.SuppressLint;
import android.app.Activity;
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
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.ArrayList;
import java.util.List;

public class FirstFragment extends Fragment {

    @SuppressLint("ClickableViewAccessibility")
    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public View onCreateView(
            LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState
    ) {
        View view = inflater.inflate(R.layout.fragment_first, container, false);

        final ExampleHelper.ExampleDocument ed = PopulateExamples(view);

        final TextView tv = (TextView) view.findViewById(R.id.tvText);
        final Button btn = (Button) view.findViewById(R.id.button_first);
        final TextView tt = (TextView) view.findViewById(R.id.indexes);

        tv.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if (motionEvent.getAction() == MotionEvent.ACTION_DOWN) {
                    int mOffset = tv.getOffsetForPosition(motionEvent.getX(), motionEvent.getY());
                    String sentence = Html.fromHtml(ExampleHelper.findWord(tv.getText().toString(), mOffset, true)).toString();
                    String word = Html.fromHtml(ExampleHelper.findWord(tv.getText().toString(), mOffset, false)).toString();
                    // TODO:
                    //  ako background color na kliknutu riječ bijela onda NIJE ENTITET

                    Elements entities = ed.document.getElementsByClass("entity");
                    List<ExampleHelper.Node> ls = new ArrayList<>();

                    for (int i = 0; i < entities.size(); i++) {
                        String tt = entities.get(i).text();
                        String entitySentence = entities.get(i).parent().text();
                        if (word.equals(tt)) {
                            String[] splitted_sentence = sentence.split(" ");

                            int occurrences = 0;
                            for (int j = 0; j < splitted_sentence.length; j++) {
                                if (entitySentence.indexOf(splitted_sentence[j]) >= 0) {
                                    occurrences++;
                                }
                            }

                            ExampleHelper.Node node = new ExampleHelper.Node();
                            node.Entity = entities.get(i);
                            node.Index = ed.document.html().indexOf(entities.get(i).parent().html());
                            node.Occurrences = occurrences;
                            ls.add(node);
                        }
                    }

                    List<Integer> indexes = new ArrayList<>();
                    List<ExampleHelper.Node> filtered_ls = ExampleHelper.FilterEntities(ls);

                    if (filtered_ls.size() > 0) {
                        ExampleHelper.Node closestEntity = ExampleHelper.GetClosestEntity(ExampleHelper.StartIndex, filtered_ls);
                        String SentenceID = closestEntity.Entity.parent().id();
                        String EntityID = closestEntity.Entity.id();
                        String Word = closestEntity.Entity.text();

                        tt.setText(Word + ";" + EntityID + ";" + SentenceID);
                        // TODO: Save to DB
                    } else {
                        tt.setText("Niste odabrali entitet");
                    }
                }
                return false;
            }
        });

        return view;
    }

    public void onViewCreated(@NonNull final View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        view.findViewById(R.id.button_first).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                NavHostFragment.findNavController(FirstFragment.this)
                        .navigate(R.id.action_FirstFragment_to_SecondFragment);
            }
        });
    }

    @SuppressLint("SetTextI18n")
    @RequiresApi(api = Build.VERSION_CODES.O)
    private ExampleHelper.ExampleDocument PopulateExamples(View v) {
        TextView tv = (TextView) v.findViewById(R.id.tvText);
//        List<DB.Example> list = DB.Example.GetAllExamples();

        DB.Example e = DB.Example.GetExampleById(60);

        // jsoup parse
        Document doc = Jsoup.parse(e.Content);
        tv.setText(Html.fromHtml(doc.html().replace("class=\"entity\"", "style=\"background-color:#9dc1fa;\"")));

        tv.setMovementMethod(new ScrollingMovementMethod());

        TextView title = (TextView) v.findViewById(R.id.tvTitle);
        title.setText("Primjer br." + e.Id);

        ExampleHelper.ExampleDocument ed = new ExampleHelper.ExampleDocument();
        ed.Id = e.Id;
        ed.document = doc;

        return ed;
    }
}
