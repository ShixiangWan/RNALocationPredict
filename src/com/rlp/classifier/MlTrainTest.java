package com.rlp.classifier;

/**
 * Created by Shixiang Wan on 2016/11/6.
 */

import mulan.classifier.MultiLabelOutput;
import mulan.classifier.lazy.MLkNN;
import mulan.data.MultiLabelInstances;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;

import java.io.*;
import java.util.ArrayList;
import java.util.IdentityHashMap;

public class MlTrainTest {
    int index = 0;
    double max = 0.0;

    public static void main(String[] args) {
        /*String fasta_file = "E:\\RNA\\test.fasta";
        String csv_file = "E:\\RNA\\test.csv";
        String test_arff = "E:\\RNA\\test.arff";

        MlTrainTest mlTrainTest = new MlTrainTest();
        mlTrainTest.format_fasta(fasta_file);
        mlTrainTest.pse_extract(fasta_file, csv_file, test_arff, 17);*/

        MlTrainTest mlTrainTest = new MlTrainTest();
        String test_arff = "E:\\RNA\\three-class\\upload.arff";
        String train_arff = "E:\\RNA\\three-class\\RNA-all-PC-PseDNC-General-other.arff";
        String mulan_xml = "E:\\RNA\\three-class\\mulan-labels-other.xml";
        mlTrainTest.train_test(train_arff, test_arff, mulan_xml);
    }

    public IdentityHashMap train_test(String train_arff, String test_arff, String mulan_xml) {
        try {
            MultiLabelInstances train_set = new MultiLabelInstances(train_arff, mulan_xml);
            Instances test_set = new ConverterUtils.DataSource(test_arff).getDataSet();

            IdentityHashMap<Integer, Double> total_results = new IdentityHashMap<>();
            MLkNN classifier = new MLkNN();
            classifier.build(train_set);
            for (int i = 0; i < test_set.numInstances(); i++) {
                MultiLabelOutput multiLabelOutput = classifier.makePrediction(test_set.instance(i));
                get_result(multiLabelOutput.getConfidences());
                total_results.put(new Integer(index), max);
            }

            System.out.println(total_results);
            return total_results;
        } catch (Exception e) {
            e.getStackTrace();
        }
        return null;
    }

    public void get_result(double[] confidences) {
        index = 0;
        max = 0.0;
        for (int i=0; i<confidences.length; i++) {
            if (confidences[i] > max) {
                index = i+1;
                max = confidences[i];
            }
        }
    }

    /*pse-in-one提取特征，并生成arff文件*/
    public void pse_extract(String root_path, String fasta_file, String csv_file, String arff_file, int label_num) {
    	try {
    		String command = "python "+root_path+"pse.py "+fasta_file+" "+csv_file+" 3 0.2 RNA PC-PseDNC-General -f csv";
            Process process = Runtime.getRuntime().exec(command);
    		process.waitFor();

            /*提取原始特征数据*/
            BufferedReader bufferedReader = new BufferedReader(new FileReader(csv_file));
            ArrayList<String> data = new ArrayList<>();
            String line;
            while (bufferedReader.ready()) {
                line = bufferedReader.readLine();
                if (line.equals("") || line == null) {
                    continue;
                }
                line = line.replace("\n", "");
                data.add(line);
            }

            int dimension = data.get(0).split(",").length;
            BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(arff_file));
            bufferedWriter.write("@relation RNA"+"\n");
            for (int i=0; i<dimension; i++) {
                bufferedWriter.write("@attribute Feature"+String.valueOf(i+1)+" real"+"\n");
            }
            bufferedWriter.write("@attribute class1 {0,1}\n" +
                    "@attribute class2 {0,1}\n" +
                    "@attribute class3 {0,1}\n" +
                    "@attribute class4 {0,1}\n" +
                    "@attribute class37 {0,1}\n" +
                    "@attribute class5 {0,1}\n" +
                    "@attribute class16 {0,1}\n" +
                    "@attribute class7 {0,1}\n" +
                    "@attribute class9 {0,1}\n" +
                    "@attribute class12 {0,1}\n" +
                    "@attribute class17 {0,1}\n" +
                    "@attribute class23 {0,1}\n" +
                    "@attribute class8 {0,1}\n" +
                    "@attribute class24 {0,1}\n" +
                    "@attribute class32 {0,1}\n" +
                    "@attribute class34 {0,1}\n" +
                    "@attribute class35 {0,1}\n" +
                    "@attribute class38 {0,1}\n" +
                    "@attribute class39 {0,1}\n");
            line = "";
            for (int i=0; i<label_num; i++) {
                line += ","+"0";
            }
            bufferedWriter.write("@data"+"\n");

            for (int i=0; i<data.size(); i++) {
                bufferedWriter.write(data.get(i)+line+"\n");
            }
            bufferedReader.close();
            bufferedWriter.close();
    	} catch (InterruptedException | IOException e) {
    		e.printStackTrace();
    	}
    }

    public void format_fasta(String fasta_file) {
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(fasta_file));
            String line = "";
            ArrayList<String> fasta_data = new ArrayList<>();
            int ensure = 0;
            while(bufferedReader.ready()) {
                line = bufferedReader.readLine();
                if (line.equals("") || line == null) {
                    continue;
                }
                if (line.startsWith(">")) {
                    ensure -= 1;
                } else {
                    ensure += 1;
                }
                fasta_data.add(line.replace("\n", ""));
            }
            if (ensure >= 1) {
                BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(fasta_file));
                for (int i=0; i<fasta_data.size(); i++) {
                    if (fasta_data.get(i).startsWith(">")) {
                        bufferedWriter.write(fasta_data.get(i)+"\n");
                        line = "";
                        i++;
                        while(i<fasta_data.size()) {
                            if (fasta_data.get(i).startsWith(">")) {
                                i--;
                                break;
                            } else {
                                line += fasta_data.get(i);
                                i++;
                            }
                        }
                        bufferedWriter.write(line+"\n");
                    }
                }
                bufferedWriter.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
