# RNALocationPredict
RNA位置预测网站。访问地址为：http://server.malab.cn/RNALocationPredict/index.jsp

###1. 开发环境

* Operate System: Windows 8.1
* IDE: Intellij IDEA
* Server: Tomcat 9
* Language: Java 8
* MVC: Spring, Spring MVC
* Front: Bootstrap, Echarts

###2. 功能介绍

* 预测RNA序列位置：用户上传fasta格式的RNA序列后，点击`Predict`按钮，稍等片刻，页面将显示输入的每条序列预测结果，包含最终的预测位置及准确率。
  * Fasta数据规范化处理：若Fasta序列中包含换行、空行，程序将自动处理成规范格式;
  * RNA格式检查：若用户输入的序列中包含除`A`, `U`, `C`, `G`外的字符，将会弹出警告提示；
  
* 结果可视化：借助Echarts的`力导向布局图`，我们将39类细胞器可视化，最终的预测结果则根据用户点击来动态高亮显示，非常直观。

###3. 升级日志

* 2016-11-06 version0.1
  * 部署网站




