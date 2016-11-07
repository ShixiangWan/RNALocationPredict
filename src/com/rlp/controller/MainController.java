package com.rlp.controller;

/**
 * Created by Shixiang Wan on 2016/11/6.
 */

import com.rlp.classifier.MlTrainTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.IdentityHashMap;

@Controller
public class MainController implements ServletContextAware{
	private ServletContext servletContext;
	@Autowired
	public void setServletContext(ServletContext context) {
		this.servletContext  = context;
	}
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="predict", method = RequestMethod.POST)
	public ModelAndView handleUploadData(@RequestParam("paste")String paste, Model map){
		try {
            String root_path = this.servletContext.getRealPath("/");
            if (!paste.isEmpty()){
                /*写入粘贴的序列内容*/
				BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(root_path+"upload/upload.fasta"));
				bufferedWriter.write(paste);
				bufferedWriter.flush();
				bufferedWriter.close();
			} else {
			    /*序列为空*/
				map.addAttribute("error", "No data!");
				return new ModelAndView("index");
			}

            MlTrainTest mlTrainTest = new MlTrainTest();
            String fasta_file = root_path+"upload/upload.fasta";
            String csv_file = root_path+"upload/upload.csv";
            String test_arff = root_path+"upload/upload.arff";

			/*将上传的文件进行格式化整理，删除空行*/
            mlTrainTest.format_fasta(fasta_file);

            /*调用pseinone提取特征, inner是17个标签，outer是3个标签，other是19个标签*/
            mlTrainTest.pse_extract(root_path, fasta_file, csv_file, test_arff, 19);

			/*调用weka和mulan进行model预测*/
            String train_arff = root_path+"data/model/RNA-all-PC-PseDNC-General-other.arff";
            String mulan_xml = root_path+"data/model/mulan-labels-other.xml";
            IdentityHashMap<Integer, Double> total_results = mlTrainTest.train_test(train_arff, test_arff, mulan_xml);

            return new ModelAndView("index", "mymap", total_results);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("index");
	}
}
