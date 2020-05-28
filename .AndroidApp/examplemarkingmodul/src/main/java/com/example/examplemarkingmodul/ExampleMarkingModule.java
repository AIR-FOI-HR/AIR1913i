package com.example.examplemarkingmodul;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Fragment;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.text.Html;
import android.text.method.ScrollingMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.example.core.DataInterface;
import com.example.database.DB;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.example.core.DataInterface;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class ExampleMarkingModule extends Fragment implements DataInterface {

    private Context context;
    private List<DB.SubCategory> subCategories;
    private DB.Marked marking;
    private RelativeLayout rl;
    private TextView name;
    private int eId;
    private int X;
    private int Y;
    private static int ID;
    private int randomHash = 1561562;

    @Override
    public void setContext(Context context, RelativeLayout rl) {
        this.context = context;
        this.rl = rl;
    }

    public void checkVisibility(RelativeLayout rl) {
        LinearLayout ll = (LinearLayout) rl.findViewById(ID);
        if (ll != null) {
            ll.setVisibility(View.GONE);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void setData(int ExampleId, TextView name, List<DB.SubCategory> subCategories, DB.Marked marking, int X, int Y) {
        this.subCategories = subCategories;
        this.marking = marking;
        this.X = X - 100;
        this.Y = Y - 300;
        this.name = name;
        this.eId = ExampleId;

        ShowDialog();
    }

    private List<Integer> Buttons = new ArrayList<>();

    @SuppressLint("ResourceType")
    @RequiresApi(api = Build.VERSION_CODES.M)
    private void ShowDialog() {
        final LinearLayout ll = new LinearLayout(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        ll.setLayoutParams(params);
        ll.setMinimumHeight(15);
        ll.setMinimumWidth(50);

        ll.setTranslationX(X);
        ll.setTranslationY(Y);
        ll.setVisibility(View.GONE);
        ll.setOrientation(LinearLayout.HORIZONTAL);

        ID = View.generateViewId() + randomHash;
        ll.setId(ID);

        rl.addView(ll);

        if (Buttons.size() > 0) {
            for (int i = 0; i < Buttons.size(); i++) {
                Button btn = (Button) ll.findViewById(Buttons.get(i));
                ViewGroup layout = (ViewGroup) btn.getParent();
                if (layout != null)
                    layout.removeView(btn);
            }
            Buttons.clear();
        }

        for (int i = 0; i < subCategories.size(); i++) {

            Button btn = new Button(context);
            btn.setId(subCategories.get(i).Id);
            final int subcategoryId = btn.getId();
//            btn.setText(subCategories.get(i).Name);

            LinearLayout.LayoutParams paramz = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            paramz.width = 80;
            paramz.height = 35;
            paramz.setMargins(0, 20, 0, 0);

            ll.setVisibility(View.VISIBLE);
            ll.addView(btn, paramz);
            btn.setBackgroundColor(Color.parseColor(subCategories.get(i).Color));
            btn.setWidth(10);
            btn.setLeft(0);

            Buttons.add(subcategoryId);

            btn.setOnClickListener(new View.OnClickListener() {
                @RequiresApi(api = Build.VERSION_CODES.O)
                public void onClick(View view_) {
                    ll.setVisibility(View.GONE);
                    marking.SubcategoryId = subcategoryId;

                    DB.Marked.SaveMarkedEntity(marking);

                    DB.Example e = DB.Example.GetExampleById(eId);
                    Document doc = Jsoup.parse(e.Content);
                    Elements entities = doc.getElementsByClass("entity");
                    ChangeEntityColor(entities);

                    name.setText(Html.fromHtml(doc.html().replace("class=\"entity\"", "style=\"background-color:#9dc1fa;\"")), TextView.BufferType.SPANNABLE);
                }
            });
        }
    }

    private void ChangeEntityColor(Elements entities) {
        for (int i = 0; i < entities.size(); i++) {
            if (entities.get(i).id() == "")
                continue;

            DB.Marked mark = DB.Marked.GetMarkedEntity(eId, Integer.parseInt(entities.get(i).parent().id()), Integer.parseInt(entities.get(i).id().replaceAll("\\D+", "")));
            String color = DB.SubCategory.GetSubcategoryColor(mark.SubcategoryId);
            if (color != "") {
                entities.get(i).attributes().remove("style");
                entities.get(i).attributes().add("style", "background-color: " + color);
            }
        }
    }
}
