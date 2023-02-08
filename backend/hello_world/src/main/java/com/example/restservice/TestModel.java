package com.example.restservice;
import weka.classifiers.trees.J48;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;

public class TestModel {

  public static void main(String[] args) throws Exception {
    // Specifying the datasource
    DataSource dataSource = new DataSource("/Users/dolapoadedokun/Desktop/Trinity/diabetes.arff");
    // Loading the dataset
  
    Instances dataInstances = dataSource.getDataSet();
    // Displaying the number of instances
    System.out.println("The number of loaded instances is: " + dataInstances.numInstances());

    System.out.println("data:" + dataInstances.toString());
    System.out.println("The number of attributes in the dataset: " + dataInstances.numAttributes());
    dataInstances.setClassIndex(dataInstances.numAttributes() - 1);
    // Getting the number of 
    System.out.println("The number of classes: " + dataInstances.numClasses());
    J48 treeClassifier = new J48();
    treeClassifier.setOptions(new String[] { "-U" });
    treeClassifier.buildClassifier(dataInstances);
    
}
  }