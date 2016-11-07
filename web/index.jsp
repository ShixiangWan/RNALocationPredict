<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE>
<html>
  <head>
    <base href="<%=basePath%>">
    <link rel="shortcut icon" href="icon.ico" type="image/x-icon" />
    <title>RLP</title>
	<link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/jquery-2.1.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/echarts-all.js"></script>
    <style type="text/css">
	      body {
	              padding-top: 100px;
	            }
    </style>
  </head>
  
  <body>
  		<!-- 导航栏 -->
    	<jsp:include page="header.jsp" />
    	
    	<div class="container">
    		<div class="row">
				<div class="col-md-4">
					<img src="img/force.jpg" style="width:360px;"/>
				</div>
				<div class="col-md-8">
					<div style="font-size:50px; padding: 0;">RNALocationPredict</div>
					<h4 class="text-muted">Predict Location of RNA Sequences Accurately and Efficiently</h4>
					<hr style="width:100%;margin:3px;"/>
					<form class="form-horizontal" action="predict.do" method="post" enctype="multipart/form-data">
					<fieldset>
						<div class="form-group">
					      <label for="textArea" class="col-lg-2 control-label">Fasta Seq:</label>
					      <div class="col-lg-9">
					        <textarea name="paste" class="form-control" rows="3" id="textArea" style="height:150px;" onchange="check(this)">&gt;100040529|XR_875058|Gm2824
UCUUUGGCUAGGGGAGGGGAGGAACAAUCAACUCUCCUCCCAUAUGCUUUAACUUCCAUGUCUAUUUUGCCAUUAUCCCUUCUGUUAUGAUAUGAUUAAUGAGAGCUCUCCUGAAUCUCUAAACACCCUGAAAAGCAGCCAAUCCCUUCUCUUUGGAGGCUACAUUGAAAAUAACAAUAAAAGUGA</textarea>
					        <span class="help-block">Paste your fasta RNA sequences, then predict theirs location in cell.<strong><span class="text-danger"> ${requestScope.error}</span></strong></span>
					        <button type="submit" class="btn btn-primary">Predict</button>
					        <button type="submit" class="btn btn-warning">Example Predict</button>
					      </div>
					    </div>
					</fieldset>
					</form>
				</div>

                <c:if test="${empty requestScope.mymap}">
                    <!-- 简介模块 -->
                    <h1 style="height: 300px;"></h1>
                    <div class="col-md-4">
                    <h4>Multi-location Analysis</h4>
                    <p>RNA sequences maybe come from different locations here and there. Moreover, multi-hierarchy and large data are bigger challenges for classification. We recommend that running on your local computer after downloading the <a href="#">RLP</a>.</p>
                    </div>
                    <div class="col-md-4">
                    <h4>Visualization</h4>
                    <p>With the Echarts visualization tool, the site displays the exact location of intracellular and extracellular predictions for you. Based on the visualization force diagram, more understandings about the RNA sequences will be known.</p>
                    </div>
                    <div class="col-md-4">
                    <h4>Precise Model</h4>
                    <p>Based on adequate RNA data set, our team constructed the RNA Location Predict (RLP) machine learning model. We have got more accurate results about multi-label and multi-hierarchy problems. We hope this work will help you.</p>
                    </div>
                </c:if>
                <c:if test="${not empty requestScope.mymap}">
                    <%-- 表格结果展示 --%>
                    <h2>Predicted Result</h2>
                    <table class="table table-striped table-hover ">
                        <thead>
                        <tr class="warning">
                            <th>Your Seq Order</th>
                            <th>Predicted Location</th>
                            <th>Probability</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:set var="index" value="0" />
                        <c:forEach items="${requestScope.mymap}" var="m">
                            <c:set var="index" value="${index+1}" />
                            <tr onclick="select(${m.key})" class="warning">
                                <td>${index}</td>
                                <td class="result_key">${m.key}</td>
                                <td>${m.value}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <!-- Echarts结果展示 -->
                    <h2>Visualization <small>By Clicking Specific Result</small></h2>
                    <div class="col-md-12 alert alert-dismissible alert-warning">
                        <div id="main" style="width: 100%;height:100%;"></div>
                    </div>
                </c:if>


				<!-- 引用模块 -->
				<%--<div class="col-md-12 alert alert-dismissible alert-info">
	                 <p><strong>Cite Halign Server in a publication:</strong><br>
	                     [1]. Quan Zou, Qinghua Hu, Maozu Guo, Guohua Wang. HAlign: Fast Multiple Similar DNA/RNA Sequence Alignment Based on the Centre Star Strategy. Bioinformatics. 2015,31(15): 2475-2481. (<a target="_bank" href="http://bioinformatics.oxfordjournals.org/cgi/reprint/btv177?ijkey=CbHd7aTXctZ4Ofv&keytype=ref">link</a>)
	                     <br>
	                     [2]. Quan Zou, Xubin Li, Wenrui Jiang, Ziyu Lin, Guilin Li, Ke Chen. Survey of MapReduce Frame Operation in Bioinformatics. Briefings in Bioinformatics. 2014,15(4): 637-647
	                 </p>
				</div>--%>

				<!-- 底部栏 -->
				<hr style="width:100%;margin:3px;"/>
				<p style="text-align:center;" class="text-muted">Bioinformatics Laboratory - Tianjin University @ <a target="_blank" href="http://lab.malab.cn/~shixiang/">Shixiang Wan</a></p>
			</div>
    	</div>

        <script type="text/javascript">
            /* 检查文件格式 */
            function check(thiz){
                var value = $(thiz).val();
                var group = value.split("\n");
                for (var i=0; i<group.length; i++) {
                    if (group[i].indexOf(">")<0) {
                        for (var j=0; j<group[i].length; j++) {
                            if (group[i][j]!="A" && group[i][j]!="U" && group[i][j]!="C" && group[i][j]!="G") {
                                alert("Your sequences contain illegal character!");
                                return;
                            }
                        }
                    }
                }
            }

            $(document).ready(function(e) {
                $(".result_key").each(function(){
                    var num = $(this).html();
                    var name = "";
                    if (num == 0) name = 'All';
                    if (num == 1) name = 'Anterior';
                    if (num == 2) name = 'Apical';
                    if (num == 3) name = 'Axon';
                    if (num == 4) name = 'Basal';
                    if (num == 5) name = 'Cell body';
                    if (num == 6) name = 'Cell cortex';
                    if (num == 7) name = 'Cell junction';
                    if (num == 8) name = 'Cell leading edge';
                    if (num == 9) name = 'Cellular bud';
                    if (num == 10) name = 'Centrosome';
                    if (num == 11) name = 'Chloroplast';
                    if (num == 12) name = 'Circulating';
                    if (num == 13) name = 'Cytoplasm';
                    if (num == 14) name = 'Cytoskeleton';
                    if (num == 15) name = 'Cytosol';
                    if (num == 16) name = 'Dendrite';
                    if (num == 17) name = 'Dorsal';
                    if (num == 18) name = 'Endoplasmic reticulum';
                    if (num == 19) name = 'Exosome';
                    if (num == 20) name = 'Extracellular vesicle';
                    if (num == 21) name = 'Germ plasm';
                    if (num == 22) name = 'Golgi apparatus';
                    if (num == 23) name = 'Growth cone';
                    if (num == 24) name = 'Lamellipodium';
                    if (num == 25) name = 'Lysosome';
                    if (num == 26) name = 'Microvesicle';
                    if (num == 27) name = 'Mitochondrion';
                    if (num == 28) name = 'Mitotic spindle';
                    if (num == 29) name = 'Nucleolus';
                    if (num == 30) name = 'Nucleoplasm';
                    if (num == 31) name = 'Nucleus';
                    if (num == 32) name = 'Perinuclear';
                    if (num == 33) name = 'Peroxisome';
                    if (num == 34) name = 'Posterior';
                    if (num == 35) name = 'Pseudopodium';
                    if (num == 36) name = 'Ribosome';
                    if (num == 37) name = 'Somatodendritic compartment';
                    if (num == 38) name = 'Synapse';
                    if (num == 39) name = 'Vegetal';
                    if (num == 40) name = 'Intracellular region';
                    if (num == 41) name = 'Extracellular region';
                    if (num == 42) name = 'Others';
                    $(this).html(name);
                });
                select(-1);
            });

            function select(order) {
                var jsonobj = [
                    {category:4, name: '0', value : 20, label: 'All'},
                    /* {category:1, name: '40',value : 10, label: 'Intracellular region', itemStyle:{normal:{borderColor: '#D64343', borderWidth: 4}}}, */
                    {category:1, name: '40',value : 10, label: 'Intracellular region'},
                    {category:1, name: '31',value : 2, label: 'Nucleus'},
                    {category:1, name: '13',value : 2, label: 'Nucleolus'},
                    {category:1, name: '29',value : 2, label: 'Nucleoplasm'},
                    {category:1, name: '30',value : 2, label: 'Cytoplasm'},
                    {category:1, name: '14',value : 2, label: 'Cytoskeleton'},
                    {category:1, name: '10',value : 2, label: 'Centrosome'},
                    {category:1, name: '28',value : 2, label: 'Mitotic spindle'},
                    {category:1, name: '6',value : 2, label: 'Cell cortex'},
                    {category:1, name: '11',value : 2, label: 'Chloroplast'},
                    {category:1, name: '15',value : 2, label: 'Cytosol'},
                    {category:1, name: '18',value : 2, label: 'Endoplasmic reticulum'},
                    {category:1, name: '21',value : 2, label: 'Germ plasm'},
                    {category:1, name: '22',value : 2, label: 'Golgi apparatus'},
                    {category:1, name: '25',value : 2, label: 'Lysosome'},
                    {category:1, name: '27',value : 2, label: 'Mitochondrion'},
                    {category:1, name: '36',value : 2, label: 'Ribosome'},
                    {category:1, name: '33',value : 2, label: 'Peroxisome'},
                    {category:2, name: '41',value : 2, label: 'Extracellular region'},
                    {category:2, name: '20',value : 2, label: 'Extracellular vesicle'},
                    {category:2, name: '26',value : 2, label: 'Microvesicle'},
                    {category:2, name: '19',value : 2, label: 'Exosome'},
                    {category:3, name: '42',value : 2, label: 'Others'},
                    {category:3, name: '1',value : 2, label: 'Anterior'},
                    {category:3, name: '2',value : 2, label: 'Apical'},
                    {category:3, name: '3',value : 2, label: 'Axon'},
                    {category:3, name: '4',value : 2, label: 'Basal'},
                    {category:3, name: '7',value : 2, label: 'Cell junction'},
                    {category:3, name: '9',value : 2, label: 'Cellular bud'},
                    {category:3, name: '17',value : 2, label: 'Dorsal'},
                    {category:3, name: '12',value : 2, label: 'Circulating'},
                    {category:3, name: '23',value : 2, label: 'Growth cone'},
                    {category:3, name: '32',value : 2, label: 'Perinuclear'},
                    {category:3, name: '35',value : 2, label: 'Pseudopodium'},
                    {category:3, name: '34',value : 2, label: 'Posterior'},
                    {category:3, name: '38',value : 2, label: 'Synapse'},
                    {category:3, name: '37',value : 2, label: 'Somatodendritic compartment'},
                    {category:3, name: '5',value : 2, label: 'Cell body'},
                    {category:3, name: '16',value : 2, label: 'Dendrite'},
                    {category:3, name: '39',value : 2, label: 'Vegetal'},
                    {category:3, name: '8',value : 2, label: 'Cell leading edge'},
                    {category:3, name: '24',value : 2, label: 'Lamellipodium'},
                ];

                for (var i=0; i<jsonobj.length; i++) {
                    if (jsonobj[i].name == order) {
                        jsonobj[i].itemStyle = {normal:{color: '#D64343', borderWidth: 16}};
                    }
                }

                // 基于准备好的dom，初始化echarts实例
                var myChart = echarts.init(document.getElementById('main'));

                // 指定图表的配置项和数据
                var option = {
                    title : {
                        text: 'Red Circle: Predicted Location\n',
                        subtext: '',
                        x:'right',
                        y:'bottom'
                    },
                    tooltip : {
                        trigger: 'item',
                        formatter: '{a} : {b}'
                    },
                    toolbox: {
                        show : true,
                        feature : {
                            restore : {show: true},
                            magicType: {show: true, type: ['force', 'chord']},
                            saveAsImage : {show: true}
                        }
                    },
                    legend: {
                        x: 'left',
                        data:['Inner','Outer', 'Other']
                    },
                    series : [
                        {
                            type:'force',
                            name : "Location",
                            ribbonType: false,
                            categories : [
                                {
                                    name: ''
                                },
                                {
                                    name: 'Inner'
                                },
                                {
                                    name: 'Outer'
                                },
                                {
                                    name: 'Other'
                                },
                                {
                                    name:'True'
                                },
                                {
                                    name: 'Predicted'
                                }
                            ],
                            itemStyle: {
                                normal: {
                                    label: {
                                        show: true,
                                        textStyle: {
                                            color: '#333'
                                        }
                                    },
                                    nodeStyle : {
                                        brushType : 'both',
                                        borderColor : 'rgba(255,215,0,0.4)',
                                        borderWidth : 1
                                    },
                                    linkStyle: {
                                        type: 'curve'
                                    }
                                },
                                emphasis: {
                                    label: {
                                        show: false
                                        // textStyle: null      // 默认使用全局文本样式，详见TEXTSTYLE
                                    },
                                    nodeStyle : {
                                        //r: 30
                                    },
                                    linkStyle : {}
                                }
                            },
                            useWorker: false,
                            minRadius : 15,
                            maxRadius : 25,
                            gravity: 1.1,
                            scaling: 1.1,
                            roam: 'move',
                            nodes:jsonobj,
                            links : [
                                /* 绘制第一大类连接线 */
                                {source : '0', target : '40', weight : 1},
                                {source : '40', target : '31', weight : 1},
                                {source : '40', target : '13', weight : 1},
                                {source : '31', target : '29', weight : 1},
                                {source : '31', target : '30', weight : 1},
                                {source : '13', target : '14', weight : 1},
                                {source : '14', target : '10', weight : 1},
                                {source : '14', target : '28', weight : 1},
                                {source : '13', target : '6', weight : 1},
                                {source : '13', target : '11', weight : 1},
                                {source : '13', target : '15', weight : 1},
                                {source : '13', target : '18', weight : 1},
                                {source : '13', target : '21', weight : 1},
                                {source : '13', target : '22', weight : 1},
                                {source : '13', target : '25', weight : 1},
                                {source : '13', target : '27', weight : 1},
                                {source : '13', target : '36', weight : 1},
                                {source : '13', target : '33', weight : 1},
                                /* 绘制第二大类连接线 */
                                {source : '0', target : '41', weight : 1},
                                {source : '41', target : '20', weight : 1},
                                {source : '20', target : '26', weight : 1},
                                {source : '20', target : '19', weight : 1},
                                /* 绘制第三大类连接线 */
                                {source : '0', target : '42', weight : 1},
                                {source : '42', target : '1', weight : 1},
                                {source : '42', target : '2', weight : 1},
                                {source : '42', target : '3', weight : 1},
                                {source : '42', target : '4', weight : 1},
                                {source : '42', target : '7', weight : 1},
                                {source : '42', target : '9', weight : 1},
                                {source : '42', target : '17', weight : 1},
                                {source : '42', target : '12', weight : 1},
                                {source : '42', target : '23', weight : 1},
                                {source : '42', target : '32', weight : 1},
                                {source : '42', target : '35', weight : 1},
                                {source : '42', target : '34', weight : 1},
                                {source : '42', target : '38', weight : 1},
                                {source : '42', target : '39', weight : 1},
                                {source : '42', target : '8', weight : 1},
                                {source : '8', target : '24', weight : 1},
                                {source : '42', target : '37', weight : 1},
                                {source : '37', target : '5', weight : 1},
                                {source : '37', target : '16', weight : 1}
                            ]
                        }
                    ]
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);
            }
        </script>
  </body>
</html>
