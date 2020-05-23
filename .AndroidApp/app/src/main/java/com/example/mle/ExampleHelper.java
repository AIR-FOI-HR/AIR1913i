package com.example.mle;

import android.net.UrlQuerySanitizer;
import android.os.Build;

import androidx.annotation.RequiresApi;

import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import static java.util.Comparator.comparing;

public class ExampleHelper {

    protected static int StartIndex;
    protected static int EndIndex;
    protected static String EntityColor = "#9dc1fa";

    public static class ExampleDocument {
        public int Id;
        public Document document;
    }

    public static class Node {
        public int Index;
        public Element Entity;
        public int Occurrences;
    }

    protected static String findWord(String str, int offset, boolean getSentence) {
        // handling exception if touching end of the text
        if (str.length() == offset) {
            offset--;
        }
        if (str.charAt(offset) == ' ') {
            offset--;
        }

        int startIndex = offset;
        int endIndex = offset;

        try {
            while (str.charAt(startIndex) != ' ' && str.charAt(startIndex) != '\n') {
                startIndex--;
            }
        } catch (StringIndexOutOfBoundsException e) {
            startIndex = 0;
        }

        try {
            while (str.charAt(endIndex) != ' ' && str.charAt(endIndex) != '\n') {
                endIndex++;
            }
        } catch (StringIndexOutOfBoundsException e) {
            endIndex = str.length();
        }

        // one letter is choosen, ignore it!
        if(startIndex == endIndex)
            return "";

        // removing unnecessary chars at the end of the word
        char last = str.charAt(endIndex - 1);
        if (last == ',' || last == '.' || last == '!' || last == '?' || last == ':' || last == ';') {
            endIndex--;
        }

        StartIndex = startIndex;
        EndIndex = endIndex;

        if (getSentence) {
            if (startIndex > 20) {
                startIndex = startIndex - 19;
            }
            if (str.length() > endIndex + 20) {
                endIndex = endIndex + 19;
            }
        }

        return str.substring(startIndex, endIndex);
    }

    public static List<ExampleHelper.Node> FilterEntities(List<ExampleHelper.Node> ls) {
        List<ExampleHelper.Node> results = new ArrayList<>();

        // get max value of occurrences
        int max = 0;
        for(int i = 0; i < ls.size(); i++){
            int occ = ls.get(i).Occurrences;
            if(occ > max){
                max = occ;
            }
        }

        // get all elements that have max value
        for(int i = 0; i < ls.size(); i++){
            int occ = ls.get(i).Occurrences;
            // there will be always one occurrence that shouldn't be taken (main word is always one occurrence)
            if(occ == max && occ > 1){
                results.add(ls.get(i));
            }
        }

        return results;
    }

    public static ExampleHelper.Node GetClosestEntity(int n, List<ExampleHelper.Node> ls) {
        int distance = Math.abs(ls.get(0).Index - n);
        int idx = 0;
        for (int c = 1; c < ls.size(); c++) {
            int cdistance = Math.abs(ls.get(c).Index - n);
            if (cdistance < distance) {
                idx = c;
                distance = cdistance;
            }
        }
        return ls.get(idx);
    }

}

