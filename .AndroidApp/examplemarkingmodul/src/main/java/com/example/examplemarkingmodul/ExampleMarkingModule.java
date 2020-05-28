package com.example.examplemarkingmodul;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Fragment;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.example.core.DataInterface;
import com.example.database.DB;

import java.util.ArrayList;
import java.util.List;

import com.example.core.DataInterface;

@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class ExampleMarkingModule extends Fragment implements DataInterface {

    private Context context;
    private List<DB.SubCategory> subCategories;
    private DB.Marked marking;
    private LinearLayout layout;
    private RelativeLayout rl;
    private int X;
    private int Y;
    private static int ID;

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
    public void setData(List<DB.SubCategory> subCategories, DB.Marked marking, int X, int Y) {
        this.subCategories = subCategories;
        this.marking = marking;
        this.X = X - 85;
        this.Y = Y + 250;

        ShowDialog();
    }

    private List<Integer> Buttons = new ArrayList<>();

    @SuppressLint("ResourceType")
    @RequiresApi(api = Build.VERSION_CODES.M)
    private void ShowDialog() {
        final LinearLayout ll = new LinearLayout(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        ll.setLayoutParams(params);
        ll.setMinimumHeight(50);
        ll.setMinimumWidth(200);
        ll.setTranslationX(X);
        ll.setTranslationY(Y);
        ll.setVisibility(View.GONE);
        ll.setOrientation(LinearLayout.VERTICAL);
        int redColorValue = Color.RED;
        ll.setBackgroundColor(redColorValue);
        ID = View.generateViewId();
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
            // TODO
            //  ako nisam klikno ni na jedan gumb, sakrij ga

            Button btn = new Button(context);
            btn.setId(subCategories.get(i).Id);
            final int subcategoryId = btn.getId();
            btn.setText(subCategories.get(i).Name);

            LinearLayout.LayoutParams paramz = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            paramz.setMargins(0, 20, 0, 0);

            ll.setVisibility(View.VISIBLE);
            ll.addView(btn, paramz);
            btn = (Button) ll.findViewById(subcategoryId);
            btn.setBackgroundColor(Color.parseColor(subCategories.get(i).Color));
            btn.setPadding(10, 10, 10, 10);
            btn.setWidth(200);

            Buttons.add(subcategoryId);

            btn.setOnClickListener(new View.OnClickListener() {
                @RequiresApi(api = Build.VERSION_CODES.O)
                public void onClick(View view_) {
                    ll.setVisibility(View.GONE);
                    marking.SubcategoryId = subcategoryId;

                    DB.Marked.SaveMarkedEntity(marking);
                }
            });
        }
    }
}
