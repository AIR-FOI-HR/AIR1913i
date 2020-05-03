package com.example.mle;

import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.util.List;

public class ExampleHelper {

    protected static int StartIndex;
    protected static int EndIndex;

    public static class ExampleDocument{
        public int Id;
        public Document document;
    }

    public static class Node{
        public int Index;
        public Element Entity;
    }

    protected static String findWord(String str, int offset) {
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

        // removing unnecessary chars at the end of the word
        char last = str.charAt(endIndex - 1);
        if (last == ',' || last == '.' || last == '!' || last == '?' || last == ':' || last == ';') {
            endIndex--;
        }

        StartIndex = startIndex;
        EndIndex = endIndex;
        //TODO (X) dohvatiti cijelu ili dio rečenice tako da se može usporediti
//        if(startIndex > 10) {
//            startIndex = startIndex - 10;
//        }
//        if(str.length() > endIndex + 10){
//            endIndex = endIndex + 10;
//        }
        return str.substring(startIndex, endIndex);
    }

    public static ExampleHelper.Node GetClosestEntity(int n, List<ExampleHelper.Node> ls){
        int distance = Math.abs(ls.get(0).Index - n);
        int idx = 0;
        for(int c = 1; c < ls.size(); c++){
            int cdistance = Math.abs(ls.get(c).Index - n);
            if(cdistance < distance){
                idx = c;
                distance = cdistance;
            }
        }
        return ls.get(idx);
    }
}

